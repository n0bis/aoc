#include <stdio.h>
#include <string.h>
#define MAX_LINE_LENGTH 5

int main() {
  FILE* file = fopen("day1.txt", "r");
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
      dial = (dir == 'L') ? (100 - dial) % 100 : dial;
      pwd += ((dial + num) / 100);
      dial = (dial + num) % 100;
      dial = (dir == 'L') ? (100 - dial) % 100 : dial;
      printf("Dial: %d\n", dial);
    }
  }

  fclose(file);

  printf("Password: %d\n", pwd);

  return 0;
}