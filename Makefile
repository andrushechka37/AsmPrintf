.Phony print: printf.o main.c
	clang-14 -no-pie -g -O0 main.c printf.o && ./a.out

printf.o: printf.s
	nasm -f elf64 -g -l printf.lst printf.s


