#include <stdio.h>
#include <stdlib.h>

extern void hui();


int main() {
    printf("\n>>> main(): start\n\n");

    int a = 85, b = 14;

    hui();

    printf("\n<<< main(): end\n\n");
    return 0;
}