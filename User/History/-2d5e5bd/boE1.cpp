#include <iostream>

using namespace std;

class Rectangle
{
  public:
  int height=1;
  int width=1;

    int perimeter(){
      return 2*(height+width);
    }
    
    int area(){
      return height*width;
    }

    void t1(){
      cout << "Hello adypseo";
    }
};

int main(){
  /*cout << "test";*/
  Rectangle test;
  Rectangle test1;
  test.height = 15;
  test.width = 10;
  int p1 = test.perimeter();
  int p2 = test.area();
  cout << "--------- test --------"<<endl;
  cout << "p1 " << p1<< endl;
  cout << "p2 " << p2<< endl;
  cout << "test.height " <<test.height << "\n";
  cout << "test.width " <<test.width << "\n";
  cout << "--------- test --------"<<endl;
  // cout << "test.perimeter() " << test.perimeter() << endl;
  // cout << "Hello world!"<< endl;
  // cout << "--------- test 1 --------"
  // cout << "--------- test 1 --------"
  return 0;
  /*int peri = test.perimeter();*/
  /*test.t1();*/
}
