section .text

    global _start

_start:
    mov rsi, msg        ; Указатель на строку
    mov rcx, len        ; Длина строки
print_loop:
    mov rdi, 1          ; Файловый дескриптор 1 - stdout
    mov rdx, 1          ; Длина выводимых данных (один символ)
    mov rax, 0x2000004  ; Системный вызов write
    syscall

    inc rsi             ; Увеличиваем указатель на символ
    loop print_loop     ; Повторяем цикл, пока не выведем все символы

    ;mov rax, 0x2000001  ; Системный вызов exit
    ;xor rdi, rdi        ; Код возврата 0
    ;syscall

    ret

section .data
    msg db 'Hello, World!', 0
    len equ $ - msg

; ld -e start -static -o 1 printf.o
; nasm -f macho64 printf.s