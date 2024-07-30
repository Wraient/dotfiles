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
    cout << c1.real<<endl;


    return 0;
}