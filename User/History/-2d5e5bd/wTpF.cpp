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
    void t1(){
      cout << "Hello adypseo";
    }
};

int main(){
  /*cout << "test";*/
  Rectangle test;
  test.height = 5;
  test.width = 10;
  cout << "Hello world!";
  cout << "test.height " <<test.height << "\n";
  cout << "test.width " <<test.width << "\n";
  return 0;
  /*int peri = test.perimeter();*/
  /*test.t1();*/
}
