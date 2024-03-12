.Phony print: printf.o main.c
	gcc -no-pie main.c printf.o && ./a.out

printf.o: printf.s
	nasm -f elf64 -l printf.lst printf.s