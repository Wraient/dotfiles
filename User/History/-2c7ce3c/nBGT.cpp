#include <iostream>

using namespace std;

class Complex
{
    public:
        int real=0;
        int img=0;

        void print(){
            cout << real << " + " << img << "i"<<endl;
        }

};


int main(){

    Complex c1;
    c1.real = 3;
    c1.img = 4;
    cout << c1.real<<endl;
    cout << c1.img<<endl;


    return 0;
}