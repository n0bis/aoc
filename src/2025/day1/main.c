#include <stdio.h>
#include <string.h>
#define MAX_LINE_LENGTH 5

int main() {
  FILE* file = fopen("input.txt", "r");
  int dial = 50;
  int pwd = 0;

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  char line[MAX_LINE_LENGTH];
  char dir;
  int num;
  while (fgets(line, sizeof(line), file) != NULL) {
    if (sscanf(line, "%c%d", &dir, &num) == 2) {
      int passes = 0;
      switch (dir) {
        case 'L':
          dial = (dial - num + 100) % 100;
          break;
        case 'R':
          dial = (dial + num) % 100;
          break;
      }
      if (dial == 0 && passes == 0) {
        pwd++;
      }
      printf("Dial: %d\n", dial);
    }
  }

  fclose(file);

  printf("Password: %d\n", pwd);

  return 0;
}