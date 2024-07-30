#include <stdio.h>

int main(){
    printf("Hello world\n");

    primenumberstill(100);

    return 0;
}

int isPrime(int i){
    if(i <= 1){
        return 0;
    }
    for(int j=2; j*j <= i; j++){
        if(i % j == 0){
            return 0;
        }
    }
    return 1;
}
void primenumberstill(int num){
    for(int i=0; i<num; i++){
        if(isPrime(i)){
            printf("%d ", i);
        }
    }
}
