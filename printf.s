;:====================================================
;: 0-Linux-nasm-64.s                   (c)macho64,2024
;:====================================================

section .text

global super_printf                     ; predefined entry point name for ld

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

                call switch_func
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
;;                          print_int
;; =====================================================================
;; prints int iumber
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;;
;; Entry:       /R12/  --  основание системы счисления
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

                                        ; make a func to make divs <<< >>>> ------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                mov rax, r9             ; mov 2 arg from super printf
                mov rcx, buffer         ;
                xor rdx, rdx
                

        itoa_loop:

                div r12                 ; div to the base of the sistema schslenia
                                        ; rdx = rdx:rax % rbx
                                        ; rax = rdx:rax / rbx

                add rdx, hex_alphabet          ;
                mov bl, [rdx]                  ; mov [rcx], [rdx + hex_alphabet]
                mov [rcx], bl                  ;

                inc rcx
                cmp rax, 0
                je end_of_ioa_loop

                xor rdx, rdx
 
                inc rcx                 ; because loop "eat" one inc
                loop itoa_loop
                
        end_of_ioa_loop:

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
                
                inc rcx
        
        print_buffer_loop:
                                        
                call print_char
                dec rsi 

                loop print_buffer_loop

                pop rsi
                ret



;; =====================================================================
;;                          fast_div
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
;; Entry:             /R12/  --  delitel
;;
;;              /RDX/:/RAX/  --  delimoe
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
;fast_div:
                ;cmp r12, 10
                ;je decimal

               ; mov rdx, rax            ;
                ;shr rax, r12            ;
                ;rol rdx, r12            ; rdx - остаток
                ;neg r12                 ;
                ;add r12, 64             ;
                ;shr rdx, r12            ;

                ;ret

        ;decimal:
                ;div r12
                ;ret


switch_func:

                cmp byte [rsi], 'o'
                mov r12, 8
                je end_of_swith

                cmp byte [rsi], 'x'
                mov r12, 16
                je end_of_swith

                cmp byte [rsi], 'b'
                mov r12, 2
                je end_of_swith

                cmp byte [rsi], 'd'
                mov r12, 10
                je end_of_swith 

                cmp byte [rsi], 'c'
                je char_func
                cmp byte [rsi], 's'
                je str_func             ; обработка ошибок
                
        end_of_swith:

                call print_int
                ret
        char_func:
                call print_char
                ret
        str_func:
                call super_printf
                ret


section     .data
            
Msg:        db "haha", 0x0a
MsgLen      equ $ - Msg

buffer times 256 db 0
hex_alphabet: db '0123456789abcdef'