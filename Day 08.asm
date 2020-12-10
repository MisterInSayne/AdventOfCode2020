section .bss
    %define buffer_len 1
    buffer: resb buffer_len
    length: resd 1
    text: resb 10240
    linestart: resd 1
    character: resd 1
    lineCount: resd 1
    linePlaces: resd 1024
    linePart: resb 1024
    lineLen: resd 1
    printText: resb 1024
    start: resd 1
    end: resd 1
    string: resb 1024
    strlen: resd 1
    substr: resb 128
    sum: resd 1
    
    lastInstruction: resd 1
    
    adjustedLine: resd 1
    
    accumulator: resd 1
    current: resd 1
    lineTested resd 1024
    
    DEBUG: resd 1
section .data
    indexTxt db 'Index '
    answerTxt db 'Answer: '
    goodTxt db 'Good!',0xa
    badTxt db 'Bad!',0xa
    jump db 'jmp'
    nope db 'nop'
    accum db 'acc'
    plus db 0x2B ; plus
    minus db 0x2D ; minus
    
section	.text
	global _start
_start:
    mov [DEBUG], dword 0
    mov [length], dword 0
    mov [linestart], dword 0
    mov [lineCount], dword 0
    mov [accumulator], dword 0
    mov [current], dword 0
    mov [adjustedLine], dword 0
readFile:
    call readLine
    cmp eax,0
    jne readFile
    dec dword [lineCount]
    
    
mainLoop:
    call setChecked
    
	call testInstruction
	
	call testIfChecked
	mov ecx, [adjustedLine]
	cmp eax, ecx
	je changeInstructions
	
	mov eax, [current]
	mov ecx, [lineCount]
	cmp eax, ecx
	jle mainLoop
	jmp finishUp
changeInstructions:
    mov eax, [adjustedLine]
	mov ecx, [lineCount]
	cmp eax, ecx
	je finishUp
	
	mov eax, [adjustedLine]
	call printNum
	
    mov eax, ' '
    call printChar
    
	mov eax, [current]
	call printNum
	
    mov eax, ' '
    call printChar
    
	mov eax, [accumulator]
	call printNum
	
	mov eax, 0xa
    call printChar
	
    mov [lineTested], dword 0
    mov [accumulator], dword 0
    mov [current], dword 0
	inc dword [adjustedLine]
	jmp mainLoop
	
	
finishUp:
	mov edx, 8
    mov ecx, answerTxt
	mov ebx, 1
	mov eax, 4
	int 0x80
	
	mov eax, [adjustedLine]
	call printNum
	
    mov eax, ' '
    call printChar
    
	mov eax, [current]
	call printNum
	
    mov eax, ' '
    call printChar
    
	mov eax, [accumulator]
	call printNum
End:
	mov eax, 1
	mov ebx, 0
	int 0x80




; ----------------- Functions

    
    
    
    
testInstruction:
    mov ecx, [current]
    call getArrayItem
    
    mov [start], dword 0
    mov [strlen], dword 3
    mov dword [string], linePart
    call getSubString
    
    cmp [substr], dword 'acc'
    je testInstructionAcc
    
    mov ecx, [current]
    mov eax, [adjustedLine]
    cmp ecx,eax
    je testInstructionAdjusted
    cmp [substr], dword 'jmp'
    je testInstructionJmp
    jmp testInstructionNop
testInstructionAdjusted:
    cmp [substr], dword 'nop'
    je testInstructionJmp
testInstructionNop:
    inc dword [current]
    jmp testInstructionEnd
testInstructionAcc:
    inc dword [current]
    
    
    mov [start], dword 5
	mov edx, [lineLen]
	sub edx, 5
    mov [strlen], edx
    mov dword [string], linePart
    call getSubString
    
    mov dword [string], substr
	call StrToInt
	
	mov [start], dword 4
    mov [strlen], dword 1
    mov dword [string], linePart
    call getSubString
    
    xor eax, eax
    mov eax, [sum]
    cmp [substr], dword 0x2b ; Plus
    je testInstructionAccAdd
	sub dword [accumulator], eax
	jmp testInstructionEnd
testInstructionAccAdd:
	add dword [accumulator], eax
    jmp testInstructionEnd
testInstructionJmp:
    mov [start], dword 5
	mov edx, [lineLen]
	sub edx, 5
    mov [strlen], edx
    mov dword [string], linePart
    call getSubString
    
    mov dword [string], substr
	call StrToInt
	
	mov [start], dword 4
    mov [strlen], dword 1
    mov dword [string], linePart
    call getSubString
    
    xor eax, eax
    mov eax, [sum]
    cmp [substr], dword 0x2b ; Plus
    je testInstructionJmpAdd
    sub dword [current], eax
    jmp testInstructionEnd
testInstructionJmpAdd:
    add dword [current], eax
    jmp testInstructionEnd
testInstructionEnd:
    ret
    
    
    
    
    
