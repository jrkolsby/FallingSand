/* * Device driver for the VGA video generator
 *
 * A Platform device implemented using the misc subsystem
 *
 * Stephen A. Edwards
 * Columbia University
 *
 * References:
 * Linux source: Documentation/driver-model/platform.txt
 *               drivers/misc/arm-charlcd.c
 * http://www.linuxforu.com/tag/linux-device-drivers/
 * http://free-electrons.com/docs/
 *
 * "make" to build
 * insmod vga_ball.ko
 *
 * Check code style with
 * checkpatch.pl --file --no-tree vga_ball.c
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "vga_ball.h"
#include "usbkeyboard.h"

#define DRIVER_NAME "sand_top"

/* Device registers */
#define BG_RED(x) (x)
#define BG_GREEN(x) ((x)+1)
#define BG_BLUE(x) ((x)+2)
#define BALL_X(x) ((x)+3)
#define BALL_Y(x) ((x)+4)

struct libusb_device_handle *keyboard;

/*
 * Information about our device
 */
struct vga_ball_dev {
	struct resource res; /* Resource: our registers */
	void __iomem *virtbase; /* Where registers can be accessed in memory */
        vga_ball_color_t background;
	char ball_x;
	char ball_y;
} dev;

/*
 * Write segments of a single digit
 * Assumes digit is in range and the device information has been set up
 */
static void write_background(vga_ball_color_t *background)
{
	iowrite8(background->red, BG_RED(dev.virtbase) );
	iowrite8(background->green, BG_GREEN(dev.virtbase) );
	iowrite8(background->blue, BG_BLUE(dev.virtbase) );
	dev.background = *background;
}

static void write_coordinates(char *ball_x, char *ball_y)
{
	iowrite8(*ball_x, BALL_X(dev.virtbase) );
	iowrite8(*ball_y, BALL_Y(dev.virtbase) );
	dev.ball_x = *ball_x;
	dev.ball_y = *ball_y;
}

/*
 * Handle ioctl() calls from userspace:
 * Read or write the segments on single digits.
 * Note extensive error checking of arguments
 */
static long vga_ball_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	vga_ball_arg_t vla;

	switch (cmd) {
	case VGA_BALL_WRITE_BACKGROUND:
		if (copy_from_user(&vla, (vga_ball_arg_t *) arg,
				   sizeof(vga_ball_arg_t)))
			return -EACCES;
		write_background(&vla.background);
		break;

	case VGA_BALL_READ_BACKGROUND:
	  	vla.background = dev.background;
		if (copy_to_user((vga_ball_arg_t *) arg, &vla,
				 sizeof(vga_ball_arg_t)))
			return -EACCES;
		break;
	case VGA_BALL_WRITE_COORDINATES:
		if (copy_from_user(&vla, (vga_ball_arg_t *) arg,
				sizeof(vga_ball_arg_t)))
			return -EACCES;
		write_coordinates(&vla.ball_x, &vla.ball_y);
		break;

	default:
		return -EINVAL;
	}

	return 0;
}

/* The operations our device knows how to do */
static const struct file_operations vga_ball_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl = vga_ball_ioctl,
};

/* Information about our device for the "misc" framework -- like a char dev */
static struct miscdevice vga_ball_misc_device = {
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME,
	.fops		= &vga_ball_fops,
};

/*
 * Initialization code: get resources (registers) and display
 * a welcome message
 */
