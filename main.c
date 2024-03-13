#include <stdio.h>
#include <stdlib.h>

extern void super_printf(char * str, ...);

void print(int x) {
    printf("\nx is %d\n", x);
}


int main() {
    //printf("\n>>> main(): super_printf\n\n");

    int a = 1234;
    int b = 78;
    int c = 9898;
    int d = 4;

    super_printf("%b %o %x %x\n\n", a, b, c ,d);

    //printf("\n<<< main(): end\n\n");
    return 0;
}