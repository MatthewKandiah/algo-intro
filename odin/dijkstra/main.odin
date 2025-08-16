package dijkstra

import "core:fmt"
import "core:math/rand"
import "core:testing"

main :: proc() {
	fmt.println("Run tests instead!")
}

HeapRecord :: struct {
	key:    f64,
	handle: int,
}

Heap :: struct {
	data: []HeapRecord,
	size: int,
}

heap_parent :: proc(idx: int) -> int {
	return (idx - 1) / 2
}

heap_left_child :: proc(idx: int) -> int {
	return 2 * idx + 1
}

heap_right_child :: proc(idx: int) -> int {
	return 2 * idx + 2
}

heap_is_min_heap :: proc(heap: Heap) -> bool {
	idx_satisfies_condition :: proc(heap: Heap, idx: int) -> bool {
		left_idx := heap_left_child(idx)
		if left_idx >= heap.size {return true}
		if heap.data[left_idx].key < heap.data[idx].key {return false}

		right_idx := heap_right_child(idx)
		if right_idx >= heap.size {return true}
		if heap.data[right_idx].key < heap.data[idx].key {return false}

		return true
	}

	for i in 0 ..< heap.size {
		if !idx_satisfies_condition(heap, i) {return false}
	}
	return true
}

heap_min_heapify :: proc(heap: Heap, idx: int) {
	left_idx := heap_left_child(idx)
	right_idx := heap_right_child(idx)

	smallest_idx := idx
	if left_idx < heap.size &&
	   heap.data[left_idx].key < heap.data[idx].key {smallest_idx = left_idx}
	if right_idx < heap.size &&
	   heap.data[right_idx].key < heap.data[smallest_idx].key {smallest_idx = right_idx}

	if smallest_idx != idx {
		tmp := heap.data[idx]
		heap.data[idx] = heap.data[smallest_idx]
		heap.data[smallest_idx] = tmp
		heap_min_heapify(heap, smallest_idx)
	}
}

heap_build_min_heap :: proc(data: []HeapRecord, element_count: int) -> (heap: Heap) {
	heap.size = element_count
	heap.data = data
	for i := element_count / 2; i >= 0; i -= 1 {heap_min_heapify(heap, i)
	}
	return
}

@(test)
min_heap_building :: proc(t: ^testing.T) {
	DATA_COUNT :: 1000
	TEST_COUNT :: 1000
	data := make([]HeapRecord, DATA_COUNT)
	defer delete(data)

	for test_idx in 0 ..< TEST_COUNT {
		for i in 0 ..< DATA_COUNT {
			data[i].key = rand.float64()
		}
		heap := heap_build_min_heap(data, DATA_COUNT)
		testing.expect(t, heap_is_min_heap(heap))
	}
}

min_priority_queue_extract_min :: proc(queue: ^Heap) -> HeapRecord {
	min := queue.data[0]
	queue.data[0] = queue.data[queue.size - 1]
	queue.size -= 1
	heap_min_heapify(queue^, 0)
	return min
}

min_priority_queue_decrease_key :: proc(heap: Heap, handle: int, new_key: f64) {
	target_record_idx: int = -1
	for record, idx in heap.data {
		if record.handle == handle {
			target_record_idx = idx
			break
		}
	}
	if target_record_idx == -1 {
		panic("cannot decrease key, handle not found in queue")
	}

	old_value := heap.data[target_record_idx].key
	if old_value < new_key {
		panic("new key must be less than old key")
	}

	for target_record_idx > 0 &&
	    heap.data[heap_parent(target_record_idx)].key > heap.data[target_record_idx].key {
		old_parent_value := heap.data[heap_parent(target_record_idx)].key
		heap.data[heap_parent(target_record_idx)].key = heap.data[target_record_idx].key
		heap.data[target_record_idx].key = old_parent_value
		target_record_idx = heap_parent(target_record_idx)
	}
}

Vertex :: struct {
	distance: f64,
	parent:   int,
}

Edge :: struct {
	start:  int,
	end:    int,
	weight: f64,
}

Graph :: struct {
	vertices: []Vertex,
	edges:    []Edge,
}

graph_initialise_single_source :: proc(graph: Graph, src_idx: int) {
	for &vertex in graph.vertices {
		vertex.distance = max(f64)
		vertex.parent = -1
	}
	graph.vertices[src_idx].distance = 0
}

graph_relax_edge :: proc(graph: Graph, edge_idx: int) -> bool {
	edge := graph.edges[edge_idx]
	possible_distance := graph.vertices[edge.start].distance + edge.weight
	if (graph.vertices[edge.end].distance > possible_distance) {
		graph.vertices[edge.end].distance = possible_distance
		graph.vertices[edge.end].parent = edge.start
		return true
	}
	return false
}

graph_dijkstra :: proc(graph: Graph, src_idx: int) {
	graph_initialise_single_source(graph, src_idx)
	heap_backing_data := make([]HeapRecord, len(graph.edges))
	defer delete(heap_backing_data)

	for vertex, vertex_idx in graph.vertices {
		heap_backing_data[vertex_idx] = HeapRecord {
			key    = vertex.distance,
			handle = vertex_idx,
		}
	}
	queue := heap_build_min_heap(heap_backing_data, len(graph.vertices))

	for queue.size > 0 {
		current_heap_record := min_priority_queue_extract_min(&queue)
		current_idx := current_heap_record.handle
		for edge, edge_idx in graph.edges {
			if edge.start != current_idx {continue}
			relax_decreased_d := graph_relax_edge(graph, edge_idx)
			if relax_decreased_d {
				min_priority_queue_decrease_key(queue, edge.end, graph.vertices[edge.end].distance)
			}
		}
	}
}

@(test)
dijkstra_example :: proc(t: ^testing.T) {
	vertices := make([]Vertex, 5)
	edges := make([]Edge, 10)
	defer {
  	delete(vertices)
  	delete(edges)
	}
	edges[0] = Edge {
		start  = 0,
		end    = 1,
		weight = 10,
	}
	edges[1] = Edge {
		start  = 0,
		end    = 2,
		weight = 5,
	}
	edges[2] = Edge {
		start  = 1,
		end    = 3,
		weight = 1,
	}
	edges[3] = Edge {
		start  = 1,
		end    = 2,
		weight = 2,
	}
	edges[4] = Edge {
		start  = 2,
		end    = 1,
		weight = 3,
	}
	edges[5] = Edge {
		start  = 2,
		end    = 3,
		weight = 9,
	}
	edges[6] = Edge {
		start  = 2,
		end    = 4,
		weight = 2,
	}
	edges[7] = Edge {
		start  = 3,
		end    = 4,
		weight = 4,
	}
	edges[8] = Edge {
		start  = 4,
		end    = 3,
		weight = 6,
	}
	edges[9] = Edge {
		start  = 4,
		end    = 0,
		weight = 7,
	}
	graph := Graph {
		vertices = vertices,
		edges    = edges,
	}

	graph_dijkstra(graph, 0)

	testing.expect(t, graph.vertices[0].distance == 0)
	testing.expect(t, graph.vertices[0].parent == -1)

	testing.expect(t, graph.vertices[1].distance == 8)
	testing.expect(t, graph.vertices[1].parent == 2)

	testing.expect(t, graph.vertices[2].distance == 5)
	testing.expect(t, graph.vertices[2].parent == 0)

	testing.expect(t, graph.vertices[3].distance == 9)
	testing.expect(t, graph.vertices[3].parent == 1)

	testing.expect(t, graph.vertices[4].distance == 7)
	testing.expect(t, graph.vertices[4].parent == 2)
}
