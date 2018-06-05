.model	small
.stack	100h
.data

 MaxLen db 5
 Len db 0
 buff db 5 dup (0)
 minus db 0       

mas1 db 5 dup('$') 
mas2 db 5 dup('$')
mas3 db 5 dup('$')
mas4 db 5 dup('$')        
enter_massiv db 'New Array: ', 0Dh,0Ah, '$'
output_massiv1 db 'Output Array1: ', 0Dh,0Ah, '$'    
output_massiv2 db 'Output Array2: ', 0Dh,0Ah, '$'
output_massiv3 db 'Output Array3: ', 0Dh,0Ah, '$'
output_massiv4 db 'Output Array4: ', 0Dh,0Ah, '$' 
enter db '', 0Dh,0Ah,'$'
minus1 db ' -','$'  

ErrInpMsg db 'Error Input!!!',13,10,'$'
InpMsg db 'Input '                              
Count db 0,' element (-11..11) :',13,10,'$'

.code
start:
mov	ax,@data
mov	ds,ax
mov	es,ax
xor	ax,ax           ; ax = 0

call input         
call Do
call output

mov ah,8            ; wait for getch
int 21h

mov	ax,4c00h        ; return control to OC
int	21h

input proc
xor di,di           ; di = 0
mov cx,5            ; cx = 7, input 7 element
inputLoop:
call inputEl
inc di              ; di++
loop inputLoop      ; go to next iteration of cycle, cx--
ret
endp

inputEl proc
push cx              ; add cx to stack
inputElMain:
mov mas1[di],0 
mov mas2[di],0 
mov mas3[di],0 
mov mas4[di],0         ; mas[di] = 0
call InputMsg        ; show string about enter new symbol
mov ah,0Ah                ; enter symbol
mov dx,offset MaxLen      ; in MaxLen
int 21h

mov dl,10              ; dl = 10
mov ah,2
int 21h

cmp Len,0              ; compare Len with 0
je errInputEl          ; if(=) go to errInputE1

mov minus,0            ; minus = 0
xor bx,bx              ; bx = 0
mov bl,Len             ; bl = Len
mov si,offset Len      ; si = begin of Len
add si,bx              ; si += bx
mov bl,1               ; bl = 1


xor cx,cx              ; cx = 0
mov cl,Len             ; cl = Len
inputElLoop:
std                    ; setup flag of direction
lodsb                  ; ax = si
call checkSym
cmp ah,1               ; compare ah with 1
je errInputEl          ; if(=) go to errInputE1
cmp ah,2               ; compare ah with 2
je nextSym             ; if(=) go to nextSym
sub al,'0'             ; al = ASCII(my number) - ASCII(0)
mul bl                 ; ax *= bl
test ah,ah             ; compare ax with 0
jnz errInputEl         ; if(!=) go to errInputE1
add mas1[di],al
add mas2[di],al
add mas3[di],al
add mas4[di],al         ; mas[di] = al
jo errInputEl          ; if owerflow go to errInputE1
js errInputEl          ; 

mov al,bl              ; al = bl
mov bl,10              ; bl = 10
mul bl                 ; ax *= bl
test ah,ah             ; compare ah with 0
jz ElNextCheck         ; if(=) go to ELNextCheck
cmp ah,3               ; compare ah with 3
jne errInputEl         ; if(!=) go to errInputE1
ElNextCheck:
mov bl,al              ; bl = al
jmp nextSym            ; go to nextSym
errInputEl:
call ErrorInput
jmp inputElMain        ; go to inputElmain
nextSym:
loop inputElLoop       ; go to inputElLoop, cx--
cmp minus,0            ; compare minus with 0
je exitInputEl         ; if(=) go to exitInputE1
neg mas1[di]
neg mas2[di] 
neg mas3[di] 
neg mas4[di]             ; mas[di] *= -1
exitInputEl:
pop cx                 ; return cx from stack
ret
endp

