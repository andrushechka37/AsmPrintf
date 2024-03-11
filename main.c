#include <stdio.h>
#include <stdlib.h>

extern void start();

char str[] = "12";

int main() {
    printf("\n>>> main(): start\n\n");

    int a = 85, b = 14;

    start();

    printf("\n<<< main(): end\n\n");
    exit(0);
}