/// Classe Range pour représenter un intervalle de valeurs entières
/// Utilisable pour des problèmes d'optimisation et algorithmes complexes
class Range {
  final num start;
  final num end;
  final num step;

  /// Crée un Range de [start] (inclus) à [end] (exclus) avec un pas de [step]
  Range(this.start, this.end, {this.step = 1}) {
    if (step == 0) {
      throw ArgumentError('Le pas ne peut pas être 0');
    }
    if (step > 0 && start > end) {
      throw ArgumentError('Pour un pas positif, start doit être <= end');
    }
    if (step < 0 && start < end) {
      throw ArgumentError('Pour un pas négatif, start doit être >= end');
    }
  }

  /// Crée un Range de 0 à [end] (exclus)
  factory Range.until(num end) => Range(0, end);

  /// Crée un Range de [start] à [end] (inclus)
  factory Range.closed(num start, num end, {num step = 1}) {
    return Range(start, end + (step > 0 ? 1 : -1), step: step);
  }

  /// Retourne le nombre d'éléments dans le Range
  int get length {
    if (isEmpty) return 0;
    return ((end - start) / step).abs().ceil();
  }

  /// Vérifie si le Range est vide
  bool get isEmpty => step > 0 ? start >= end : start <= end;

  /// Vérifie si le Range contient au moins un élément
  bool get isNotEmpty => !isEmpty;

  /// Retourne le premier élément du Range
  num get first {
    if (isEmpty) throw StateError('Range vide');
    return start;
  }

  /// Retourne le dernier élément du Range
  num get last {
    if (isEmpty) throw StateError('Range vide');
    num count = length - 1;
    return start + (count * step);
  }

  /// Vérifie si le Range contient la valeur [value]
  bool contains(num value) {
    if (isEmpty) return false;
    if (step > 0) {
      if (value < start || value >= end) return false;
    } else {
      if (value > start || value <= end) return false;
    }
    return (value - start) % step == 0;
  }

  /// Retourne tous les éléments du Range sous forme de List
  List<num> toList() {
    if (isEmpty) return [];
    return List.generate(length, (i) => start + (i * step));
  }

  /// Retourne tous les éléments du Range sous forme d'Iterable (lazy)
  Iterable<num> toIterable() sync* {
    if (step > 0) {
      for (num i = start; i < end; i += step) {
        yield i;
      }
    } else {
      for (num i = start; i > end; i += step) {
        yield i;
      }
    }
  }

  /// Retourne l'élément à l'index [index]
  num operator [](num index) {
    if (index < 0 || index >= length) {
      throw RangeError('Index $index hors limites pour Range de longueur $length');
    }
    return start + (index * step);
  }

  /// Vérifie si deux Ranges sont égaux
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Range &&
        other.start == start &&
        other.end == end &&
        other.step == step;
  }



  @override
  int get hashCode => Object.hash(start, end, step);

  /// Retourne l'intersection de deux Ranges (si elle existe)
  Range? intersection(Range other) {
    num newStart = step > 0 ? 
        (start > other.start ? start : other.start) :
        (start < other.start ? start : other.start);
    num newEnd = step > 0 ?
        (end < other.end ? end : other.end) :
        (end > other.end ? end : other.end);
    
    if ((step > 0 && newStart >= newEnd) || (step < 0 && newStart <= newEnd)) {
      return null;
    }
    
    return Range(newStart, newEnd, step: step);
  }

  /// Vérifie si ce Range chevauche un autre Range
  bool overlaps(Range other) {
    return intersection(other) != null;
  }

  /// Vérifie si deux Ranges sont adjacents (se touchent sans se chevaucher)
  bool isAdjacentTo(Range other) {
    if (step != other.step) return false;
    if (step > 0) {
      return end == other.start || other.end == start;
    } else {
      return end == other.start || other.end == start;
    }
  }

  /// Vérifie si deux Ranges peuvent être fusionnés (chevauchement ou adjacents)
  bool canMergeWith(Range other) {
    if (step != other.step) return false;
    return overlaps(other) || isAdjacentTo(other);
  }

  /// Fusionne deux Ranges en un seul Range continu
  /// Retourne null si les Ranges ne peuvent pas être fusionnés
  /// (pas le même pas, ou pas de chevauchement/adjacence)
  Range? merge(Range other) {
    if (!canMergeWith(other)) return null;
    
    if (step > 0) {
      num newStart = start < other.start ? start : other.start;
      num newEnd = end > other.end ? end : other.end;
      return Range(newStart, newEnd, step: step);
    } else {
      num newStart = start > other.start ? start : other.start;
      num newEnd = end < other.end ? end : other.end;
      return Range(newStart, newEnd, step: step);
    }
  }

  /// Fusionne plusieurs Ranges en une liste de Ranges non-chevauchants
  /// Les Ranges en entrée peuvent se chevaucher ou être adjacents
  static List<Range> mergeAll(List<Range> ranges) {
    if (ranges.isEmpty) return [];
    if (ranges.length == 1) return [ranges.first];
    
    // Grouper par pas
    Map<num, List<Range>> byStep = {};
    for (var range in ranges) {
      byStep.putIfAbsent(range.step, () => []).add(range);
    }
    
    List<Range> result = [];
    
    for (var step in byStep.keys) {
      var rangesWithSameStep = byStep[step]!;
      
      // Trier les ranges
      rangesWithSameStep.sort((a, b) {
        if (step > 0) {
          return a.start.compareTo(b.start);
        } else {
          return b.start.compareTo(a.start);
        }
      });
      
      // Fusionner les ranges adjacents ou chevauchants
      Range current = rangesWithSameStep.first;
      
      for (int i = 1; i < rangesWithSameStep.length; i++) {
        var next = rangesWithSameStep[i];
        var merged = current.merge(next);
        
        if (merged != null) {
          current = merged;
        } else {
          result.add(current);
          current = next;
        }
      }
      result.add(current);
    }
    return result;
  }

  /// Map chaque élément du Range avec une fonction
  Iterable<T> map<T>(T Function(num) f) {
    return toIterable().map(f);
  }

  /// Filtre les éléments du Range selon un prédicat
  Iterable<num> where(bool Function(num) test) {
    return toIterable().where(test);
  }

  /// Réduit le Range à une seule valeur
  T fold<T>(T initialValue, T Function(T previousValue, num element) combine) {
    return toIterable().fold(initialValue, combine);
  }

  /// Somme de tous les éléments
  num sum() => fold<num>(0, (sum, element) => sum + element);

  /// Produit de tous les éléments
  num product() => fold<num>(1, (prod, element) => prod * element);

  /// Applique une fonction à chaque élément
  void forEach(void Function(num) action) {
    for (var element in toIterable()) {
      action(element);
    }
  }

  @override
  String toString() {
    if (step == 1) {
      return 'Range($start..$end)';
    }
    return 'Range($start..$end step $step)';
  }
}