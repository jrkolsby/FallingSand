SCREEN_HEIGHT = 10
SCREEN_WIDTH = 10 

screen = [['e'] * SCREEN_WIDTH] * SCREEN_HEIGHT

screen[0][5] = 's'

def update(screen):
    for i in range(len(screen)):
        for j in range(SCREEN_WIDTH-1):
            if screen[i][j] == 's':
                if (i+1 < SCREEN_HEIGHT and \
                    screen[i+1][j] == 'e'):
                    screen[i][j] = 'e'
                    screen[i+1][j] = 's'
                elif (i+1 < SCREEN_HEIGHT and j > 0 and \
                      screen[i+1][j-1] == 'e'):
                    screen[i][j] = 'e'
                    screen[i+1][j-1] = 's'
                elif (i+1 < SCREEN_HEIGHT and j+1 < SCREEN_WIDTH and \
                      screen[i+1][j+1] == 'e'): # BOTTOM RIGHT
                    screen[i][j] = 'e'
                    screen[i+1][j+1] = 's'

for i in range(0,20):
    print(screen)
    update(screen)
