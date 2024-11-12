.model small
.stack 100h
.data
    num1 db 2          ; First number (single byte)
    num2 db 5          ; Second number (single byte)
    gcd_res db 0       ; To store GCD result (single byte)
    lcm_res dw 0       ; To store LCM result (two bytes for larger result)
    msg db 'LCM is: $' ; Message to display before the result
.code
main:
    mov ax, @data
    mov ds, ax         ; Initialize data segment

    ; Load num1 and num2 into AL and BL for GCD calculation
    mov al, num1
    mov bl, num2
    call gcd           ; Calculate GCD of num1 and num2
    mov gcd_res, al    ; Store GCD in gcd_res

    ; Calculate LCM using (num1 * num2) / GCD
    mov al, num1       ; Load num1 into AL
    mov ah, 0          ; Clear AH for 16-bit multiplication
    mov dl, num2       ; Load num2 into DL
    mul dl             ; AX = num1 * num2 (result in AX)

    ; Divide AX by the GCD (stored in gcd_res)
    mov cl, gcd_res    ; Load GCD into CL
    div cl             ; AX = (num1 * num2) / GCD

    ; Store the result in lcm_res
    mov lcm_res, ax

    ; Display "LCM is: "
    mov ah, 09h        ; DOS interrupt to display string
    lea dx, msg        ; Load the address of the message into DX
    int 21h

    ; Display the LCM result (convert to ASCII and print)
    mov ax, lcm_res    ; Load LCM result into AX
    call print_num     ; Call function to print number

    ; End the program
    mov ah, 4Ch
    int 21h

; Function to calculate GCD using the Euclidean algorithm
gcd proc
    cmp bl, 0
    je end_gcd         ; If BL = 0, GCD is in AL

gcd_loop:
    mov ah, 0
    div bl             ; Divide AL by BL, remainder in AH
    mov al, bl         ; Move BL to AL (new A)
    mov bl, ah         ; Move remainder to BL (new B)
    cmp bl, 0
    jne gcd_loop       ; Repeat until remainder (B) = 0

end_gcd:
    ret                ; Final GCD is in AL
gcd endp

; Function to print a number in AX
print_num proc
    ; Divide the number by 10 and print each digit
    mov cx, 0          ; Clear CX (will store digits)
    mov bx, 10         ; Divisor for base-10

convert_loop:
    xor dx, dx         ; Clear DX before division
    div bx             ; AX / 10, quotient in AX, remainder in DX
    push dx            ; Save remainder (digit) on the stack
    inc cx             ; Increment digit count
    cmp ax, 0
    jne convert_loop   ; Repeat until the quotient is 0

print_digits:
    pop dx             ; Get digit from stack
    add dl, '0'        ; Convert digit to ASCII
    mov ah, 02h        ; DOS interrupt to print character
    int 21h
    loop print_digits  ; Repeat for all digits

    ret
print_num endp

end main