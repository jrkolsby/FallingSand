HEIGHT = 40
WIDTH = 30
EMPTY = 0

VECTOR = {
    0: [0,0,0,0],   # empty
    1: [5,4,6,0],   # sand
    2: [0,0,0,0],   # stone
    3: [2,1,3,0],   # smoke
    4: [1,3,4,5]    # fly
}

DISPLAY = {
    0: '.',
    1: 'S',
    2: 'X',
    3: '~',
    4: '*'
}

def check(screen, i, j, d):
    for k in d:

        if k == 0:
            return (i,j)

        elif (k in range(1,4)): 
            (_i,_j) = (i-1,j-2+k)

        elif (k in range(4,7)): 
            (_i,_j) = (i+1,j-5+k)

        elif (k in range(7,9)):
            (_i,_j) = (i,j-8+k)

        else:
            continue;

        if (_j in range(WIDTH) and \
            _i in range(HEIGHT) and \
            screen[_i][_j] == EMPTY):
            return (_i, _j)

    return (i,j)

def update(screen):
    output = ""
    nextscreen = [
            [EMPTY for y in range(WIDTH)] 
            for x in range(HEIGHT)]
    for i in range(HEIGHT):
        for j in range(WIDTH):
            output += DISPLAY[screen[i][j]]
            output += " "
            # IF NOT EMPTY
            if screen[i][j] > EMPTY: 
                p = screen[i][j]
                screen[i][j] = EMPTY
                d = VECTOR[p]
                (_i,_j) = check(screen, i, j, d)
                nextscreen[_i][_j] = p
        output += "\n"
    print(output)
    return nextscreen

def add(screen, x, y, particle):
    screen[x][y] = particle

screen = [[0 for x in range(WIDTH)] \
            for x in range(HEIGHT)]

screen[0][5] = 1
screen[1][5] = 1

while True:
    x = input("X: ")
    y = input("Y: ")
    p = input("0-4: ")
    if x != '' and y != '' and p != '':
        add(screen, int(x), int(y), int(p))
    screen = update(screen)
