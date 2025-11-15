import 'package:root_utils/root_utils.dart';
import 'package:test/test.dart';

void main(){

  const N = 1000;

  group("add", (){
    test("int , int", (){
      Vec2<int> a = Vec2<int>(1, 2);
      Vec2<int> b = Vec2<int>(3, 4);
      Vec2<int> c = a + b;
      expect(c.x, 4);
      expect(c.y, 6);
    });

    test("int posivite, int negative", (){
      Vec2<int> a = Vec2<int>(1, 2);
      Vec2<int> b = Vec2<int>(-3, -4);
      Vec2<int> c = a + b;
      expect(c.x, -2);
      expect(c.y, -2);
    });

    test("int negative, int negative", (){
      Vec2<int> a = Vec2<int>(-1, -2);
      Vec2<int> b = Vec2<int>(-3, -4);
      Vec2<int> c = a + b;
      expect(c.x, -4);
      expect(c.y, -6);
    });

    test("double , double", (){
      Vec2<double> a = Vec2<double>(1.0, 2.0);
      Vec2<double> b = Vec2<double>(3.0, 4.0);
      Vec2<double> c = a + b;
      expect(c.x, 4.0);
      expect(c.y, 6.0);
    });

    test("double posivite, double negative", (){
      Vec2<double> a = Vec2<double>(1.0, 2.0);
      Vec2<double> b = Vec2<double>(-3.0, -4.0);
      Vec2<double> c = a + b;
      expect(c.x, -2.0);
      expect(c.y, -2.0);
    });

    test("double negative, double negative", (){
      Vec2<double> a = Vec2<double>(-1.0, -2.0);
      Vec2<double> b = Vec2<double>(-3.0, -4.0);
      Vec2<double> c = a + b;
      expect(c.x, -4.0);
      expect(c.y, -6.0);
    });

    test("int stressed", (){
      Vec2<int> a = Vec2<int>(0, 0);
      for(int i = 0; i < N; ++i){
        int x = a.x;
        int y = a.y;
        a += Vec2<int>(i, i*2);
        expect(a.x, x+i);
        expect(a.y, y+i*2);
      }
      expect(a.x, N*(N-1)~/2);
      expect(a.y, N*(N-1));
    });

    test("double stressed", (){
      Vec2<double> a = Vec2<double>(0.0, 0.0);
      for(int i = 0; i < N; ++i){
        double x = a.x;
        double y = a.y;
        a += Vec2<double>(i.toDouble(), i.toDouble()*2.0);
        expect(a.x, x+i);
        expect(a.y, y+i*2);
      }
      expect(a.x, N*(N-1)~/2);
      expect(a.y, N*(N-1));
    });

  });

}