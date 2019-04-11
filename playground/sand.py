HEIGHT = 10
WIDTH = 10 

def update(screen):
    newscreen = screen.copy()
    for i in range(HEIGHT-1):
        for j in range(WIDTH-1):
            if screen[i][j] == 'X':
                if (i+1 < HEIGHT and \
                    screen[i+1][j] == '.'):
                    screen[i][j] = '.'
                    screen[i+1][j] = 'X'
                elif (i+1 < HEIGHT and j > 0 and \
                      screen[i+1][j-1] == '.'):
                    screen[i][j] = '.'
                    screen[i+1][j-1] = 'X'
                elif (i+1 < HEIGHT and j+1 < WIDTH and \
                      screen[i+1][j+1] == '.'): # BOTTOM RIGHT
                    screen[i][j] = '.'
                    screen[i+1][j+1] = 'X'

def render(screen):
    output = ""
    for i in range(len(screen)):
        for j in range(WIDTH-1):
            output += screen[i][j]
            output += " "
        output += "\n"
    print(output)

def add(screen, x, y):
    screen[x][y] = 'X'

screen = [['.' for x in range(WIDTH)] \
               for x in range(HEIGHT)]
screen[0][5] = 'X'
screen[1][5] = 'X'

render(screen)

while True:
    render(screen)
    x = int(input("X: "))
    y = int(input("Y: "))
    add(screen, x, y)
    update(screen)
