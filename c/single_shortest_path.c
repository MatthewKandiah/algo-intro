#include "./single_shortest_path.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

/*
  TODO - decide if we want to pass weights in as part of the same string as edges, or as a separate string / list
  - same string as edges feels like the easiest thing to read and understand
  - separate argument makes it easier to set a graph up with one set of vertices and edges and test repeatedly with different weights
  - passing a separate argument which is just an array of numbers avoids any string parsing
  - weights probably need to be a float, not an int
*/

int main(void) {
  Graph g = graph_create(10, 8, "1-1 1-2 2-1 3-4 5-4 4-5 5-1 3-5");
  graph_print(g);
}

void graph_print(Graph g) {
  printf("Graph:\n");
  printf("   Vertex Count: %d\n   Edge Count: %d\n", g.vertex_count, g.edge_count);

  printf("   Vertices:\n");
  for (int i = 0; i < g.vertex_count; ++i) {
    Vertex vertex = g.vertices[i];
    printf("   %4d. distance = %ld, parent = %d\n", i + 1, vertex.distance,
           vertex.parent);
  }

  printf("   Edges:\n");
  for (int i = 0; i < g.edge_count; ++i) {
    Edge edge = g.edges[i];
    printf("   %4d. start = %d, end = %d, weight = %ld\n", i + 1, edge.start,
           edge.end, edge.weight);
  }
}

typedef enum {
  START,
  END,
} GraphCreateParsingMode;

Graph graph_create(int vertex_count, int edge_count, char *edge_string) {
  Vertex *vertices = malloc(sizeof(Vertex) * vertex_count);
  Edge *edges = malloc(sizeof(Edge) * edge_count);

  int max_chars_in_edge_string = 0;
  int vertex_count_copy = vertex_count;
  while (vertex_count_copy > 0) {
    max_chars_in_edge_string++;
    vertex_count_copy /= 10;
  }

  char *start_chars_buf = malloc(sizeof(char) * max_chars_in_edge_string);
  char *end_chars_buf = malloc(sizeof(char) * max_chars_in_edge_string);
  int start_chars_count = 0;
  int end_chars_count = 0;

  int chars_read = 0;
  int edges_read = 0;
  GraphCreateParsingMode mode = START;
  while (edges_read < edge_count) {
    char value = edge_string[chars_read];
    switch (value) {
    case '\0':
      if (edges_read != edge_count - 1) {
        fprintf(stderr, "ERROR: end of edge string found before expected edge "
                        "count reached");
        exit(1);
      } else {
        Index start =
            parse_index_from_string(start_chars_buf, start_chars_count);
        Index end = parse_index_from_string(end_chars_buf, end_chars_count);
        edges[edges_read].start = start;
        edges[edges_read].end = end;
        edges[edges_read].weight = INT64_MIN;
        edges_read++;
      }
      break;
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      if (mode == START) {
        start_chars_buf[start_chars_count] = value;
        start_chars_count++;
      } else {
        end_chars_buf[end_chars_count] = value;
        end_chars_count++;
      }
      break;
    case ',':
    case ' ':
      if (mode == END) {
        mode = START;

        Index start =
            parse_index_from_string(start_chars_buf, start_chars_count);
        Index end = parse_index_from_string(end_chars_buf, end_chars_count);
        edges[edges_read].start = start;
        edges[edges_read].end = end;
        edges[edges_read].weight = INT64_MIN;
        edges_read++;

        start_chars_count = 0;
        end_chars_count = 0;
      } else {
        fprintf(stderr,
                "ERROR: unexpected ',' or ' ' character in edge string");
        exit(1);
      }
      break;
    case '-':
      if (mode == START) {
        mode = END;
      } else {
        fprintf(stderr, "ERROR: unexpected '-' character in edge string");
        exit(1);
      }
      break;
    default:
      fprintf(stderr, "ERROR: unexpected character in edge string");
      exit(1);
    }
    chars_read += 1;
  }

  free(start_chars_buf);
  free(end_chars_buf);
  Graph graph = {
      .edge_count = edge_count,
      .vertex_count = vertex_count,
      .edges = edges,
      .vertices = vertices,
  };
  return graph;
}

Index parse_index_from_string(char *buf, int len) {
  Index res = 0;
  for (int i = 0; i < len; ++i) {
    int x = buf[i] - '0';
    res = res * 10 + x;
  }
  return res;
}

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

