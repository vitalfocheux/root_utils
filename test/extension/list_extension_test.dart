import 'package:root_utils/root_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Sum', (){
    test('int', (){
      expect([1, 2, 3].sum(), 6);
    });

    test('double', (){
      expect([1.0, 2.0, 3.0].sum(), 6.0);
    });

    test('int empty list', (){
      List<int> list = [];
      expect(list.sum(), 0);
    });

    test('double empty list', (){
      List<double> list = [];
      expect(list.sum(), 0.0);
    });

    test('int zero', (){
      expect([1, 2, 0].sum(), 3);
    });

    test('double zero', (){
      expect([1.0, 2.0, 0.0].sum(), 3.0);
    });

    test('negative', (){
      expect([-1, 2, 3].sum(), 4);
    });

    test('only negative', (){
      expect([-1, -2, -3].sum(), -6);
    });

    test('negative double', (){
      expect([-1.0, 2.0, 3.0].sum(), 4.0);
    });

    test('only negative double', (){
      expect([-1.0, -2.0, -3.0].sum(), -6.0);
    });
  });

  group('Mul', (){
    test('int', (){
      expect([1, 2, 3].mul(), 6);
    });

    test('double', (){
      expect([1.0, 2.0, 3.0].mul(), 6.0);
    });

    test('int empty list', (){
      List<int> list = [];
      expect(list.mul(), 1);
    });

    test('double empty list', (){
      List<double> list = [];
      expect(list.mul(), 1.0);
    });

    test('int zero', (){
      expect([1, 2, 0].mul(), 0);
    });

    test('double zero', (){
      expect([1.0, 2.0, 0.0].mul(), 0.0);
    });

    test('int zero empty list', (){
      List<int> list = [0];
      expect(list.mul(), 0);
    });

    test('double zero empty list', (){
      List<double> list = [0.0];
      expect(list.mul(), 0.0);
    });

    test('negative', (){
      expect([-1, 2, 3].mul(), -6);
    });

    test('negative twice', (){
      expect([-1, -2, 3].mul(), 6);
    });

    test('negative double', (){
      expect([-1.0, 2.0, 3.0].mul(), -6.0);
    });

    test('negative twice double', (){
      expect([-1.0, -2.0, 3.0].mul(), 6.0);
    });
  });

  group('Max', (){
    test('int', (){
      expect([1, 2, 3].max(), 3);
    });

    test('double', (){
      expect([1.0, 2.0, 3.0].max(), 3.0);
    });

    test('int negative', (){
      expect([-1, -2, -3].max(), -1);
    });

    test('double negative', (){
      expect([-1.0, -2.0, -3.0].max(), -1.0);
    });

    test('empty list', (){
      List<int> list = [];
      expect(() => list.max(), throwsException);
    });  
  });

  group('Min', (){
    test('int', (){
      expect([1, 2, 3].min(), 1);
    });

    test('double', (){
      expect([1.0, 2.0, 3.0].min(), 1.0);
    });

    test('int negative', (){
      expect([-1, -2, -3].min(), -3);
    });

    test('double negative', (){
      expect([-1.0, -2.0, -3.0].min(), -3.0);
    });

    test('empty list', (){
      List<int> list = [];
      expect(() => list.min(), throwsException);
    });  
  });
}

