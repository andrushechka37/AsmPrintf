.Phony print: printf.o main.c
	gcc -no-pie -g main.c printf.o && ./a.out

printf.o: printf.s
	nasm -f elf64 -g -l printf.lst printf.s


