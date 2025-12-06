#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_ROWS 5
#define MAX_COLS 1000
#define MAX_LINE_LENGTH 3800

int main() {
  FILE* file = fopen("input.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  long grid[MAX_COLS][MAX_ROWS] = {0};
  int row = 0;
  char line[MAX_LINE_LENGTH];
  char ops[MAX_COLS];
  while (fgets(line, sizeof(line), file) != NULL) {
    if(strchr(line, '+') || strchr(line, '*')) {
      long op_col = 0;
      for (long i = 0; line[i] != '\0' && op_col < MAX_COLS; i++) {
        if (line[i] == '+' || line[i] == '*') {
          ops[op_col++] = line[i];
        }
      }
      break;
    }
    char *token = strtok(line, " ");
    int col = 0;
    while (token != NULL && col < MAX_COLS) {
      grid[col++][row] = atol(token);
      token = strtok(NULL, " ");
    }
    row++;
  }
  fclose(file);

  long long grand_total = 0;
  for (long j = 0; j < MAX_COLS; j++) {
    long long sum = grid[j][0];
    for (int i = 1; i < row; i++) {
      char op = ops[j];
      switch (op) {
        case '+':
          sum += grid[j][i];
          break;
        case '*':
          sum *= grid[j][i];
          break;
      }
    }
    grand_total += sum;
  }

  printf("Grand Total: %lld\n", grand_total);

  return 0;
}