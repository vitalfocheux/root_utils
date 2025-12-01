// graph.dart
// Classe Graph générique pour Dart — utile pour Advent of Code.
// Contient :
// - représentation adjacency list (Map<T, Map<T, double?>>)
// - ajout/suppression de noeuds/arêtes
// - BFS, DFS
// - Dijkstra
// - A* (requiert heuristique)
// - détection de cycles (dirigé/non-dirigé)
// - chemin/cycle eulérien (Hierholzer)
// - chemin/cycle hamiltonien (backtracking avec pruning)
// - squelette pour Karp-Miller (arbre de recouvrement pour réseaux de Petri)
// - utilitaires (copy, toString ASCII)

import 'dart:collection';
import 'dart:math';

/// Représentation générique d'un graphe.
/// T doit être utilisable comme clé dans une Map (== et hashCode stables).
class Graph<T> {

  /// Génère une visualisation SVG du graphe directement en Dart
  /// sans avoir besoin d'exécuter une commande externe.
  /// Chaque nœud est placé en cercle et les arêtes sont dessinées.
  String toSvg({double radius = 150, double nodeRadius = 18}) {
    final nodesList = nodes.toList();
    final n = nodesList.length;
    if (n == 0) return '<svg></svg>';


    final centerX = radius + 20;
    final centerY = radius + 20;
    final coords = <T, Map<String, double>>{};


    for (var i = 0; i < n; i++) {
      final angle = 2 * pi * i / n;
      coords[nodesList[i]] = {
      'x': centerX + radius * cos(angle),
      'y': centerY + radius * sin(angle),
      };
    }


    final buffer = StringBuffer();
    buffer.writeln('<svg xmlns="http://www.w3.org/2000/svg" width="${2 * radius + 40}" height="${2 * radius + 40}">');


    // Draw edges
    for (var u in _adj.keys) {
      for (var v in _adj[u]!.keys) {
        final cu = coords[u]!;
        final cv = coords[v]!;
        buffer.writeln('<line x1="${cu['x']}" y1="${cu['y']}" x2="${cv['x']}" y2="${cv['y']}" stroke="black" stroke-width="2" />');
      }
    }


    // Draw nodes
    for (var u in _adj.keys) {
      final c = coords[u]!;
      buffer.writeln('<circle cx="${c['x']}" cy="${c['y']}" r="$nodeRadius" fill="lightblue" stroke="black" stroke-width="2" />');
      buffer.writeln('<text x="${c['x']}" y="${c['y']}" text-anchor="middle" alignment-baseline="middle" font-size="14">$u</text>');
    }


    buffer.writeln('</svg>');
    return buffer.toString();
  }


  // adjacency: node -> (neighbor -> weight (null == unweighted / weight=1.0))
  final Map<T, Map<T, double>> _adj = {};
  final bool directed;

  Graph({this.directed = false});

  /// Crée une copie superficielle
  Graph.from(Graph<T> other) : directed = other.directed {
    for (var e in other._adj.entries) {
      _adj[e.key] = Map<T, double>.from(e.value);
    }
  }

  Iterable<T> get nodes => _adj.keys;
  int get size => _adj.length;

  void addNode(T node) {
    _adj.putIfAbsent(node, () => {});
  }

  void addEdge(T a, T b, [double weight = 1.0]) {
    addNode(a);
    addNode(b);
    _adj[a]![b] = weight;
    if (!directed) _adj[b]![a] = weight;
  }

  bool removeEdge(T a, T b) {
    if (!_adj.containsKey(a)) return false;
    var removed = _adj[a]!.remove(b) != null;
    if (!directed && _adj.containsKey(b)) _adj[b]!.remove(a);
    return removed;
  }

  bool removeNode(T node) {
    if (!_adj.containsKey(node)) return false;
    _adj.remove(node);
    for (var m in _adj.values) {
      m.remove(node);
    }
    return true;
  }

  Iterable<T> neighbors(T node) => _adj[node]?.keys ?? Iterable.empty();
  double? weight(T a, T b) => _adj[a]?[b];

  // ---------- Traversals ----------

  /// BFS: retourne la liste des nœuds visités dans l'ordre.
  List<T> bfs(T start, {bool Function(T)? visitPredicate}) {
    if (!_adj.containsKey(start)) return [];
    var visited = <T>{};
    var q = Queue<T>();
    var order = <T>[];
    q.add(start);
    visited.add(start);
    while (q.isNotEmpty) {
      var u = q.removeFirst();
      order.add(u);
      if (visitPredicate != null && !visitPredicate(u)) continue;
      for (var v in neighbors(u)) {
        if (!visited.contains(v)) {
          visited.add(v);
          q.add(v);
        }
      }
    }
    return order;
  }

