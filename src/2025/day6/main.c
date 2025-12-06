#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_ROWS 5
#define MAX_COLS 1000
#define MAX_LINE_LENGTH 3800

int main() {
  FILE* file = fopen("day6.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  char lines[MAX_ROWS][MAX_LINE_LENGTH];
  int row_count = 0;

  while (fgets(lines [row_count], MAX_LINE_LENGTH, file) != NULL) {
    row_count++;
  }
  fclose(file);

  int max_len = strlen(lines[0]);
  char op = '+';
  long long grand_total = 0;
  long long sum = 0;

  for (int col = 0; col < max_len; col++) {
    char last = lines[row_count - 1][col];

    if (last != ' ') {
      grand_total += sum;
      sum = 0;
      op = last;
    }

    long num = 0;
    for (int row = 0; row < row_count; row++) {
      unsigned char ch = lines[row][col];
      if (ch >= '0' && ch <= '9') {
        num = num * 10 + (ch - '0');
      }
    }

    if (num == 0) continue;

    if (sum == 0) {
      sum = num;
    } else {
      sum = (op == '+') ? (sum + num) : (sum * num);
    }
  }

  grand_total += sum;

  printf("Grand Total: %lld\n", grand_total);

  return 0;
}