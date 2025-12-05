#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_FRESH_INGREDIENTS 1000
#define MAX_INGREDIENTS_IDS 1000
#define MAX_LINE_LENGTH 56

long long merge_ranges(long long ranges[][2], long long count) {
  if (count == 0) return 0;

  long long merged_index = 0;

  for (long long i = 1; i < count; i++) {
    if (ranges[merged_index][1] >= ranges[i][0]) {
      if (ranges[merged_index][1] < ranges[i][1]) {
        ranges[merged_index][1] = ranges[i][1];
      }
    } else {
      merged_index++;
      ranges[merged_index][0] = ranges[i][0];
      ranges[merged_index][1] = ranges[i][1];
    }
  }
  return merged_index + 1;
}

bool search_ranges(long long id, long long ranges[][2], long long count) {
  long long low = 0;
  long long high = count - 1;
  while (low <= high) {
    long long mid = (low + high) / 2;

    if (id < ranges[mid][0]) {
      high = mid - 1;
    } else if (id > ranges[mid][1]) {
      low = mid + 1;
    } else {
      return true;
    }
  }
  return false;
}

int compare_ranges(const void *a, const void *b) {
  long long diff = ((long long *)a)[0] - ((long long *)b)[0];
  return (diff > 0) - (diff < 0);
}

int main() {
  FILE* file = fopen("day5.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  long long ingredients[MAX_FRESH_INGREDIENTS][2];
  long long ids[MAX_INGREDIENTS_IDS];
  char line[MAX_LINE_LENGTH];
  long long range_count = 0;
  long long id_count = 0;
  bool parsing_ranges = true;

  while (fgets(line, sizeof(line), file)) {
    if (line[0] == '\n') {
      parsing_ranges = false;
      continue;
    }

    if (parsing_ranges) {
      sscanf(line, "%lld-%lld", &ingredients[range_count][0], &ingredients[range_count][1]);
      range_count++;
    } else {
      sscanf(line, "%lld", &ids[id_count++]);
    }
  }
  fclose(file);

  qsort(ingredients, range_count, sizeof(ingredients[0]), compare_ranges);
  range_count = merge_ranges(ingredients, range_count);

  long long available = 0;
  for (long long i = 0; i < id_count; i++) {
    if (search_ranges(ids[i], ingredients, range_count)) {
      available ++;
    }
  }
  printf("Available ingredient IDs that are fresh: %lld\n", available);
  return 0;
}