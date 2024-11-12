.model small
.stack 100h
.data
    prompt db 'Enter a single digit number (0-9) for n: $'
    result_msg db 0Dh,0Ah,'The nth Fibonacci number is: $'
    fib dw 0       ; Store the nth Fibonacci number in a word (16 bits)

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Prompt the user for input
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Read a single character input
    mov ah, 01h
    int 21h
    sub al, '0'    ; Convert ASCII to integer (0-9)
    mov cl, al     ; Store n in cl

    ; Check for n = 0 or n = 1 directly
    cmp cl, 1
    jbe single_digit_fib
    ; For n > 1, calculate Fibonacci using loop

    ; Initialize Fibonacci values
    mov ax, 0      ; First Fibonacci number (16-bit for larger values)
    mov bx, 1      ; Second Fibonacci number (16-bit)

fib_loop:
    dec cl         ; Decrease count
    jz store_result ; If count reaches zero, store result

    ; Calculate next Fibonacci number
    add ax, bx     ; F_n = F_(n-1) + F_(n-2)
    xchg ax, bx    ; Move F_(n-1) to F_(n-2) and update F_(n-1)
    jmp fib_loop   ; Repeat loop until cl = 0

store_result:
    mov fib, ax    ; Store the result in fib

single_digit_fib:
    ; For n = 0 or 1, bx already contains the correct Fibonacci number
    cmp cl, 0
    je show_fib0
    mov fib, bx    ; For n=1, F_1 is 1
    jmp display_result

show_fib0:
    mov fib, ax    ; For n=0, F_0 is 0

display_result:
    ; Display result message
    mov ah, 09h
    lea dx, result_msg
    int 21h

    ; Convert the result in fib to ASCII and display
    mov ax, fib        ; Load result into ax
    call print_number  ; Call subroutine to print the number

    ; Exit program
    mov ah, 4Ch
    int 21h

main endp

; Subroutine to print a number in AX as ASCII
print_number proc
    ; Divide ax by 10 repeatedly to extract each digit in reverse
    mov cx, 10        ; Set base to 10
    mov bx, 0         ; Initialize bx as digit storage

reverse_digits:
    xor dx, dx        ; Clear dx for division
    div cx            ; AX / 10, quotient in AX, remainder in DX
    push dx           ; Push remainder onto stack (digit)
    inc bx            ; Count digits
    test ax, ax       ; Check if quotient is 0
    jnz reverse_digits

display_digits:
    pop dx            ; Get last pushed digit
    add dl, '0'       ; Convert to ASCII
    mov ah, 02h       ; DOS print character function
    int 21h           ; Display character
    dec bx            ; Decrement digit count
    jnz display_digits

    ret
print_number endp

end main