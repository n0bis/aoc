#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define GRID_SIZE 200

int main() {
  FILE* file = fopen("day4.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  static const int neighbors[8][2] = {
      {-1, -1}, {-1, 0}, {-1, 1},
      {0, -1},          {0, 1},
      {1, -1},  {1, 0},  {1, 1}
  };

  char grid[GRID_SIZE][GRID_SIZE];
  int rows = 0;
  int cols = 0;
  while (fgets(grid[rows], GRID_SIZE, file) != NULL) {
    grid[rows][strcspn(grid[rows], "\n")] = 0;
    cols = strlen(grid[rows]);
    rows++;
  }
  fclose(file);

  int total = 0;
  int rolls_removed;
  do {
    rolls_removed = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == '.') continue;

        int rolls = 0;
        for (int n = 0; n < 8; n++) {
          int nr = r + neighbors[n][0];
          int nc = c + neighbors[n][1];
          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc] == '@') {
            rolls++;
          }
        }
        if (rolls < 4) {
          rolls_removed++;
          total++;
          grid[r][c] = '.';
        }
      }
    }
  } while (rolls_removed > 0);
  
  printf("Rolls total removed: %d\n", total);
  return 0;
}