checkSym proc
cmp al,'-'             ; compare al with -1
je minusSym            ; go to minusSym
cmp al,'9'             ; compare al with 9
ja errCheckSym         ; if(>) go to errCheckSym
cmp al,'0'             ; compare al with 0
jb errCheckSym         ; if(<) go to errCheckSym
jmp exitCheckGood      ; go to exitCheckGood
minusSym:
cmp si,offset Len      ; compare si with offset of Len
je exitWithMinus       ; if(=) go to exitWithMinus
errCheckSym:
mov ah,1               ; ah = 1
jmp exitCheckSym       ; go to exitCheckSum
exitWithMinus:
mov ah,2                ; ah = 2
mov minus,1             ; minus = 1
cmp Len,1               ; compare Len with 1
je errCheckSym          ; if(=) go to errCheckSym
jmp exitCheckSym        ; go to exitCheckSym
exitCheckGood:
xor ah,ah               ; ah = 0
exitCheckSym:
ret
endp

ErrorInput proc
mov dx,offset ErrInpMsg     ; dx = ErrInpMsg
mov ah,9                    ; ah =  9, output string
int 21h
ret
endp

InputMsg proc                
mov ah,9
mov dx,offset InpMsg
int 21h
ret
endp  

do proc 
mas1_inversia:
mov cx,3
mov si,0 
mov di,4
inversia: 
mov al,mas1[si]
mov dl,mas1[di]
mov mas1[di],al
mov mas1[si],dl
inc si
dec di  
loop inversia

mas2_vozvedenie_v_kvadrat:
mov cx,5
mov si,0
vozvedenie_v_kvadrat:
mov al,mas2[si]
mul al
mov mas2[si],al
inc si
loop vozvedenie_v_kvadrat 

mas3_modul:
mov cx,5
mov si, 0 
modul: 
xor al,al
mov al,mas3[si] 
test al,al
js menshe
men:
inc si  
loop modul 
jmp mas4_obratnoe_znachenie:
menshe: 
mov dl,al 
shl dl,1
sub al,dl
mov mas3[si],al 
jmp men   

mas4_obratnoe_znachenie: 
mov cx,5
mov si, 0 
obratnoe_znachenie: 
xor al,al
mov al,mas4[si] 
mov dl,al 
shl dl,1
sub al,dl
mov mas4[si],al  
inc si 
loop obratnoe_znachenie 
endp
;------------------------------- output mas1
output proc  
output_1mas: 
xor ax,ax
xor dx,dx
output1: 
mov ah,09h
mov dx,offset enter
int 21h    
mov ah,09h
mov dx,offset output_massiv2
int 21h
mov di,5
mov si,0
output_mas1:
xor ax,ax
xor bx,bx
xor dx,dx 
mov bl,mas1[si]
cmp di,0
je output_2mas
test bl,bl
js menshe11
jns cc1
xx1: 
inc si
dec di
mov ah,02h
mov dx,' '
int 21h
loop output_mas1 
cc1:
mov ax,bx 
mov dx,10 
xor cx,cx
a1_1: xor bx,bx
a2_1: cmp ax,dx
jb a3_1
inc bx
sub ax,dx
jmp a2_1
a3_1: add ax,'0'
cmp ax,':'
jb a5_1
add ax,'A'-':'
a5_1: push ax
inc cx
xchg ax,bx
or ax,ax
jne a1_1
a4_1:
pop dx
mov ah,02h
int 21h
loop a4_1 
jmp xx1
 