  /// DFS (iterative) : retourne l'ordre de visite
  List<T> dfs(T start) {
    if (!_adj.containsKey(start)) return [];
    var visited = <T>{};
    var stack = <T>[];
    var order = <T>[];
    stack.add(start);
    while (stack.isNotEmpty) {
      var u = stack.removeLast();
      if (visited.contains(u)) continue;
      visited.add(u);
      order.add(u);
      for (var v in neighbors(u).toList().reversed) {
        if (!visited.contains(v)) stack.add(v);
      }
    }
    return order;
  }

  // ---------- Shortest paths ----------

  /// Dijkstra: retourne distance map et prédecesseur map.
  Map<T, double> _dijkstraDistances(T source, {Map<T, T?>? predecessors}) {
    var dist = <T, double>{};
    for (var n in nodes) dist[n] = double.infinity;
    if (!_adj.containsKey(source)) return dist;
    dist[source] = 0.0;

    var pq = PriorityQueue<_PQItem<T>>((a, b) => a.priority.compareTo(b.priority));
    pq.add(_PQItem(source, 0.0));

    while (pq.isNotEmpty) {
      var item = pq.removeFirst();
      var u = item.value;
      var d = item.priority;
      if (d > dist[u]!) continue; // stale
      for (var v in neighbors(u)) {
        var w = _adj[u]![v] ?? 1.0;
        if (dist[v]! > dist[u]! + w) {
          dist[v] = dist[u]! + w;
          predecessors?[v] = u;
          pq.add(_PQItem(v, dist[v]!));
        }
      }
    }

    return dist;
  }

  /// Renvoie (distances map, predecessors map)
  Map<String, dynamic> dijkstra(T source) {
    var preds = <T, T?>{};
    var dist = _dijkstraDistances(source, predecessors: preds);
    return {'dist': dist, 'pred': preds};
  }

