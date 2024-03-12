#include <stdio.h>
#include <stdlib.h>

extern void super_printf(char * str, int a);

void print(int x) {
    printf("\nx is %d\n", x);
}


int main() {
    //printf("\n>>> main(): super_printf\n\n");

    int a = 19349857;

    char str[] = "haha %d gogohe\n\n";
    super_printf(str, a);

    //printf("\n<<< main(): end\n\n");
    return 0;
}