import 'package:test/test.dart';
import 'package:root_utils/src/graph.dart';

void main() {
  group('BFS', () {
    test('finds shortest path in unweighted graph', () {
      Graph<String> graph = Graph<String>();
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');
      graph.addEdge('C', 'D');
      graph.addEdge('D', 'E');

      List<String> path = graph.bfs('A');
      expect(path, ['A', 'B', 'C', 'D', 'E']);
    });
  });

  group('DFS', () {
    test('finds a path in unweighted graph', () {
      Graph<String> graph = Graph<String>();
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');
      graph.addEdge('C', 'D');
      graph.addEdge('D', 'E');

      List<String> path = graph.dfs('A');
      expect(path, ['A', 'B', 'D', 'C', 'E']);
    });
  });
}