  /// A* : nécessite une heuristique h(node, goal)
  List<T> aStar(T start, T goal, double Function(T, T) h) {
    if (!_adj.containsKey(start) || !_adj.containsKey(goal)) return [];
    var closed = <T>{};
    var gScore = <T, double>{};
    var fScore = <T, double>{};
    var cameFrom = <T, T>{};

    for (var n in nodes) {
      gScore[n] = double.infinity;
      fScore[n] = double.infinity;
    }
    gScore[start] = 0.0;
    fScore[start] = h(start, goal);

    var open = PriorityQueue<_PQItem<T>>((a, b) => a.priority.compareTo(b.priority));
    open.add(_PQItem(start, fScore[start]!));

    while (open.isNotEmpty) {
      var current = open.removeFirst().value;
      if (current == goal) return _reconstructPath(cameFrom, current);
      closed.add(current);
      for (var neighbor in neighbors(current)) {
        if (closed.contains(neighbor)) continue;
        var tentativeG = gScore[current]! + (_adj[current]![neighbor] ?? 1.0);
        if (tentativeG < gScore[neighbor]!) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeG;
          fScore[neighbor] = tentativeG + h(neighbor, goal);
          open.add(_PQItem(neighbor, fScore[neighbor]!));
        }
      }
    }
    return []; // pas de chemin
  }

  List<T> _reconstructPath(Map<T, T> cameFrom, T current) {
    var path = <T>[];
    var cur = current;
    path.add(cur);
    while (cameFrom.containsKey(cur)) {
      cur = cameFrom[cur]!;
      path.add(cur);
    }
    return path.reversed.toList();
  }

  // ---------- Cycles et connexité ----------

  /// Détection de cycle dirigé via DFS (white/gray/black)
  bool hasCycleDirected() {
    if (!directed) throw StateError('Graphe non-dirigé : utiliser hasCycleUndirected');
    var color = <T, int>{}; // 0 white, 1 gray, 2 black
    for (var n in nodes) color[n] = 0;

    bool dfs(T u) {
      color[u] = 1;
      for (var v in neighbors(u)) {
        if (color[v] == 1) return true;
        if (color[v] == 0 && dfs(v)) return true;
      }
      color[u] = 2;
      return false;
    }

    for (var n in nodes) {
      if (color[n] == 0 && dfs(n)) return true;
    }
    return false;
  }

  /// Détection de cycle pour graphe non-dirigé
  bool hasCycleUndirected() {
    if (directed) throw StateError('Graphe dirigé : utiliser hasCycleDirected');
    var visited = <T>{};

    bool dfs(T u, T? parent) {
      visited.add(u);
      for (var v in neighbors(u)) {
        if (!visited.contains(v)) {
          if (dfs(v, u)) return true;
        } else if (v != parent) {
          return true;
        }
      }
      return false;
    }

    for (var n in nodes) {
      if (!visited.contains(n) && dfs(n, null)) return true;
    }
    return false;
  }

  // ---------- Eulerian path/cycle (Hierholzer) ----------
  /// Retourne une liste de noeuds représentant un chemin eulérien si existant.
  List<T> eulerianTrailOrCircuit() {
    // check degrees
    if (directed) return _eulerianDirected();
    return _eulerianUndirected();
  }

  List<T> _eulerianUndirected() {
    // For undirected graph: either 0 or 2 vertices of odd degree
    var odd = <T>[];
    for (var n in nodes) {
      var deg = _adj[n]!.length;
      if (deg % 2 == 1) odd.add(n);
    }
    if (odd.length != 0 && odd.length != 2) return [];
    var start = odd.isNotEmpty ? odd.first : (nodes.isNotEmpty ? nodes.first : null);
    if (start == null) return [];

    // copy multigraph structure
    var local = <T, Map<T, int>>{};
    for (var u in _adj.keys) {
      local[u] = {};
      for (var v in _adj[u]!.keys) {
        local[u]![v] = (local[u]![v] ?? 0) + 1;
      }
    }

    var stack = <T>[];
    var path = <T>[];
    stack.add(start);
    while (stack.isNotEmpty) {
      var v = stack.last;
      if (local[v]!.isNotEmpty) {
        var u = local[v]!.keys.first;
        // remove edge v-u both ways
        local[v]!.update(u, (x) => x - 1);
        if (local[v]![u] == 0) local[v]!.remove(u);
        local[u]!.update(v, (x) => x - 1);
        if (local[u]![v] == 0) local[u]!.remove(v);
        stack.add(u);
      } else {
        path.add(stack.removeLast());
      }
    }
    return path.reversed.toList();
  }

  List<T> _eulerianDirected() {
    // For directed graph: in-degree == out-degree for circuit, or exactly one has out-in=1 and one has in-out=1 for trail
    var indeg = <T, int>{};
    var outdeg = <T, int>{};
    for (var n in nodes) { indeg[n] = 0; outdeg[n] = 0; }
    for (var u in _adj.keys) {
      outdeg[u] = _adj[u]!.length;
      for (var v in _adj[u]!.keys) {
        indeg[v] = (indeg[v] ?? 0) + 1;
      }
    }
    var start = nodes.isNotEmpty ? nodes.first : null;
    T? startNode; // choose appropriate start
    var plus = <T>[]; var minus = <T>[];
    for (var n in nodes) {
      var diff = (outdeg[n] ?? 0) - (indeg[n] ?? 0);
      if (diff == 1) plus.add(n);
      else if (diff == -1) minus.add(n);
      else if (diff != 0) return []; // impossible
      if (outdeg[n]! > 0) startNode = n;
    }
    if (plus.length == 0 && minus.length == 0) {
      // Eulerian circuit
    } else if (plus.length == 1 && minus.length == 1) {
      startNode = plus.first;
    } else {
      return [];
    }
    if (startNode == null) return [];

    // copy multigraph structure with counts
    var local = <T, Map<T, int>>{};
    for (var u in _adj.keys) {
      local[u] = {};
      for (var v in _adj[u]!.keys) {
        local[u]![v] = (local[u]![v] ?? 0) + 1;
      }
    }

    var stack = <T>[];
    var path = <T>[];
    stack.add(startNode);
    while (stack.isNotEmpty) {
      var v = stack.last;
      if (local[v]!.isNotEmpty) {
        var u = local[v]!.keys.first;
        local[v]!.update(u, (x) => x - 1);
        if (local[v]![u] == 0) local[v]!.remove(u);
        stack.add(u);
      } else {
        path.add(stack.removeLast());
      }
    }
    return path.reversed.toList();
  }

  // ---------- Hamiltonian (backtracking) ----------
  /// Retourne un chemin Hamiltonien si trouvé, sinon []
  List<T> hamiltonianPath({T? start}) {
    if (nodes.isEmpty) return [];
    start ??= nodes.first;
    var visited = <T>{};
    var path = <T>[];
    bool dfs(T u) {
      visited.add(u);
      path.add(u);
      if (path.length == size) return true;
      // ordering neighbors by degree can help pruning
      var neigh = neighbors(u).toList();
      neigh.sort((a, b) => neighbors(a).length.compareTo(neighbors(b).length));
      for (var v in neigh) {
        if (visited.contains(v)) continue;
        if (dfs(v)) return true;
      }
      visited.remove(u);
      path.removeLast();
      return false;
    }

    if (dfs(start as T)) return List<T>.from(path);
    return [];
  }

  /// Retourne un cycle Hamiltonien si trouvé, sinon []
  List<T> hamiltonianCycle({T? start}) {
    if (nodes.isEmpty) return [];
    start ??= nodes.first;
    var visited = <T>{};
    var path = <T>[];
    bool dfs(T u) {
      visited.add(u);
      path.add(u);
      if (path.length == size) {
        // check edge back to start
        if (_adj[u]!.containsKey(start)) return true;
        // else backtrack
      }
      for (var v in neighbors(u)) {
        if (visited.contains(v)) continue;
        if (dfs(v)) return true;
      }
      visited.remove(u);
      path.removeLast();
      return false;
    }

    if (dfs(start as T)) return List<T>.from(path)..add(start);
    return [];
  }

  // ---------- Karp-Miller (squelette) ----------
  /// Karp-Miller algorithm is non-trivial: it constructs a coverability tree for a Petri net
  /// This method provides a skeleton and basic structure. If you need a production-ready
  /// implementation, we can extend this function with your Petri net transitions/places model.
  /// For Advent of Code, Karp-Miller is rarely required — include if you handle Petri nets.
  Map<String, dynamic> karpMiller({required List<T> places, required List<_PetriTransition<T>> transitions, Map<T, int>? initialMarking}) {
    // This is a non-implemented skeleton returning metadata and a TODO.
    throw UnimplementedError('Karp-Miller is domain-specific — provide Petri net specifics or ask me to implement it fully.');
  }

  // ---------- Utilities ----------
  @override
  String toString() {
    var sb = StringBuffer();
    for (var u in _adj.keys) {
      sb.write('$u -> ');
      sb.writeAll(_adj[u]!.entries.map((e) => '${e.key}(${e.value})'), ', ');
      sb.writeln();
    }
    return sb.toString();
  }

  /// Représentation ASCII simple (utile pour petits graphes)
  String toAscii() {
    var lines = <String>[];
    for (var u in _adj.keys) {
      var neigh = _adj[u]!.keys.map((v) => v.toString()).join(', ');
      lines.add('$u: $neigh');
    }
    return lines.join('\n');
  }
}

