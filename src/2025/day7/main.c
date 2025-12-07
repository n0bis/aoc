#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_ROWS 150
#define MAX_COLS 150
#define MAX_VERTICES (MAX_ROWS * MAX_COLS)

#define SPLIT '^'
#define START 'S'

int bfs(char *grid, int rows, int cols, int start) {
  int visited[MAX_VERTICES] = {0};
  int queue[MAX_VERTICES];
  int front = 0;
  int rear = 0;
  int splitted = 0;

  queue[rear++] = start;

  while (front < rear) {
    int pos = queue[front++];
    
    if (visited[pos] || pos >= rows * cols) {
      continue;
    }

    visited[pos] = 1;

    if (grid[pos] == SPLIT) {
      queue[rear++] = pos - 1; // LEFT
      queue[rear++] = pos + 1; // RIGHT
      splitted++;
    } else {
      queue[rear++] = pos + cols; // DOWN
    }
  }
  return splitted;
}

int main() {
  FILE* file = fopen("input.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  char lines[MAX_ROWS][MAX_COLS];
  int row_count = 0;

  while (fgets(lines[row_count], MAX_COLS, file) != NULL) {
    row_count++;
  }
  fclose(file);

  int col_count = strlen(lines[0]);
  char grid[MAX_VERTICES];
  int start_pos = -1;
  for (int row = 0; row < row_count; row++) {
    for (int col = 0; col < col_count; col++) {
      int pos = row * col_count + col;
      grid[pos] = lines[row][col];
      if (grid[pos] == START) {
        start_pos = pos;
      }
    }
  }

  int splitted = bfs(grid, row_count, col_count, start_pos);
  printf("Splitted: %d\n", splitted);

  return 0;
}