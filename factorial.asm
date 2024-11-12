.model small
.stack 100h
.data
    prompt db 'Enter a single digit number (0-9): $'
    result_msg db 0Dh,0Ah,'The factorial is: $'
    factorial dw 1    ; 16-bit variable to store factorial result
.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax
    ; Display prompt to enter a number
    mov ah, 09h
    lea dx, prompt
    int 21h
    ; Read a single character input
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov bl, al         ; Store the number in BL for calculation
    ; Special case for 0! which is 1
    cmp bl, 0
    jne calculate_factorial
    mov factorial, 1
    jmp display_result
calculate_factorial:
    mov cx, bx         ; Set loop counter to the number entered (n)
    mov ax, 1          ; AX will store the ongoing factorial result
factorial_loop:
    mul cx             ; AX = AX * CX (calculate factorial)
    loop factorial_loop ; Decrement CX and repeat until CX = 0
    mov factorial, ax  ; Store final factorial result in 'factorial'
display_result:
    ; Display result message
    mov ah, 09h
    lea dx, result_msg
    int 21h
    ; Convert the result in factorial to ASCII and display
    mov ax, factorial  ; Load factorial result into AX
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