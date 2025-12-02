#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int is_half_even(const char *num) {
  int len = strlen(num);
  if (len % 2 != 0) return 0;
  int half = len / 2;
  return strncmp(num, num + half, half) == 0;
}

bool is_repeated(const char *num) {
  int len = strlen(num);
    for (int seq_len = 1; seq_len <= len / 2; seq_len++) {
        if (len % seq_len != 0) continue;
        bool valid = true;
        for (int i = seq_len; i < len; i++) {
            if (num[i] != num[i % seq_len]) {
                valid = false;
                break;
            }
        }
        if (valid) return true;
    }
    return false;
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
    for (long long i = start; i <= end; i++) {
      char buf[32];
      sprintf(buf, "%lld", i);
      if (is_repeated(buf)) {
        invalid += i;
      }
    }
  }
  
  printf("Invalid count: %lld\n", invalid);

  fclose(file);
  return 0;
}