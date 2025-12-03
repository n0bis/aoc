#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
  FILE* file = fopen("day3.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  char line[128];
  long long joltage = 0;
  while (fgets(line, sizeof(line), file) != NULL) {
    line[strcspn(line, "\n")] = '\0';
    int len = strlen(line);
    int digits = 12;
    int start = 0;
    char numstr[32];

    for (int i = 0; i < digits; i++) {
      int max = -1;
      int max_pos = -1;
      int end = len - (digits - i);
      for (int j = start; j <= end; j++) {
        int digit = line[j] - '0';
        if (digit > max) {
          max = digit;
          max_pos = j;
        }
      }
      start = max_pos + 1;
      numstr[i] = '0' + max;
    }
    numstr[digits] = '\0';
    joltage += atoll(numstr);
  }
  
  printf("Total joltage: %lld\n", joltage);
  fclose(file);
  return 0;
}