static int __init vga_ball_probe(struct platform_device *pdev)
{	
	if ((keyboard = openkeyboard(&endpoint_address)) == NULL ) {
		fprintf(stderr, "Did not find a keyboard\n");
    		exit(1);
  		}
	
        vga_ball_color_t yellow = { 0xff, 0xbe, 0x03 };
	int ret;

	/* Register ourselves as a misc device: creates /dev/vga_ball */
	ret = misc_register(&vga_ball_misc_device);

	/* Get the address of our registers from the device tree */
	ret = of_address_to_resource(pdev->dev.of_node, 0, &dev.res);
	if (ret) {
		ret = -ENOENT;
		goto out_deregister;
	}

	/* Make sure we can use these registers */
	if (request_mem_region(dev.res.start, resource_size(&dev.res),
			       DRIVER_NAME) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

	/* Arrange access to our registers */
	dev.virtbase = of_iomap(pdev->dev.of_node, 0);
	if (dev.virtbase == NULL) {
		ret = -ENOMEM;
		goto out_release_mem_region;
	}
        
	/* Set an initial color */
        write_background(&yellow);
        write_coordinates();
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* Look for and handle keypresses */
	for (;;) {
		libusb_interrupt_transfer(keyboard, endpoint_address,
			      (unsigned char *) &packet, sizeof(packet),
			      &transferred, 0);
		if (transferred == sizeof(packet)) {
			sprintf(keystate, "%02x %02x %02x", packet.modifiers, packet.keycode[0],
			packet.keycode[1]);
			printf("%s\n", keystate);
			fbputs(keystate, 0, 56);
			if (packet.keycode[0] == 0x29) { /* ESC pressed? */
				fbclear();
				break;
			}
			if (packet.keycode[0] == 0x28) { //Enter
				int r, c;
				char message_out[BUFFER_SIZE];

				fbprint(message);

				strncpy(message_out, message[0], BUFFER_SIZE/2);
				strncpy(message_out+BUFFER_SIZE/2, message[1], BUFFER_SIZE/2);

				send_to_server(message_out);

				for (c = 0; c < 64; c++) {
					for (r = 0; r < 2; r++) {
						message[r][c] = ' ';
					}
				}

				for (r = 22; r < 24; r++) {
					for (c = 0; c < 64; c++) {
						fbputchar(' ', r, c);
					}
				}

				fbputchar('_', 22, 0);
				incol = 0;
				inrow = 22;
				startfix = 0;
			}      

			if (packet.keycode[0] == 0x2a) { //Bksp
				if ((inrow == 23) & (incol == 0)) { 
					message[1][0] = ' ';
					message[0][63] = '_';
					fbputchar(' ', 23, 0);
					fbputchar('_', 22, 63);
					inrow = 22;
					incol = 63;
				}
				else if (incol >  0) {
					message[inrow-22][incol] = ' ';
					message[inrow-22][incol-1] = '_';
					fbputchar(' ', inrow, incol);
					fbputchar('_', inrow, incol-1);
					incol--;
				}
				goto bksp_skip;
			}

			if (startfix == 0) {
				incol = 0;
				startfix = 1;
			}
			char in = getkey(keystate);
			if ((in != '\0') & (in != lastchar)) {
				if (incol < 63) {
					message[inrow-22][incol] = in;
					fbputchar(in, inrow, incol);
					fbputchar('_', inrow, incol + 1);
					incol++;
				}
				else if ((incol == 63) & (inrow == 22)){
					message[0][63] = in;
					fbputchar(in, 22, 63);
					fbputchar('_', 23, 0);
					incol = 0;
					inrow = 23;
				}
			}
			lastchar = in;
			fbputchar(getkey(keystate), 0, 54);
			bksp_skip:;
	}
}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////

	return 0;

out_release_mem_region:
	release_mem_region(dev.res.start, resource_size(&dev.res));
out_deregister:
	misc_deregister(&vga_ball_misc_device);
	return ret;
}

/* Clean-up code: release resources */
static int vga_ball_remove(struct platform_device *pdev)
{
	iounmap(dev.virtbase);
	release_mem_region(dev.res.start, resource_size(&dev.res));
	misc_deregister(&vga_ball_misc_device);
	return 0;
}

/* Which "compatible" string(s) to search for in the Device Tree */
#ifdef CONFIG_OF
static const struct of_device_id vga_ball_of_match[] = {
	{ .compatible = "jjtech,sand_top-1.0" },
	{},
};
MODULE_DEVICE_TABLE(of, vga_ball_of_match);
#endif

/* Information for registering ourselves as a "platform" driver */
static struct platform_driver vga_ball_driver = {
	.driver	= {
		.name	= DRIVER_NAME,
		.owner	= THIS_MODULE,
		.of_match_table = of_match_ptr(vga_ball_of_match),
	},
	.remove	= __exit_p(vga_ball_remove),
};

/* Called when the module is loaded: set things up */
static int __init vga_ball_init(void)
{
	pr_info(DRIVER_NAME ": init\n");
	return platform_driver_probe(&vga_ball_driver, vga_ball_probe);
}

/* Calball when the module is unloaded: release resources */
static void __exit vga_ball_exit(void)
{
	platform_driver_unregister(&vga_ball_driver);
	pr_info(DRIVER_NAME ": exit\n");
}

module_init(vga_ball_init);
module_exit(vga_ball_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stephen A. Edwards, Columbia University");
MODULE_DESCRIPTION("VGA ball driver");
