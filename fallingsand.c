#include <stdio.h>

int main() {
    int gridSize, vIndex, hIndex, particleIndex;

    scanf("%d\n", &gridSize);

    char grid[gridSize][gridSize];
    char rowPlaceholder[gridSize];

    // Read grid layout from user input
    for (vIndex = 0; vIndex < gridSize; vIndex++) {
        fgets(rowPlaceholder, sizeof(grid), stdin);
        for (hIndex = 0; hIndex < gridSize; hIndex++)
            grid[vIndex][hIndex] = rowPlaceholder[hIndex];
    }

    // Do the simulation
    for (hIndex = 0; hIndex < gridSize; hIndex++) {
        for (vIndex = gridSize - 1; vIndex >= 0; vIndex--) {
            for (particleIndex = 0; (vIndex - particleIndex) >= 0; particleIndex++) {
                if (grid[vIndex][hIndex] == '#' || grid[vIndex - particleIndex][hIndex] == '#')
                    break;
                else if (grid[vIndex][hIndex] == ' ' && grid[vIndex - particleIndex][hIndex] == '.') {
                    grid[vIndex][hIndex] = '.';
                    grid[vIndex - particleIndex][hIndex] = ' ';
                    break;
                }
            }
        }
    }

    printf("\n\n");

    // Show the resulting grid
    for (vIndex = 0; vIndex < gridSize; vIndex++) {
        for (hIndex = 0; hIndex < gridSize; hIndex++)
            printf("%c", grid[vIndex][hIndex]);

        printf("\n");
    }

    return 0;
}
