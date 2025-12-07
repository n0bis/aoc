#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_ROWS 150
#define MAX_COLS 150
#define MAX_VERTICES (MAX_ROWS * MAX_COLS)

#define SPLIT '^'
#define START 'S'

long long timelines(char *grid, int rows, int cols, int start) {
  long long dp[MAX_VERTICES] = {0};

  for (int col = 0; col < cols; col++) {
    dp[(rows - 1) * cols + col] = 1;
  }

  for (int row = rows - 2; row >= 0; row--) {
    for (int col = 0; col < cols; col++) {
      int pos = row * cols + col;
      int down = pos + cols;

      if (grid[pos] == SPLIT) {
        long long left = (col > 0) ? dp[down - 1] : 0;
        long long right = (col < cols - 1) ? dp[down + 1] : 0;
        dp[pos] = left + right;
      } else {
        dp[pos] = dp[down];
      }
    }
  }
  return dp[start];
}

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
      splitted++;
      queue[rear++] = pos - 1; // LEFT
      queue[rear++] = pos + 1; // RIGHT
    } else {
      queue[rear++] = pos + cols; // DOWN
    }
  }
  return splitted;
}

int main() {
  FILE* file = fopen("day7.txt", "r");

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
  long long timelines_count = timelines(grid, row_count, col_count, start_pos);
  printf("Splitted: %d\n", splitted);
  printf("Timelines: %lld\n", timelines_count);

  return 0;
}