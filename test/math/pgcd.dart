import 'package:test/test.dart';
import 'package:root_utils/root_utils.dart';

void main(){

  group('PGCD', (){
    test('b equal 0', (){
      expect(pgcd(10, 0), 10);
    });

    test('a equal 0', (){
      expect(pgcd(0, 10), 10);
    });

    test('b equal 0 and a equal 0', (){
      expect(pgcd(0, 0), 0);
    });

    test('b equal 0 and a negative', (){
      expect(pgcd(-10, 0), 10);
    });

    test('a equal 0 and b negative', (){
      expect(pgcd(0, -10), 10);
    });

    test('b negative', (){
      expect(pgcd(10, -5), 5);
    });

    test('a negative', (){
      expect(pgcd(-10, 5), 5);
    });
  });

  group('PGCD List', (){
    test('List is empty', (){
      List<int> list = [];
      expect(() => list.getPGCD(), throwsException);
    });

    test('List is not empty', (){
      List<int> list = [10, 5, 15];
      expect(list.getPGCD(), 5);
    });

    test('List with negative value', (){
      List<int> list = [-10, 5, 15];
      expect(list.getPGCD(), 5);
    });

    test('List with only negative values', (){
      List<int> list = [-10, -5, -15];
      expect(list.getPGCD(), 5);
    });

    test('List with only negative values and 0', (){
      List<int> list = [-10, -5, -15, 0];
      expect(list.getPGCD(), 5);
    });

    test('List with only 0', (){
      List<int> list = [0, 0, 0];
      expect(list.getPGCD(), 0);
    });

    test('List with 0', (){
      List<int> list = [10, 0, 5, 15];
      expect(list.getPGCD(), 5);
    });
  });

  group('PPCM', (){
    test('b equal 0', (){
      expect(ppcm(10, 0), 0);
    });

    test('a equal 0', (){
      expect(ppcm(0, 10), 0);
    });

    test('b equal 0 and a equal 0', (){
      expect(ppcm(0, 0), 0);
    });

    test('b equal 0 and a negative', (){
      expect(ppcm(-10, 0), 0);
    });

    test('a equal 0 and b negative', (){
      expect(ppcm(0, -10), 0);
    });

    test('b negative', (){
      expect(ppcm(10, -5), 10);
    });

    test('a negative', (){
      expect(ppcm(-10, 5), 10);
    });

    test('a and b positive', (){
      expect(ppcm(10, 5), 10);
    });
  });

  group('PPCM List', (){
    test('List is empty', (){
      List<int> list = [];
      expect(() => list.getPPCM(), throwsException);
    });

    test('List is not empty', (){
      List<int> list = [10, 5, 15];
      expect(list.getPPCM(), 30);
    });

    test('List with negative value', (){
      List<int> list = [-10, 5, 15];
      expect(list.getPPCM(), 30);
    });

    test('List with only negative values', (){
      List<int> list = [-10, -5, -15];
      expect(list.getPPCM(), 30);
    });

    test('List with only negative values and 0', (){
      List<int> list = [-10, -5, -15, 0];
      expect(list.getPPCM(), 0);
    });

    test('List with only 0', (){
      List<int> list = [0, 0, 0];
      expect(list.getPPCM(), 0);
    });

    test('List with 0', (){
      List<int> list = [10, 0, 5, 15];
      expect(list.getPPCM(), 0);
    });
  });
}