#include <stdio.h>
#include <string.h>

int main() {
  FILE* file = fopen("input.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  char line[128];
  int joltage = 0;
  while (fgets(line, sizeof(line), file) != NULL) {
    int max = -1;
    int len = strlen(line);
    int right_max[128] = {0};
    right_max[len - 1] = -1;
    for (int i = len - 2; i >= 0; i--) {
      int digit = line[i + 1] - '0';
      right_max[i] = digit > right_max[i + 1] ? digit : right_max[i + 1];
    }
    for (int i = 0; i < len - 1; i++) {
      int first = line[i] - '0';
      int second = right_max[i];
      if (second >= 0) {
        int val = first * 10 + second;
        if (val > max) max = val;
      }
    }

    joltage += max;
  }
  
  printf("Total joltage: %d\n", joltage); // expected 17359
  fclose(file);
  return 0;
}