#include <stdio.h>
int even(int x){
    int count = 0;
    for(int i = 0;i<9;i = i+2){
        if(x & (1U<<i)){
            count++;
        }
    }
    return count;
}
int odd(int x){
    int count = 0;
    for(int i = 1;i<10;i = i+2){
        if(x & (1U<<i)){
            count++;
        }
    }
    return count;
}
int main(){
    printf("please enter a integer in range 0 to 1000: ");
    int x;
    scanf("%d",&x);
    while(x < 0 || x > 1000){
        printf("please enter again in range 0 to 1000 :");
        scanf("%d",&x);
    }
    printf("[%d,%d]\n",even(x),odd(x));
    return 0;
}
