;:====================================================
;: 0-Linux-nasm-64.s                   (c)macho64,2024
;:====================================================

section .text

global super_printf

; Почему если убрать push rbp вместе с pop rbp то будет ошибка, хотя стек сбалансирован-------?????????????


; fast div
; jump table
; %d < 0

;; %c (done) tested
;; %s (done) tested
;; %d (done) tested
;; %%
;; %x (done) tested
;; %o (done) tested
;; %b (done) tested


;; =====================================================================
;;                          super_printf
;; =====================================================================
;; emulates C printf
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Signature: void super_printf(char * str, ...)
;;
;; Entry:  /RDI/  --  ptr to str
;;
;; Destr:  /RSI/  
;; ---------------------------------------------------------------------
super_printf:   

                pop rax         ; ret address

                push r9         ;
                push r8         ;
                push rcx        ; register srgs to stack
                push rdx        ;
                push rsi        ;


                push rbp        ;
                mov rbp, rsp    ; bp for stack frame


                mov rsi, rdi    ; ptr to str
                push rax

        printf_loop:

                cmp byte [rsi], '%'
                jne not_percent

                inc rsi         ; skip %

                xor rcx, rcx
                xor rax, rax

                mov al, [rsi]                   ;
                sub al, 'b'                     ;
                shl rax, 3                      ; jmp jump_table + ([rsi] - 'b') * 8
                add rax, jump_table             ;
                
                jmp [rax]

                jmp percent


not_percent:
                call print_char
percent:
;; -------------------------- check '\0' -------------------------------

                cmp byte [rsi], 0
                je end_of_str

;; ---------------------------------------------------------------------

                inc rsi
                loop printf_loop

        end_of_str:
                pop rax

                pop rbp

                add rsp, 40             ; pop 5
                push rax
                ret
            








;; =====================================================================
;;                          print_char
;; =====================================================================
;; writes char to stdout
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Entry:  /RSI/  --  pointer to char
;;
;;
;; Side Effects: writes char to stdout
;;
;; Destr: -
;; ---------------------------------------------------------------------
print_char:
                push rax
                push rdi
                push rdx
                push rcx

                mov rax, 0x01           ; write64 (rdi, rsi, rdx) ... r10, r8, r9
                mov rdi, 1              ; stdout
                mov rdx, 1              ; strlen (Msg)
                syscall

                pop rcx
                pop rdx
                pop rdi
                pop rax

                ret






;; =====================================================================
;;                          print_number
;; =====================================================================
;; prints number to stdout
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;;
;; Entry:       /СL/  --  на сколько сдвиг
;;
;;              /RAX/  --  argument to print
;;
;;              /R8/  -- delitel
;;
;; Destr: /RAX/  /RBP/  /RCX/  /RDX/
;; ---------------------------------------------------------------------

print_number:

                xor rax, rax            ;
                mov eax, [rbp + 8]      ; take arg from stack    
                add rbp, 8              ;      

                mov r14, rcx
                dec r8

                mov rcx, buffer                 ; rcx = ptr to buffer

                xor rdx, rax


;; ------------------------rax below zero-------------------------------

                test rax, 80000000h 
                jz itoa_loop

                mov r13, neg_flag
                mov byte [r13], 1
                neg eax

;; ---------------------------------------------------------------------

        itoa_loop:
                mov rdx, rax
                push rcx
                mov rcx, r14
                                        ; make a func to make divs <<< >>>> ------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                shr rax, cl             ; div to the base of the sistema schslenia
                                        ; rdx = rdx:rax % rbx
                                        ; rax = rdx:rax / rbx

                pop rcx

                and rdx, r8


                add rdx, hex_alphabet          ;
                mov bl, [rdx]                  ; mov [rcx], hex_apphabet[rdx]
                mov [rcx], bl                  ;

                inc rcx
                cmp rax, 0
                je end_of_ioa_loop

                xor rdx, rdx
 
                inc rcx                 ; because loop "eat" one inc
                loop itoa_loop
                
        end_of_ioa_loop:

;; -----------------------below zero correction--------------------------

                mov r13, neg_flag
                cmp byte [r13], 0
                mov byte [r13], 0
                je positive_number

                mov byte [rcx], '-'
                inc rcx
;; ---------------------------------------------------------------------

        positive_number:

                sub rcx, buffer   ; size of stack

                call print_buffer
                ret




;; =====================================================================
;;                          print_buffer
;; =====================================================================
;; prints stack in reversed order
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Entry:       /RCX/  --  size of stack
;;
;;
;; Destr: /RCX/
;; ---------------------------------------------------------------------
print_buffer:
                push rsi                ; save ptr to str

                mov rsi, rcx            ;
                add rsi, buffer         ; rsi = buffer[size]
                dec rsi                 ;
                
        
        print_buffer_loop:
                                        
                call print_char
                dec rsi 

                loop print_buffer_loop

                pop rsi
                ret

binary_type:
        mov cl, 1
        mov r8, 2
        call print_number
        jmp percent

char_type:
        xor r11, r11
        push rsi
        mov rsi, buffer

        mov byte r11, [rbp + 8]
        add rbp, 8
        mov [rsi], r11

        call print_char
        pop rsi
        jmp percent

int_type:

        call print_integer
        jmp percent

type_oct:
        mov cl, 3
        mov r8, 8
        call print_number
        jmp percent

type_string:
        push rdi
        push rsi
        mov rdi, [rbp + 8]              ; take next agr from stack
        add rbp, 8                      ;

        call super_printf
        pop rsi
        pop rdi
        jmp percent

type_hex:
        mov cl, 4
        mov r8, 16
        call print_number
        jmp percent       


align 8
jump_table:
        dq binary_type          ; b
        dq char_type            ; c
        dq int_type             ; d
        times 10 dq 'd'         ; d - o
        dq type_oct             ; o
        times 3 dq 'o'
        dq type_string          ; s
        times 4 dq 's'
        dq type_hex             ; x






print_integer:
                mov r12, 10
                xor rax, rax
                mov eax, [rbp + 8]             
                add rbp, 8                         
                mov rcx, buffer                 ; rcx = ptr to buffer
                xor rdx, rdx
;; ------------------------rax below zero-------------------------------
                test rax, 80000000h 
                jz print_integer_loop
                mov r13, neg_flag
                mov byte [r13], 1
                neg eax
;; ---------------------------------------------------------------------
        print_integer_loop:
                                        ; make a func to make divs <<< >>>> ------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                div r12                 ; div to the base of the sistema schslenia
                                        ; rdx = rdx:rax % rbx
                                        ; rax = rdx:rax / rbx
                add rdx, hex_alphabet          ;
                mov bl, [rdx]                  ; mov [rcx], hex_apphabet[rdx]
                mov [rcx], bl                  ;
                inc rcx
                cmp rax, 0
                je print_integer_end_of_ioa_loop
                xor rdx, rdx
                inc rcx                 ; because loop "eat" one inc
                loop print_integer_loop
        print_integer_end_of_ioa_loop:
;; -----------------------below zero correction--------------------------
                mov r13, neg_flag
                cmp byte [r13], 0
                mov byte [r13], 0
                je  print_integer_positive_number
                mov byte [rcx], '-'
                inc rcx
;; ---------------------------------------------------------------------
        print_integer_positive_number:
                sub rcx, buffer   ; size of stack
                call print_buffer
                ret








section     .data
            
Msg:        db "haha", 0x0a
MsgLen      equ $ - Msg

buffer times 256 db 0
hex_alphabet: db '0123456789abcdef'
neg_flag db 0
ret_addres dq 0