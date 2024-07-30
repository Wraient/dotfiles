#include <stdio.h>

int main(){
    for(float i=0.0; i<=300.0; i+=20.0){
        float c = (5.0*(i-32.0))/9.0;
        printf("%3.0d\t%3.1d\n",i,c);
    }
}