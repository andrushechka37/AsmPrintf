;:====================================================
;: 0-Linux-nasm-64.s                   (c)macho64,2024
;:====================================================

section .text

global super_printf                     ; predefined entry point name for ld


;; организовать свой стек для dec to str
;; универсальная преобразовалка с основанием системы счисления с алфавитом как в резиденте
;; пушить в буфер в обратном порядке потом функция которая нужное колво раз вызывает принтчар 



;; %c (done)
;; %s (done)
;; %d
;; %%
;; %x
;; %o
;; %b 


;; =====================================================================
;;                          super_printf
;; =====================================================================
;; emulates C printf
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Signature: void super_printf(char * str);
;;
;; Entry:  /RDI/  --  ptr to str
;;
;;
;; Note: 
;;
;;
;;
;; Side Effects:
;;
;; Destr:  place holder
;; ---------------------------------------------------------------------
super_printf:   
                mov r9, rsi
                mov rsi, rdi            ; ptr to str

        printf_loop:

                cmp byte [rsi], '%'
                jne not_percent

                inc rsi

                call print_int
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
                ret
            








;; =====================================================================
;;                          print_char
;; =====================================================================
;; writes char to stdout
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Entry:  /RDI/  --  pointer to char
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
;;                          print_int
;; =====================================================================
;; prints int iumber
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Signature: 
;;
;;
;;
;; Expect: 
;;
;;
;; Entry: 
;;
;;
;; Return: 
;;
;;
;; Note: 
;;
;;
;; Call Convention: CDECL
;;
;; Side Effects:
;;
;; Destr: 
;; ---------------------------------------------------------------------

print_int:

                mov r11, 10             ; make a func to make divs <<< >>>> ------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                mov rax, r9             ; mov 2 arg from super printf
                mov rcx, buffer         ;
                xor rdx, rdx
                

        itoa_loop:

                div r11                 ; div to the base of the sistema schslenia
                                        ; rdx = rdx:rax % rbx
                                        ; rax = rdx:rax / rbx

                add rdx, hex_alphabet
                mov bl, [rdx]   ; mov [rcx], [rdx + hex_alphabet]
                mov [rcx], bl                  ;z

                inc rcx
                cmp rax, 0
                je end_of_ioa_loop

                xor rdx, rdx
 
                inc rcx                 ; because loop "eat" one inc
                loop itoa_loop
                
        end_of_ioa_loop:

                sub rcx, buffer   ; size of stack

                mov r11, [buffer]
                mov r12, [buffer + 1]
                call print_buffer

                ret




;; =====================================================================
;;                          print_buffer
;; =====================================================================
;; 
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; Signature: 
;;
;;
;;
;; Expect: 
;;
;;
;; Entry: /RCX/  --  size of stack
;;
;;
;; Return: 
;;
;;
;; Note: 
;;
;;
;; Call Convention: CDECL
;;
;; Side Effects:
;;
;; Destr: 
;; ---------------------------------------------------------------------
print_buffer:
                push rsi                ; save ptr to str

                mov rsi, rcx            ;
                add rsi, buffer         ; rsi = buffer[size]
                
                inc rcx
        
        print_buffer_loop:
                                        ; rep??????????
                call print_char

                dec rsi 
                loop print_buffer_loop



                pop rsi
                ret







section     .data
            
Msg:        db "haha", 0x0a
MsgLen      equ $ - Msg

buffer times 256 db 0
hex_alphabet: db '0123456789abcdef'