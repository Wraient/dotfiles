#include <stdio.h>

#define LOWER 0
#define UPPER 300
#define STEP 20

int main(){
    // int farh;
    for(int farh=LOWER; farh<=UPPER; farh=farh+STEP){
        // printf("%f")
        printf("%3d%6.1f\n", farh, (5.0/9.0)*(farh-32.0));
        
    }
}