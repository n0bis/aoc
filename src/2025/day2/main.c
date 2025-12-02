#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int is_half_even(const char *num) {
  int len = strlen(num);
  if (len % 2 != 0) return 0;
  int half = len / 2;
  return strncmp(num, num + half, half) == 0;
}

int main() {
  FILE* file = fopen("day2.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  long long invalid = 0;
  long long start;
  long long end;
  while (fscanf(file, "%lld-%lld,", &start, &end) == 2) {
    //printf("Start: %lld, End: %lld\n", start, end);
    for (long long i = start; i <= end; i++) {
      char buf[32];
      sprintf(buf, "%lld", i);
      if (is_half_even(buf)) {
        invalid += i;
      }
    }
  }
  
  printf("Invalid count: %lld\n", invalid);

  fclose(file);
  return 0;
}