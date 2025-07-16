/*
Chapter 22: Single Shortest Path Problems
Given a weighted, directed graph G = (V, E) and a weight function w: E-> Real
mapping edges to real-valued weights, find a path p from a source vertex s to
every other vertex v in V. p is a list of traversed edges, such that the sum of
the weights of traversed edges is minimised. If multiple such paths exist, we
just need to find a valid one. If no such path exists, we return a sensible
value.
*/

#include <stdint.h>
#include <stdbool.h>

typedef int Index; // sentinel value -1 for nil

typedef struct Vertex {
  int64_t distance;
  Index parent;
} Vertex;

typedef struct Edge {
  Index start;
  Index end;
  double weight;
} Edge;

typedef struct Graph {
  int vertex_count;
  int edge_count;
  Vertex *vertices;
  Edge *edges;
} Graph;

Graph graph_create(int vertex_count, int edge_count, char *edge_string, double *weights);
void graph_destroy(Graph);
void graph_print(Graph);
Index parse_index_from_string(char *, int);
void graph_initialise_single_source(Graph *graph, Index start_vertex);
void graph_relax_edge(Graph *graph, Index edge_index);
bool graph_bellman_ford(Graph *graph, Index start_vertex); // return false if negative weight cycle found i.e. no finite length shortest path exists