menshe11:
mov ah,09h
mov dx,offset minus1
int 21h            
xor ax,ax
xor dx,dx
mov al,mas1[si] 
mov dl,al                                                                  
shl dl,1
sub al,dl
mov bl,al
jmp cc1 
;------------------------------- output mas1      
output_2mas: 
xor ax,ax
xor dx,dx
output2: 
mov ah,09h
mov dx,offset enter
int 21h    
mov ah,09h
mov dx,offset output_massiv2
int 21h
mov di,5
mov si,0
output_mas2:
xor ax,ax
xor bx,bx
xor dx,dx 
mov bl,mas2[si]
cmp di,0
je output_3mas
test bl,bl
js menshe2
jns cc2
xx2: 
inc si
dec di
mov ah,02h
mov dx,' '
int 21h
loop output_mas2 
cc2:
mov ax,bx 
mov dx,10 
xor cx,cx
a1_2: xor bx,bx
a2_2: cmp ax,dx
jb a3_2
inc bx
sub ax,dx
jmp a2_2
a3_2: add ax,'0'
cmp ax,':'
jb a5_2
add ax,'A'-':'
a5_2: push ax
inc cx
xchg ax,bx
or ax,ax
jne a1_2
a4_2:
pop dx
mov ah,02h
int 21h
loop a4_2 
jmp xx2 

menshe2:
mov ah,09h
mov dx,offset minus1
int 21h            
xor ax,ax
xor dx,dx
mov al,mas2[si] 
mov dl,al                                                                  
shl dl,1
sub al,dl
mov bl,al
jmp cc2
;------------------------------- output mas3
output_3mas: 
xor ax,ax
xor dx,dx
output3: 
mov ah,09h
mov dx,offset enter
int 21h    
mov ah,09h
mov dx,offset output_massiv3
int 21h
mov di,5
mov si,0
output_mas3:
xor ax,ax
xor bx,bx
xor dx,dx 
mov bl,mas3[si]
cmp di,0
je output_4mas
test bl,bl
js menshe3
jns cc3
xx3: 
inc si
dec di
mov ah,02h
mov dx,' '
int 21h
loop output_mas3 
cc3:
mov ax,bx 
mov dx,10 
xor cx,cx
a1_3: xor bx,bx
a2_3: cmp ax,dx
jb a3_3
inc bx
sub ax,dx
jmp a2_3
a3_3: add ax,'0'
cmp ax,':'
jb a5_3
add ax,'A'-':'
a5_3: push ax
inc cx
xchg ax,bx
or ax,ax
jne a1_3
a4_3:
pop dx
mov ah,02h
int 21h
loop a4_3 
jmp xx3 

menshe3:
mov ah,09h
mov dx,offset minus1
int 21h            
xor ax,ax
xor dx,dx
mov al,mas3[si] 
mov dl,al                                                                  
shl dl,1
sub al,dl
mov bl,al
jmp cc3
;------------------------------- output mas4
output_4mas: 
xor ax,ax
xor dx,dx
output4: 
mov ah,09h
mov dx,offset enter
int 21h    
mov ah,09h
mov dx,offset output_massiv4
int 21h
mov di,5
mov si,0
output_mas4:
xor ax,ax
xor bx,bx
xor dx,dx 
mov bl,mas4[si]
cmp di,0
je exit
test bl,bl
js menshe4
jns cc4
xx4: 
inc si
dec di
mov ah,02h
mov dx,' '
int 21h
loop output_mas4 
cc4:
mov ax,bx 
mov dx,10 
xor cx,cx
a1_4: xor bx,bx
a2_4: cmp ax,dx
jb a3_4
inc bx
sub ax,dx
jmp a2_4
a3_4: add ax,'0'
cmp ax,':'
jb a5_4
add ax,'A'-':'
a5_4: push ax
inc cx
xchg ax,bx
or ax,ax
jne a1_4
a4_4:
pop dx
mov ah,02h
int 21h
loop a4_4 
jmp xx4 

menshe4:
mov ah,09h
mov dx,offset minus1
int 21h            
xor ax,ax
xor dx,dx
mov al,mas4[si] 
mov dl,al                                                                  
shl dl,1
sub al,dl
mov bl,al
jmp cc4       
endp   

exit:  
mov ax,4c00h
end	start