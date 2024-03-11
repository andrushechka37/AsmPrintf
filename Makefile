.Phony print: main.o printf.o
	arch -x86_64 gcc main.o printf.o -o main

main.o: main.c
	arch -x86_64 gcc -c main.c

printf.o: printf.s
	nasm -f macho64 printf.s
# TODO: Put some effort in your makefile