testIfChecked:
    xor eax, eax
    mov esi, lineTested
    mov ecx, [current]
    mov ebx, 4
    imul ecx, ebx
    add esi, ecx
    mov eax, [esi]
    ret
    
setChecked:
    xor eax, eax
    mov edi, lineTested
    mov ecx, [current]
    mov ebx, 4
    imul ecx, ebx
    add edi, ecx
    mov eax, [adjustedLine]
    mov [edi], eax
    ret
    
    
    

getSubString:
    mov [substr], dword 0
    mov esi, [string]
    add esi, [start]
    mov edi, substr
    mov ecx, [strlen]
    rep movsb
    ret



StrToInt:
    mov [sum], dword 0
    mov ecx, [strlen]
    xor eax, eax
    mov edi, [string]
StrToIntLoop:
    mov al, [edi]
    sub eax, 0x30
    mov edx, dword [sum]
    mov ebx, 10
    imul edx, ebx
    mov [sum], edx
    add dword[sum], eax
    inc edi
    dec ecx
    jne StrToIntLoop
    ret
    
outputFullArray:
    mov ecx,0
outputFullArrayLoop:
    call getArrayItem
    inc ecx
    cmp ecx, [lineCount]
    jle outputFullArrayLoop
    ret

getArrayItem:
    push ecx
    mov edi, linePlaces
    mov ebx, 4              ; multiply by 4 because 4 bytes
    imul ecx, ebx
    add edi, ecx
    mov edx, dword [edi]
    mov [end], edx
    cmp ecx, 0
    je getArrayItemIfZero
    sub edi, 4
    mov edx, dword [edi]
    mov [start], edx
    jmp getArrayItemIfCont
getArrayItemIfZero:
    mov [start], dword 0
getArrayItemIfCont:
    jmp getArrayItemEnd
    mov eax, [start]
    call printNum
    mov eax, '-'
    call printChar
    mov eax, [end]
    call printNum
    mov eax, ']'
    call printChar
    mov eax, ' '
    call printChar
getArrayItemEnd:
    call getArrayPart
    pop ecx
    ret

getArrayPart:
    mov esi, text
    add esi, [start]
    mov edi, linePart
    mov ecx, [end]
    sub ecx, [start]
    rep movsb
    
    
    mov edx, [end]
	sub edx, [start]
	mov [lineLen], edx
	jmp getArrayPartEnd
	mov ecx, linePart
	mov ebx, 1
	mov eax, 4
	int 0x80
getArrayPartEnd:
    ret

readLine:
    mov edi, text
    add edi, [length]
    mov eax, [length]
    mov [linestart],dword eax
readLineLoop:
    mov edx, buffer_len
	mov ecx, buffer
	mov ebx, 0
	mov eax, 3
	int 0x80
	cmp eax, 0 ; end of file
	jle readLineEndOfLine
	cmp [buffer], byte 0xa ; end of line
	je readLineEndOfLine
	mov ebx, dword [buffer]
	mov [edi], ebx
	inc dword [length]
	inc edi
	jmp readLineLoop
readLineEndOfLine:
    push eax
    cmp [DEBUG], dword 0
    je readLineSkipDebug
    
    mov eax, [lineCount]
    call printNum
    mov eax, ':'
    call printChar
    mov eax, [length]
    sub eax, [linestart]
    call printNum
    mov eax, 0xa
    call printChar
    
readLineSkipDebug:
    mov edi, linePlaces
    mov edx, [lineCount]
    mov ebx, 4              ; multiply by 4 because 4 bytes
    imul edx, ebx
    add edi, edx
    mov ebx, dword [length]
    mov [edi], ebx
    inc dword [lineCount]
    pop eax
    ret

printNum:
    push eax
    push ecx
    push edx
    push ebx
    mov ecx, 10
printNumLoop: 
    mov edx,0
    call divbyten
    add edx, 0x30
    push edx
    dec ecx
    cmp eax, 0
    je printNumPart2
    cmp ecx, 0
    jne printNumLoop
printNumPart2:
    mov ebx, ecx
    mov ecx, 10
    sub ecx, ebx
printNumLoop2:
    pop eax
    call printChar
    dec ecx
    jne printNumLoop2
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret
    
divbyten:
    push ebx
    mov ebx, 10
    mov edx, 0
    idiv ebx
    pop ebx
    ret
    
printChar:
    push ecx
    push edx
    mov [character], eax
    mov edx, 1
	mov ecx, character
	mov ebx, 1
	mov eax, 4
	int 0x80
	pop edx
	pop ecx
	ret

printGood:
    push ecx
    mov edx, 6
    mov ecx, goodTxt
	mov ebx, 1
	mov eax, 4
	int 0x80
	pop ecx
    ret

printBad:
    push ecx
    mov edx, 5
    mov ecx, badTxt
	mov ebx, 1
	mov eax, 4
	int 0x80
	pop ecx
    ret

printIndexTag:
    push ecx
    mov edx, 6
    mov ecx, indexTxt
	mov ebx, 1
	mov eax, 4
	int 0x80
	pop ecx
    ret
    