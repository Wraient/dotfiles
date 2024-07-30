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

    bool is_height_one(){
      if(height == 1){
        return true;
      }
      else {
        return false;
      } 
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
  // cout << "--------- test --------"<<endl;
  cout << "p1 " << p1<< endl;
  cout << "p2 " << p2<< endl;
  cout << "test.height " <<test.height << "\n";
  cout << "test.width " <<test.width << "\n";
  // cout << "--------- test --------"<<endl;
  // cout << "test.perimeter() " << test.perimeter() << endl;
  // cout << "Hello world!"<< endl;
  // cout << "--------- test 1 --------"<<endl;
  test1.height = 7;
  cout << "test1.height " << test1.height <<endl;
  cout << "test1.width " << test1.width <<endl;
  test1.width = 5;
  cout << "test1.width " << test1.width <<endl;
  cout << "test1.permeter() " << test1.perimeter() << endl;
  cout << "test1.area() " << test1.area() << endl;

  Rectangle test2;
  test2.height = 50;
  cout << "test2.is_height_one() " << test2.is_height_one() << endl;

  // cout << "--------- test 1 --------"<< endl;
  return 0;
  /*int peri = test.perimeter();*/
  /*test.t1();*/
}
