class Matrix2<T> {
  final int rows;
  final int cols;
  List<List<T>> _data = [];

  Matrix2(this.rows, this.cols);

  factory Matrix2.fromList(List<List<T>> data){
    if(data.isEmpty){
      throw ArgumentError("Data cannot be empty");
    }

    final rows = data.length;
    final cols = data[0].length;

    for(var row in data){
      if(row.length != cols){
        throw ArgumentError("All rows must have the same number of columns");
      }
    }

    final dataCopy = data.map((row) => List<T>.from(row)).toList();

    return Matrix2<T>(rows, cols).._data = dataCopy;
  }

  factory Matrix2.fromString(String data, String rowSeparator, String colSeparator){
    if(T != String){
      throw ArgumentError("Matrix2.fromString only supports String type");
    }

    List<List<String>> dataList = data.split(rowSeparator).map((row) => row.split(colSeparator)).toList();

    return Matrix2<String>.fromList(dataList) as Matrix2<T>;
  }

  T operator []((int, int) vector){
    if(vector.$1 < 0 || vector.$1 >= rows){
      throw RangeError("x must be between 0 and $rows");
    }
    if(vector.$2 < 0 || vector.$2 >= cols){
      throw RangeError("y must be between 0 and $cols");
    }
    return _data[vector.$1][vector.$2];
  }

  void operator []=( (int, int) vector, T value){
    if(vector.$1 < 0 || vector.$1 >= cols){
      throw RangeError("x must be between 0 and $cols");
    }
    if(vector.$2 < 0 || vector.$2 >= rows){
      throw RangeError("y must be between 0 and $rows");
    }
    _data[vector.$2][vector.$1] = value;
  }

  T at(int x, int y){
    return this[(x, y)];
  }

  T? atOrNull(int x, int y){
    if(x < 0 || x >= rows || y < 0 || y >= cols){
      return null;
    }
    return _data[x][y];
  }

  void iterate(void Function(T value, (int, int) vector) callback){
    for(var x = 0; x < rows; x++){
      for(var y = 0; y < cols; y++){
        callback(this[(x, y)], (x, y));
      }
    }
  }

  void iterateRow(int y, void Function(T value, int x) callback){
    for(var x = 0; x < cols; x++){
      callback(this[(x, y)], x);
    }
  }

  void iterateCol(int x, void Function(T value, int y) callback){
    for(var y = 0; y < rows; y++){
      callback(this[(x, y)], y);
    }
  }

  /// Iterates over the 8 surrounding cells of the given vector
  void iterateAround8((int, int) vector, void Function(T value, (int, int) vector) callback){
    for(var x = vector.$1 - 1; x <= vector.$1 + 1; x++){
      for(var y = vector.$2 - 1; y <= vector.$2 + 1; y++){
        if(!isInside((x, y)) || (vector == (x, y))){
          continue;
        }
        callback(this[(x, y)], (x, y));
      }
    }
  }

  /// Iterate around the 4 cardinal directions (N, E, S, W)
  void iterateAround4((int, int) vector, void Function(T value, (int, int) vector) callback){
    for(var y = vector.$2 - 1; y <= vector.$2 + 1; y++){
      for(var x = vector.$1 - 1; x <= vector.$1 + 1; x++){
        if(!isInside(vector) || (vector == (x, y)) || (x != vector.$1 && y != vector.$2)){
          continue;
        }
        callback(this[(x, y)], (x, y));
      }
    }
  }

  /// Iterate around the 4 cardinal direction (NW, NE, SE, SW)
  void iterateAroundDiagonal((int, int) vector, void Function(T value, (int, int) vector) callback){
    for(var y = vector.$2 - 1; y <= vector.$2 + 1; y++){
      for(var x = vector.$1 - 1; x <= vector.$1 + 1; x++){
        if(!isInside(vector) || (vector == (x, y)) || (x == vector.$1 || y == vector.$2)){
          continue;
        }
        callback(this[(x, y)], (x, y));
      }
    }
  }

  bool containsAndLookAhead(List<T> list, (int, int) startVector, (int, int) direction, int lookAhead){
    if(list.length == lookAhead){
      return true;
    }
    final nextVector;
    if(lookAhead == 0){
      nextVector = startVector;
    }else{
      nextVector = (startVector.$1 + direction.$1, startVector.$2 + direction.$2);
    }
    final nextValue = atOrNull(nextVector.$1, nextVector.$2);
    if(nextValue == null) return false;
    if(nextValue == list[lookAhead]){
      return containsAndLookAhead(list, nextVector, direction, lookAhead + 1);
    }
    return false;
  }

  @override
    String toString() {
        return _data.map((row) => row.join(',')).join('\n');
    }

  bool isOnEdge((int, int) vector){
    return vector.$1 == 0 || vector.$1 == cols - 1 || vector.$2 == 0 || vector.$2 == rows - 1;
  }

  bool isInside((int, int) vector){
    return vector.$1 >= 0 && vector.$1 < rows && vector.$2 >= 0 && vector.$2 < cols;
  }

  bool isOnCorner((int, int) vector){
    return (vector.$1 == 0 || vector.$1 == cols - 1) && (vector.$2 == 0 || vector.$2 == rows - 1);
  }

  /// Produit matriciel : this (rows × cols) * other (cols × n) = result (rows × n)
  Matrix2<num> operator *(Matrix2<num> other) {
    if (cols != other.rows) {
      throw ArgumentError(
        'Cannot multiply: columns of first matrix ($cols) '
        'must equal rows of second matrix (${other.rows})'
      );
    }

    Matrix2<num> result = Matrix2<num>(rows, other.cols);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < other.cols; j++) {
        num sum = 0;
        for (int k = 0; k < cols; k++) {
          sum += (this[(i, k)] as num) * other[(k, j)];
        }
        result[(i, j)] = sum;
      }
    }

    return result;
  }
}