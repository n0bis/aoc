#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_POINTS 1002
#define MAX_EDGES 500000

int parent[MAX_POINTS];
int size[MAX_POINTS];

int desc_comparator(const void *a, const void *b) {
  return *(int*)b - *(int*)a;
}

int comparator(const void *a, const void *b) {
    long long *e1 = (long long *)a;
    long long *e2 = (long long *)b;
    if (e1[2] < e2[2]) return -1;
    if (e1[2] > e2[2]) return 1;
    return 0;
  }

int findParent(int component) {
  if (parent[component] == component) return component;
  return parent[component] = findParent(parent[component]);
}

void unionSet(int u, int v) {
  u = findParent(u);
  v = findParent(v);
  if (u == v) return;
  parent[u] = v;
  size[v] += size[u];
  size[u] = 0;
}

int main() {
  FILE* file = fopen("day8.txt", "r");

  if (file == NULL) {
    perror("Error opening file");
    return -1;
  }

  static int points[MAX_POINTS][3];
  long long num_points = 0;
  while (fscanf(file, "%d,%d,%d", &points[num_points][0], 
                &points[num_points][1], &points[num_points][2]) == 3) {
    parent[num_points] = num_points;
    size[num_points] = 1;
    num_points++;
  }
  fclose(file);

  static long long edges[MAX_EDGES][3];
  int edge_count = 0;

  for (int i = 0; i < num_points; i++) {
    for (int j = i + 1; j < num_points; j++) {
      long long dx = points[i][0] - points[j][0];
      long long dy = points[i][1] - points[j][1];
      long long dz = points[i][2] - points[j][2];
      edges[edge_count][0] = i;
      edges[edge_count][1] = j;
      edges[edge_count][2] = dx * dx + dy * dy + dz * dz;
      edge_count++;
    }
  }

  qsort(edges, edge_count, sizeof(edges[0]), comparator);

  static int connections[MAX_POINTS][MAX_POINTS] = {0};
  
  int last_u = -1;
  int last_v = -1;
  for (int i = 0; i < edge_count; i++) {
    int u = edges[i][0];
    int v = edges[i][1];
    if (!connections[u][v]) {
      connections[u][v] = 1;
      connections[v][u] = 1;
      
      if (findParent(u) != findParent(v)) {
        unionSet(u, v);
        last_u = u;
        last_v = v;
        
        if (size[findParent(0)] == num_points) {
          break;
        }
      }
    }
  }

  long long result = (long long)points[last_u][0] * points[last_v][0];
  printf("Last connection: %d and %d\n", last_u, last_v);
  printf("X coordinates: %d × %d = %lld\n", points[last_u][0], points[last_v][0], result);

  return 0;
}