// Petite classe utilitaire pour file de priorité
class _PQItem<T> {
  final T value;
  final double priority;
  _PQItem(this.value, this.priority);
}

// PriorityQueue implementation (min-heap) since dart:collection's PriorityQueue compares using comparator on elements
class PriorityQueue<E> {
  final int Function(E a, E b) compare;
  final List<E> _heap = [];
  PriorityQueue(this.compare);

  bool get isEmpty => _heap.isEmpty;
  bool get isNotEmpty => _heap.isNotEmpty;
  int get length => _heap.length;

  void add(E value) {
    _heap.add(value);
    _siftUp(_heap.length - 1);
  }

  E removeFirst() {
    if (_heap.isEmpty) throw StateError('Empty');
    var first = _heap.first;
    var last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }
    return first;
  }

  void _siftUp(int i) {
    var child = _heap[i];
    while (i > 0) {
      var parentIdx = (i - 1) >> 1;
      var parent = _heap[parentIdx];
      if (compare(child, parent) >= 0) break;
      _heap[i] = parent;
      i = parentIdx;
    }
    _heap[i] = child;
  }

  void _siftDown(int i) {
    var length = _heap.length;
    var elem = _heap[i];
    while (true) {
      var left = (i << 1) + 1;
      if (left >= length) break;
      var right = left + 1;
      var smaller = left;
      if (right < length && compare(_heap[right], _heap[left]) < 0) smaller = right;
      if (compare(_heap[smaller], elem) >= 0) break;
      _heap[i] = _heap[smaller];
      i = smaller;
    }
    _heap[i] = elem;
  }
}

// Squelettes pour la représentation des transitions de Petri (utilisé pour Karp-Miller si souhaité)
class _PetriTransition<T> {
  final Map<T, int> consume; // tokens to consume from places
  final Map<T, int> produce; // tokens to produce to places
  _PetriTransition(this.consume, this.produce);
}