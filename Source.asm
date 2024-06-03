COAL PROJECT:
INCLUDE Irvine32.inc

.data
    topBorder BYTE "                                              ******************************************", 0Dh, 0Ah, 0
    
    welcomeMsg BYTE "                                              | WELCOME TO BINARY TO DECIMAL CONVERTOR |", 0
    bottomBorder BYTE "                           ********************************************************************************", 0Dh, 0Ah, 0
    chooseMsg BYTE "                                              |            Choose An Option?           |", 0Dh, 0Ah, 0
    option1 BYTE "                                              |           1. Binary To Decimal         |", 0Dh, 0Ah, 0
    option2 BYTE "                                              |           2. Decimal To Binary         |", 0Dh, 0Ah, 0
    option3 BYTE "                                              |           3. Exit                      |", 0Dh, 0Ah, 0
    inputPrompt BYTE "                                                         Enter your choice: ", 0
    binaryInput BYTE 32 DUP(?)     ; Buffer to store the binary input
    binToDecPrompt BYTE "                                              Enter a binary number (only 1s and 0s): ", 0
    decToBinPrompt BYTE "                                                       Enter a decimal number: ", 0
    errorMsg BYTE "                                              Invalid input! Please enter only 1 or 0.", 0Dh, 0Ah, 0
    resultPrompt BYTE "                                              The result is: ", 0
    newline BYTE 0Dh, 0Ah, 0       ; Newline characters
    decimalValue DWORD ?           ; Variable to store the decimal result
    buffer DWORD ?                 ; Storage for the decimal input
    binaryBuffer BYTE 33 DUP(0)    ; Buffer to hold binary representation (32 bits + null terminator)

.code
main PROC
; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
    ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString
    
    ; Display the side border, welcome message, and close side border
   
    mov edx, OFFSET welcomeMsg
    call WriteString
 
    ; Move to the next line
    mov edx, OFFSET newline
    call WriteString
    
     ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString


mainLoop:
 ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
     ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString
    ; Display the options
    mov edx, OFFSET chooseMsg
    call WriteString

     ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString

     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString


     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
    ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString

    mov edx, OFFSET option1
    call WriteString

    mov edx, OFFSET option2
    call WriteString

    mov edx, OFFSET option3
    call WriteString

    ; Display the top border
    mov edx, OFFSET topBorder
    call WriteString

     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

    ; Prompt the user for input
    mov edx, OFFSET inputPrompt
    call WriteString

    

    ; Read the user's choice
    call ReadDec

     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

  
        ; Display the bottom border
    mov edx, OFFSET bottomBorder
    call WriteString

    cmp eax, 1
    je binaryToDecimal
    cmp eax, 2
    je decimalToBinary
    cmp eax, 3
    je exitProgram
    jmp mainLoop                 ; Invalid choice, show the menu again

binaryToDecimal:
    ; Display the binary to decimal prompt
    mov edx, OFFSET binToDecPrompt
    call WriteString

    ; Read the binary input
    mov edx, OFFSET binaryInput
    mov ecx, 32                    ; Maximum input length
    call ReadString

    ; Validate the input
    mov esi, OFFSET binaryInput    ; Point to the start of the binary input
    mov ecx, 0                     ; Clear ECX to use as an index

validateLoop:
    ; Check for the end of the string
    cmp byte ptr [esi + ecx], 0
    je convertBinary

    ; Check if the character is '0'
    cmp byte ptr [esi + ecx], '0'
    je validChar
    cmp byte ptr [esi + ecx], '1'
    je validChar

    ; If not '0' or '1', print error message and restart input loop
    mov edx, OFFSET errorMsg
    call WriteString
    jmp binaryToDecimal

validChar:
    inc ecx                        ; Move to the next character
    jmp validateLoop



convertBinary:
    ; Convert binary to decimal
    mov eax, 0                     ; Clear EAX to store the decimal result
    mov ecx, 0                     ; Clear ECX to use as an index

convertLoop:
    ; Check for the end of the string
    cmp byte ptr [esi + ecx], 0
    je conversionDone

    ; Shift left EAX (multiply by 2)
    shl eax, 1

    ; If the current character is '1', add 1 to EAX
    cmp byte ptr [esi + ecx], '1'
    jne skipAddition
    add eax, 1

skipAddition:
    inc ecx                        ; Move to the next character
    jmp convertLoop

conversionDone:
    ; Store the result in decimalValue
    mov decimalValue, eax

    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

    ; Display the result prompt
    mov edx, OFFSET resultPrompt
    call WriteString

    ; Convert the decimal value to string and display it
    mov eax, decimalValue
    call WriteDec
    
    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

            ; Display the bottom border
    mov edx, OFFSET bottomBorder
    call WriteString

    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString


    ; Return to main menu
    jmp mainLoop

decimalToBinary:
 ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

    ; Display the decimal to binary prompt
    mov edx, OFFSET decToBinPrompt
    call WriteString

    ; Read the decimal input
    call ReadInt
    mov buffer, eax               ; Store the input in buffer

    ; Initialize the binaryBuffer with zeros
    mov ecx, 32
    mov esi, OFFSET binaryBuffer
initBuffer:
    mov byte ptr [esi], '0'
    inc esi
    loop initBuffer
    mov byte ptr [esi], 0         ; Null-terminate the buffer

    ; Convert the number to binary
    mov ecx, 32                   ; Initialize counter for 32 bits
    mov esi, OFFSET binaryBuffer + 31 ; Point to the end of the buffer (excluding null terminator)
    mov eax, buffer               ; Load the number to convert

convertLoop2:
    test eax, 1                   ; Test the least significant bit
    jz zeroBit2
    mov byte ptr [esi], '1'
    jmp nextBit2
zeroBit2:
    mov byte ptr [esi], '0'
nextBit2:
    shr eax, 1                    ; Shift right logical (divides eax by 2)
    dec esi                       ; Move buffer pointer back
    loop convertLoop2
     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

    ; Display the result prompt
    mov edx, OFFSET resultPrompt
    call WriteString

    ; Display the binary result
    mov edx, OFFSET binaryBuffer
    call WriteString
     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

     ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString

            ; Display the bottom border
    mov edx, OFFSET bottomBorder
    call WriteString

    ; Print a newline for better readability
    mov edx, OFFSET newline
    call WriteString
   
    ; Return to main menu
    jmp mainLoop

exitProgram:
    ; Exit the program
    call ExitProcess

main ENDP

END main

