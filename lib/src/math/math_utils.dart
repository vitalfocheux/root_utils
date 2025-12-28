// math_utils.dart
import 'dart:math' as math;

/// divmod returns (quotient, remainder)
(int, int) divmod(int a, int b) => (a ~/ b, a % b);

/// gcd / lcm
int gcd(int a, int b) {
  a = a.abs();
  b = b.abs();
  while (b != 0) {
    final t = a % b;
    a = b;
    b = t;
  }
  return a;
}

int lcm(int a, int b) {
  if (a == 0 || b == 0) return 0;
  return (a ~/ gcd(a, b)) * b.abs();
}

/// factorial (int; for large results use BigInt)
int factorial(int n) {
  if (n < 0) throw ArgumentError('n must be >= 0');
  var r = 1;
  for (var i = 2; i <= n; i++) r *= i;
  return r;
}

BigInt factorialBig(int n) {
  if (n < 0) throw ArgumentError('n must be >= 0');
  var r = BigInt.one;
  for (var i = 2; i <= n; i++) r *= BigInt.from(i);
  return r;
}

/// integer power (fast)
int pow(int base, int exp) {
  if (exp < 0) throw ArgumentError('exp must be >= 0');
  var result = 1;
  var b = base;
  var e = exp;
  while (e > 0) {
    if ((e & 1) != 0) result *= b;
    b *= b;
    e >>= 1;
  }
  return result;
}

BigInt powBigInt(BigInt base, int exp) {
  if (exp < 0) throw ArgumentError('exp must be >= 0');
  var result = BigInt.one;
  var b = base;
  var e = exp;
  while (e > 0) {
    if ((e & 1) != 0) result *= b;
    b *= b;
    e >>= 1;
  }
  return result;
}

/// accumulate (prefix sums). If fn omitted, does addition.
Iterable<T> accumulate<T>(Iterable<T> items, T Function(T, T)? fn) sync* {
  final it = items.iterator;
  if (!it.moveNext()) return;
  dynamic total = it.current;
  yield total as T;
  while (it.moveNext()) {
    total = fn != null ? fn(total as T, it.current as T) : (total as dynamic) + it.current;
    yield total as T;
  }
}

/// Counter utility similar to Python's collections.Counter
class Counter<T> {
  final Map<T, int> _counts = {};
  void add(T key, [int amount = 1]) => _counts[key] = (_counts[key] ?? 0) + amount;
  int operator [](T key) => _counts[key] ?? 0;
  Iterable<T> get keys => _counts.keys;
  int get totalEntries => _counts.length;
  Map<T,int> asMap() => Map.unmodifiable(_counts);
}

/// bisect_left / bisect_right with comparator
int bisectLeft<T>(List<T> a, T x, int Function(T, T) cmp) {
  var lo = 0, hi = a.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (cmp(a[mid], x) < 0) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

int bisectRight<T>(List<T> a, T x, int Function(T, T) cmp) {
  var lo = 0, hi = a.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (cmp(a[mid], x) <= 0) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

/// combinations generator (lexicographic)
Iterable<List<T>> combinations<T>(List<T> items, int k) sync* {
  final n = items.length;
  if (k < 0 || k > n) return;
  if (k == 0) {
    yield <T>[];
    return;
  }
  final indices = List<int>.generate(k, (i) => i);
  while (true) {
    yield indices.map((i) => items[i]).toList(growable: false);
    var i = k - 1;
    while (i >= 0 && indices[i] == i + n - k) i--;
    if (i < 0) break;
    indices[i]++;
    for (var j = i + 1; j < k; j++) indices[j] = indices[j - 1] + 1;
  }
}


/// sliding window / pairwise
extension IterableWindow<T> on Iterable<T> {
  Iterable<List<T>> window(int size) sync* {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be > 0');
    final buf = <T>[];
    for (var v in this) {
      buf.add(v);
      if (buf.length == size) {
        yield List<T>.from(buf);
        buf.removeAt(0);
      }
    }
  }
  Iterable<List<T>> pairwise() => window(2);
}

/// Simple product (cartesian) - careful with sizes
Iterable<List<T>> product<T>(List<List<T>> lists) sync* {
  if (lists.isEmpty) {
    yield <T>[];
    return;
  }
  List<T> build(int i) {
    if (i == lists.length) return <T>[];
    return <T>[]; // placeholder not used
  }
  // iterative index counters
  final indices = List<int>.filled(lists.length, 0);
  while (true) {
    yield [for (var i=0;i<lists.length;i++) lists[i][indices[i]]];
    var i = lists.length - 1;
    while (i >= 0) {
      indices[i]++;
      if (indices[i] < lists[i].length) break;
      indices[i] = 0;
      i--;
    }
    if (i < 0) break;
  }
}