#include <stdio.h>
#include <stdlib.h>

extern void super_printf(char * str, ...);

void print(int x) {
    printf("\nx is %d\n", x);
}


int main() {
    //printf("\n>>> main(): super_printf\n\n");

    long long       par1 = -123456;
    int             par2 = 5;
    const char      par3 = 'c';
    const char *    par4 = "STRING";
    long long       par5 = 90;
    const char      par6 = '0';
    int             par7 = -1234;
    int             par8 = 5555;

    char str[] = "%d\n%b\n%c\n%s\n\b%x\n%c\n\n%o\n%o\n";
    char str2[] = "%d %s %x %d %c %b\n";

    super_printf(str, par1, par2, par3, par4, par5, par6, par7, par8);
    printf("-------------------\n\n");

    //printf      (str, par1, par2, par3, par4, par5, par6, par7, par8);

    printf("-------------------\n\n");

    long long a = 7;
    super_printf("%d %d %d %d %d %d\n", 74747, 'c',7884, 1234, 12, 5555);


    // char str[] = "%d\n %b\n %c\ n%s \n%x \n%c \n\n%o \n%o\n";
    // char str2[] = "%d %s %x %d %c %b\n";

    // super_printf(str, par1, par2, par3, par4, par5, par6, par7, par8);
    // printf("-------------------\n\n");

    // printf(str, par1, par2, par3, par4, par5, par6, par7, par8);

    // printf("-------------------\n\n");




    //printf("\n<<< main(): end\n\n");
    return 0;
}