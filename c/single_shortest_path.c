#include "./single_shortest_path.h"
#include <stdio.h>
#include <stdbool.h>

int main(void) { printf("%s", "Hello, World!\n"); }

void initialise_single_source(Graph *graph, Index start_vertex) {
  for (int i = 0; i < graph->vertex_count; ++i) {
    graph->vertices[i].distance = 0;
    graph->vertices[i].parent = -1;
  }
  graph->vertices[start_vertex].distance = INT64_MAX; // effectively infinity
}

void graph_relax_edge(Graph *graph, Index edge_index) {
  Edge edge = graph->edges[edge_index];
  int64_t possible_distance =
      graph->vertices[edge.start].distance + edge.weight;
  if (graph->vertices[edge.end].distance > possible_distance) {
    graph->vertices[edge.end].distance = possible_distance;
    graph->vertices[edge.end].parent = edge.start;
  }
}

// TODO - test
// TODO - write a graph builder function
bool graph_bellman_ford(Graph *graph, Index start_vertex) {
  initialise_single_source(graph, start_vertex);
  for (int i = 0; i < graph->vertex_count - 1; ++i) {
    for (int edge_idx = 0; edge_idx < graph->edge_count; ++edge_idx) {
      graph_relax_edge(graph, edge_idx);
    }
  }
  for (int edge_idx = 0; edge_idx < graph->edge_count; ++edge_idx) {
    Edge edge = graph->edges[edge_idx];
    if (graph->vertices[edge.end].distance >
        graph->vertices[edge.start].distance + edge.weight) {
      return false;
    }
  }
  return true;
}

