#include <stdio.h>

int main(){
    for(int i=0; i<200; i+=20){
        float c = (5*(i-32))/9;
        printf("%i",i);
        printf(" ");
        printf("%f",c);
        printf("\n");
        // printf("%i %i", i, )
    }
    // C=(5/9)(F-32)
}