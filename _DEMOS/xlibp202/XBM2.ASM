; ***************************************************************************
; **                             XLibPas v2.0                              **
; **                        for Borland Pascal 7.0                         **
; **                                  by                                   **
; **                            Tristan Tarrant                            **
; ***************************************************************************
; ** Credits :                                                             **
; **   Michael Abrash    - Concepts, Algorithms                            **
; **   Themie Gouthas    - Main code and implementation                    **
; **   Matthew MacKenzie - Compiled Bitmaps, Circles, etc.                 **
; **   Tore Bastiansen   - Virtual VSync Handler                           **
; ***************************************************************************

		.MODEL TPASCAL
		.386
		LOCALS

include xlib2.inc
include xbm2.inc

		.CODE

xpbmtobm proc far srcpbm:dword,destbm:dword

	push ds
	push di
	push si

	les  di,[destbm]        ; es:di -> destination bitmap
	lds  si,[srcpbm]        ; ds:si -> source planar bitmap
	lodsb                 ; load AL with source pbm pixel width per plane
	mov  bl,al            ; save in CL
	xor  ah,ah            ; convert to word
	shl  ax,2             ; mult by 4 giving source image width
	cmp  ax,255           ; if the result > 255 then we have exceeded
	ja   @@WidthError     ; the max width of linear bm.

	stosb                 ; write do destbm

	lodsb                 ; tranfer source pbm height in pixels to
	stosb                           ;  destbm

	xor  ah,ah            ; convert to word
	mul  bl               ; AX = AX * BL ie. total no. pixels per plane
	mov  dx,di            ; save DI, the pointer to the destination bm
	mov  bl,3             ; set plane loop counter (BL)

@@PlaneLoop:
	mov  cx,ax            ; set CX to total number of pixels per plane

@@PixelLoop:
	movsb                 ; transfer pixel
	add  di,3             ; increment destination to compensate for plane
	loop @@PixelLoop

	inc  dx               ; increment original di for next pixel plane
	mov  di,dx            ; and restore di from incremented original
	dec  bl               ; decrement plane counter
	jns  @@PlaneLoop      ; loop if more planes left
	xor  ax,ax
	jmp  short @@Done
@@WidthError:
	mov  ax,1

@@Done:
	pop  si
	pop  di
	pop  ds
	ret
xpbmtobm endp


xbmtopbm proc far srcbm:dword,destpbm:dword
	push ds
	push di
	push si

	les  di,[destpbm]        ; es:di -> destination planar bitmap
	lds  si,[srcbm]          ; ds:si -> source bitmap
	lodsb                    ; load AX with source bitmap width
	test al,03h              ; Check that width is a multiple of 4
	jnz  @@WidthIncompatible
	shr  al,2                ; divide by 4 giving width of plane
	stosb                    ; store destination planar bitmap width
	mov  bl,al               ;  and copy to bl
	lodsb
	stosb                    ; Transfer source bitmap height to dest pbm
	xor  ah,ah               ; Conver height to word
	mul  bl                  ; calculate the total no. of pixels / plane
	mov  dx,si               ; save source offset
	mov  bl,3

@@PlaneLoop:
	mov  cx,ax               ; set CX to total number of pixels per plane

@@PixelLoop:
	movsb                    ; transfer pixel
	add  si,3                ; increment src offset to compensate for plane
	loop @@PixelLoop

	inc  dx                  ; increment original si for next pixel plane
	mov  si,dx               ; and restore si from incremented original
	dec  bl                  ; decrement plane counter
	jns  @@PlaneLoop         ; loop if more planes left
	xor  ax,ax
	jmp  short @@Done
@@WidthIncompatible:
	mov  ax,1

@@Done:
	pop  si
	pop  di
	pop  ds
	ret
xbmtopbm endp

xcompilebitmap proc far logicalwidth:word,bitmap:dword,output:dword
LOCAL bwidth,scanx,scany,outputx,outputy,column,setcolumn,inputsize:word
	push si
	push di
	push ds

	mov word ptr [scanx],0
	mov word ptr [scany],0
	mov word ptr [outputx],0
	mov word ptr [outputy],0
	mov word ptr [column],0
	mov word ptr [setcolumn],0

	lds si,[bitmap]     ; 32-bit pointer to source bitmap

	les di,[output]     ; 32-bit pointer to destination stream

	lodsb               ; load width byte
	xor ah, ah          ; convert to word
	mov [bwidth], ax    ; save for future reference
	mov bl, al          ; copy width byte to bl
	lodsb               ; load height byte -- already a word since ah=0
	mul bl              ; mult height word by width byte
	mov [inputsize], ax;  to get pixel total

@@MainLoop:
	mov bx, [scanx]     ; position in original bitmap
	add bx, [scany]

	mov al, [si+bx]     ; get pixel
	or  al, al          ; skip empty pixels
	jnz @@NoAdvance
	jmp @@Advance
@@NoAdvance:

	mov dx, [setcolumn]
	cmp dx, [column]
	je @@SameColumn
@@ColumnLoop:
	Emitw ROLAL        ; emit code to move to new column
	Emitw ADCSIIMMED
	Emitb 0

	inc dx
	cmp dx, [column]
	jl @@ColumnLoop

	Emitb OUTAL        ; emit code to set VGA mask for new column
	mov [setcolumn], dx
@@SameColumn:
	mov dx, [outputy]   ; calculate output position
	add dx, [outputx]
	sub dx, 128

	add word ptr [scanx], 4
	mov cx, [scanx]     ; within four pixels of right edge?
	cmp cx, [bwidth]
	jge @@OnePixel

	inc word ptr [outputx]
	mov ah, [si+bx+4]   ; get second pixel
	or ah, ah
	jnz @@TwoPixels
@@OnePixel:
	cmp dx, 127         ; can we use shorter form?
	jg @@OnePixLarge
	cmp dx, -128
	jl @@OnePixLarge
	Emitw SHORTSTORE8
	Emitb dl            ; 8-bit position in output
	jmp @@EmitOnePixel
@@OnePixLarge:
	Emitw STORE8
	Emitw dx            ; position in output
@@EmitOnePixel:
	Emitb al
	jmp short @@Advance
@@TwoPixels:
	cmp dx, 127
	jg @@TwoPixLarge
	cmp dx, -128
	jl @@TwoPixLarge
	Emitw SHORTSTORE16
	Emitb dl            ; 8-bit position in output
	jmp @@EmitTwoPixels
@@TwoPixLarge:
	Emitw STORE16
	Emitw dx            ; position in output
@@EmitTwoPixels:
	Emitw ax

@@Advance:
	inc word ptr [outputx]
	mov ax, [scanx]
	add ax, 4
	cmp ax, [bwidth]
	jl @@AdvanceDone
	mov dx, [outputy]
	add dx, [logicalwidth]
	mov cx, [scany]
	add cx, [bwidth]
	cmp cx, [inputsize]
	jl @@NoNewColumn
	inc word ptr [column]
	mov cx, [column]
	cmp cx, 4
	je @@Exit           ; Column 4: there is no column 4.
	xor cx, cx          ; scany and outputy are 0 again for
	mov dx, cx          ; the new column
@@NoNewColumn:
	mov [outputy], dx
	mov [scany], cx
	mov word ptr [outputx], 0
	mov ax,[column]
@@AdvanceDone:
	mov [scanx], ax
	jmp @@MainLoop

@@Exit:
	Emitb RETURN
	mov ax,di
	sub ax,word ptr [output] ; size of generated code

	pop ds
	pop di
	pop si
	ret
xcompilebitmap endp


xsizeofcbitmap proc far logicalwidth:word,bitmap:dword
LOCAL bwidth,scanx,scany,outputx,outputy,column,setcolumn,inputsize:word
	push si
	push di
	push ds

	mov word ptr [scanx], 0
	mov word ptr [scany], 0
	mov word ptr [outputx], 0
	mov word ptr [outputy], 0
	mov word ptr [column], 0
	mov word ptr [setcolumn], 0

	lds si,[bitmap]     ; 32-bit pointer to source bitmap

	mov di, 1           ; initial size is just the size of the far RET

	lodsb               ; load width byte
	xor ah, ah          ; convert to word
	mov [bwidth], ax    ; save for future reference
	mov bl, al          ; copy width byte to bl
	lodsb               ; load height byte -- already a word since ah=0
	mul bl              ; mult height word by width byte
	mov [inputsize], ax;  to get pixel total

@@MainLoop:
	mov bx, [scanx]     ; position in original bitmap
	add bx, [scany]

	mov al, [si+bx]     ; get pixel
	or  al, al          ; skip empty pixels
	jnz @@NoAdvance
	jmp @@Advance
@@NoAdvance:

	mov dx, [setcolumn]
	cmp dx, [column]
	je @@SameColumn
@@ColumnLoop:
	add di, 5           ; size of code to move to new column
	inc dx
	cmp dx,[column]
	jl @@ColumnLoop

	inc di              ; size of code to set VGA mask
	mov [setcolumn], dx
@@SameColumn:
	mov dx, [outputy]   ; calculate output position
	add dx, [outputx]
	sub dx, 128

	add word ptr [scanx], 4
	mov cx, [scanx]     ; within four pixels of right edge?
	cmp cx, [bwidth]
	jge @@OnePixel

	inc word ptr [outputx]
	mov ah,[si+bx+4]    ; get second pixel
	or ah, ah
	jnz @@TwoPixels
@@OnePixel:
	cmp dx, 127         ; can we use shorter form?
	jg @@OnePixLarge
	cmp dx, -128
	jl @@OnePixLarge
	add di, 4           ; size of 8-bit position in output plus one pixel
	jmp @@EmitOnePixel
@@OnePixLarge:
	add di, 5           ; size of position in output plus one pixels
@@EmitOnePixel:
	jmp short @@Advance
@@TwoPixels:
	cmp dx, 127
	jg @@TwoPixLarge
	cmp dx, -128
	jl @@TwoPixLarge
	add di, 5           ; size of 8-bit position in output plus two pixels
	jmp @@EmitTwoPixels
@@TwoPixLarge:
	add di, 6           ; size of 16-bit position in output plus two pixels
@@EmitTwoPixels:

@@Advance:
	inc word ptr [outputx]
	mov ax, [scanx]
	add ax,4
	cmp ax, [bwidth]
	jl @@AdvanceDone
	mov dx, [outputy]
	add dx, [logicalwidth]
	mov cx, [scany]
	add cx, [bwidth]
	cmp cx, [inputsize]
	jl @@NoNewColumn
	inc word ptr [column]
	mov cx, [column]
	cmp cx, 4
	je @@Exit           ; Column 4: there is no column 4.
	xor cx,cx           ; scany and outputy are 0 again for
	mov dx,cx           ; the new column
@@NoNewColumn:
	mov [outputy], dx
	mov [scany], cx
	mov word ptr [outputx], 0
	mov ax,[column]
@@AdvanceDone:
	mov [scanx], ax
	jmp @@MainLoop

@@Exit:
	mov ax, di          ; size of generated code

	pop ds
	pop di
	pop si
	ret
xsizeofcbitmap endp

xputcbitmap proc far XPos:word,YPos:word,PageOffset:word,Sprite:dword

	push ds
	mov cx, [SelectorInc]
	mov ax, [ScrnLogicalByteWidth] ; global Xlib variable
	mul word ptr [YPos] ; height in bytes
	mov si, [XPos]
	mov bx, si
	sar si, 2           ; width in bytes
	add si, ax
	add si, [PageOffset]; (YPos * screen width) +
	add si, 128         ;   (Xpos / 4) + page base + 128 ==> starting pos

	and bx, 3
	mov ah, ColumnMask[bx]

	mov dx, SCINDEX
	mov al, MAPMASK
	out dx, ax
	inc dx              ; ready to send out other masks as bytes
	mov al, ah
	mov bx, SCREENSEG
	mov ds, bx          ; We do this so the compiled shape won't need
											; segment overrides.
	call dword ptr [Sprite] ; the business end of the routine
	pop ds

	ret
xputcbitmap endp


xcompilepbm proc far logicalwidth:word,bitmap:dword,output:dword
LOCAL bwidth,scanx,scany,outputx,outputy,column,setcolumn,inputsize:word
	push si
	push di
	push ds

	mov word ptr [scanx],0
	mov word ptr [scany],0
	mov word ptr [outputx],0
	mov word ptr [outputy],0
	mov word ptr [column],0
	mov word ptr [setcolumn],0

	lds si,[bitmap]     ; 32-bit pointer to source bitmap

	les di,[output]     ; 32-bit pointer to destination stream

	lodsb               ; load width byte
	xor ah, ah          ; convert to word
	mov [bwidth], ax    ; save for future reference
	mov bl, al          ; copy width byte to bl
	lodsb               ; load height byte -- already a word since ah=0
	mul bl              ; mult height word by width byte
	mov [inputsize], ax;  to get pixel total

@@MainLoop:
	mov bx, [scanx]     ; position in original bitmap
	add bx, [scany]

	mov al, [si+bx]     ; get pixel
	or  al, al          ; skip empty pixels
	jnz @@NoAdvance
	jmp @@Advance
@@NoAdvance:

	mov dx, [setcolumn]
	cmp dx, [column]
	je @@SameColumn
@@ColumnLoop:
	Emitw ROLAL        ; emit code to move to new column
	Emitw ADCSIIMMED
	Emitb 0

	inc dx
	cmp dx, [column]
	jl @@ColumnLoop

	Emitb OUTAL        ; emit code to set VGA mask for new column
	mov [setcolumn], dx
@@SameColumn:
	mov dx, [outputy]   ; calculate output position
	add dx, [outputx]
	sub dx, 128

	inc word ptr [scanx]
	mov cx, [scanx]     ; within four pixels of right edge?
	cmp cx, [bwidth]
	jge @@OnePixel

	inc word ptr [outputx]
	mov ah, [si+bx+1]   ; get second pixel
	or ah, ah
	jnz @@TwoPixels
@@OnePixel:
	cmp dx, 127         ; can we use shorter form?
	jg @@OnePixLarge
	cmp dx, -128
	jl @@OnePixLarge
	Emitw SHORTSTORE8
	Emitb dl            ; 8-bit position in output
	jmp @@EmitOnePixel
@@OnePixLarge:
	Emitw STORE8
	Emitw dx            ; position in output
@@EmitOnePixel:
	Emitb al
	jmp short @@Advance
@@TwoPixels:
	cmp dx, 127
	jg @@TwoPixLarge
	cmp dx, -128
	jl @@TwoPixLarge
	Emitw SHORTSTORE16
	Emitb dl            ; 8-bit position in output
	jmp @@EmitTwoPixels
@@TwoPixLarge:
	Emitw STORE16
	Emitw dx            ; position in output
@@EmitTwoPixels:
	Emitw ax

@@Advance:
	inc word ptr [outputx]
	mov ax, [scanx]
	inc ax
	cmp ax, [bwidth]
	jl @@AdvanceDone
	mov dx, [outputy]
	add dx, [logicalwidth]
	mov cx, [scany]
	add cx, [bwidth]
	cmp cx, [inputsize]
	jl @@NoNewColumn
	inc word ptr [column]
	mov cx, [column]
	cmp cx, 4
	je @@Exit           ; Column 4: there is no column 4.
	xor cx, cx          ; scany and outputy are 0 again for
	mov dx, cx          ; the new column
	add si, [inputsize]
@@NoNewColumn:
	mov [outputy], dx
	mov [scany], cx
	xor ax, ax
	mov word ptr [outputx], 0
@@AdvanceDone:
	mov [scanx], ax
	jmp @@MainLoop

@@Exit:
	Emitb RETURN
	mov ax,di
	sub ax,word ptr [output] ; size of generated code

	pop ds
	pop di
	pop si
	ret
xcompilepbm endp


xsizeofcpbm proc far logicalwidth:word,bitmap:dword
LOCAL bwidth,scanx,scany,outputx,outputy,column,setcolumn,inputsize:word
	push si
	push di
	push ds

	mov word ptr [scanx], 0
	mov word ptr [scany], 0
	mov word ptr [outputx], 0
	mov word ptr [outputy], 0
	mov word ptr [column], 0
	mov word ptr [setcolumn], 0

	lds si,[bitmap]     ; 32-bit pointer to source bitmap

	mov di, 1           ; initial size is just the size of the far RET

	lodsb               ; load width byte
	xor ah, ah          ; convert to word
	mov [bwidth], ax    ; save for future reference
	mov bl, al          ; copy width byte to bl
	lodsb               ; load height byte -- already a word since ah=0
	mul bl              ; mult height word by width byte
	mov [inputsize], ax;  to get pixel total

@@MainLoop:
	mov bx, [scanx]     ; position in original bitmap
	add bx, [scany]

	mov al, [si+bx]     ; get pixel
	or  al, al          ; skip empty pixels
	jnz @@NoAdvance
	jmp @@Advance
@@NoAdvance:

	mov dx, [setcolumn]
	cmp dx, [column]
	je @@SameColumn
@@ColumnLoop:
	add di, 5           ; size of code to move to new column
	inc dx
	cmp dx,[column]
	jl @@ColumnLoop

	inc di              ; size of code to set VGA mask
	mov [setcolumn], dx
@@SameColumn:
	mov dx, [outputy]   ; calculate output position
	add dx, [outputx]
	sub dx, 128

	inc word ptr [scanx]
	mov cx, [scanx]     ; within four pixels of right edge?
	cmp cx, [bwidth]
	jge @@OnePixel

	inc word ptr [outputx]
	mov ah,[si+bx+1]    ; get second pixel
	or ah, ah
	jnz @@TwoPixels
@@OnePixel:
	cmp dx, 127         ; can we use shorter form?
	jg @@OnePixLarge
	cmp dx, -128
	jl @@OnePixLarge
	add di, 4           ; size of 8-bit position in output plus one pixel
	jmp @@EmitOnePixel
@@OnePixLarge:
	add di, 5           ; size of position in output plus one pixels
@@EmitOnePixel:
	jmp short @@Advance
@@TwoPixels:
	cmp dx, 127
	jg @@TwoPixLarge
	cmp dx, -128
	jl @@TwoPixLarge
	add di, 5           ; size of 8-bit position in output plus two pixels
	jmp @@EmitTwoPixels
@@TwoPixLarge:
	add di, 6           ; size of 16-bit position in output plus two pixels
@@EmitTwoPixels:

@@Advance:
	inc word ptr [outputx]
	mov ax, [scanx]
	inc ax
	cmp ax, [bwidth]
	jl @@AdvanceDone
	mov dx, [outputy]
	add dx, [logicalwidth]
	mov cx, [scany]
	add cx, [bwidth]
	cmp cx, [inputsize]
	jl @@NoNewColumn
	inc word ptr [column]
	mov cx, [column]
	cmp cx, 4
	je @@Exit           ; Column 4: there is no column 4.
	xor cx,cx           ; scany and outputy are 0 again for
	mov dx,cx           ; the new column
	add si, [inputsize]
@@NoNewColumn:
	mov [outputy], dx
	mov [scany], cx
	xor ax, ax
	mov word ptr [outputx], ax
@@AdvanceDone:
	mov [scanx], ax
	jmp @@MainLoop

@@Exit:
	mov ax, di          ; size of generated code

	pop ds
	pop di
	pop si
	ret
xsizeofcpbm endp

xflipmaskedpbm  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword,Orientation:word
LOCAL Plane:byte,BMHeight:byte,LineInc:word

	push  si
	push  di
	push  ds
	cld
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ax,[Y]                      ; Calculate dest screen row
	mov   bx,[ScrnLogicalByteWidth]  ;  by mult. dest Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	mov   di,[ScrnOffs]               ;  store result in DI
	add   di,ax
	mov   cx,[X]                      ; Load X coord into CX and make a
	mov   dx,cx                       ;  copy in DX
	shr   dx,2                        ; Find starting byte in dest row
	add   di,dx                       ;  add to DI giving screen offset of
																					;  first pixel's byte
	lds   si,[Bitmap]                 ; DS:SI -> Bitmap data
	lodsw                             ; Al = B.M. width (bytes) AH = B.M.
																					;  height
	cmp   Orientation,0
	jz    UnFlippedMasked

	mov   [BMHeight],ah               ; Save source bitmap dimensions
				xor   ah,ah                       ; LineInc = bytes to the begin.
	add   bx,ax                       ;  of bitmaps next row on screen
	mov   [LineInc],bx
	mov   bh,al                       ; Use bh as column loop count
				and   cx,0003h                    ; mask X coord giving plane of 1st
						; bitmap pixel(zero CH coincidentally)
	mov   ah,11h                      ; Init. mask for VGA plane selection
	shl   ah,cl                       ; Shift for starting pixel plane
	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
@@PlaneLoop:
	push  di                          ; Save bitmap's start dest. offset
	mov   bl,[BMHeight]               ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
@@ColLoop:
	lodsb                             ; Get next source bitmap byte
	or    al,al                       ; If not zero then write to dest.
	jz    @@NoPixel                   ; otherwise skip to next byte
	mov   es:[di],al
@@NoPixel:
	dec   di
	loop  @@ColLoop                   ; loop if more columns left
	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   di                          ; Restore bitmaps start dest byte
	ror   ah,1                        ; Shift mask for next plane
	sbb   di,0                        ; If wrapped increment dest address
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xflipmaskedpbm  endp


xputmaskedpbm  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL Plane:byte,BMHeight:byte,LineInc:word
	push  si
	push  di
	push  ds
	cld
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ax,Y                      ; Calculate dest screen row
	mov   bx,ScrnLogicalByteWidth  ;  by mult. dest Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	mov   di,[ScrnOffs]               ;  store result in DI
	add   di,ax
	mov   cx,[X]                      ; Load X coord into CX and make a
	mov   dx,cx                       ;  copy in DX
	shr   dx,2                        ; Find starting byte in dest row
	add   di,dx                       ;  add to DI giving screen offset of
																					;  first pixel's byte
	lds   si,[Bitmap]                 ; DS:SI -> Bitmap data
	lodsw                             ; Al = B.M. width (bytes) AH = B.M.
																					;  height
UnFlippedMasked:
	mov   [BMHeight],ah               ; Save source bitmap dimensions
	xor   ah,ah                       ; LineInc = bytes to the begin.
	sub   bx,ax                       ;  of bitmaps next row on screen
	mov   [LineInc],bx
	mov   bh,al                       ; Use bh as column loop count
	and   cx,0003h                    ; mask X coord giving plane of 1st
																		; bitmap pixel(zero CH coincidentally)
	mov   ah,11h                      ; Init. mask for VGA plane selection
	shl   ah,cl                       ; Shift for starting pixel plane
	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
@@PlaneLoop:
	push  di                          ; Save bitmap's start dest. offset
	mov   bl,[BMHeight]               ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
@@ColLoop:
	lodsb                             ; Get next source bitmap byte
	or    al,al                       ; If not zero then write to dest.
	jz    @@NoPixel                   ; otherwise skip to next byte
	mov   es:[di],al
@@NoPixel:
	inc   di
	loop  @@ColLoop                   ; loop if more columns left
	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1                        ; Shift mask for next plane
	adc   di,0                        ; If wrapped increment dest address
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedpbm  endp

xputpbm  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL Plane:byte,BMHeight:byte,LineInc:word
	push  si
	push  di
	push  ds
	cld
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ax,[Y]                      ; Calculate dest screen row
	mov   bx,[ScrnLogicalByteWidth]  ;  by mult. dest Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	mov   di,[ScrnOffs]               ;  store result in DI
	add   di,ax
	mov   cx,[X]                      ; Load X coord into CX and make a
	mov   dx,cx                       ;  copy in DX
	shr   dx,2                        ; Find starting byte in dest row
	add   di,dx                       ;  add to DI giving screen offset of
																					;  first pixel's byte
	lds   si,[Bitmap]                 ; DS:SI -> Bitmap data
	lodsw                             ; Al = B.M. width (bytes) AH = B.M.
																					;  height
UnFlipped:
	mov   [BMHeight],ah               ; Save source bitmap dimensions
	xor   ah,ah                       ; LineInc = bytes to the begin.
	sub   bx,ax                       ;  of bitmaps next row on screen
	mov   [LineInc],bx
	mov   bh,al
																		; Self Modifying, Shame, shame shame..
	and   cx,0003h                    ; mask X coord giving plane of 1st
																		; bitmap pixel(zero CH coincidentally)
	mov   ah,11h                      ; Init. mask for VGA plane selection
	shl   ah,cl                       ; Shift for starting pixel plane
	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
@@PlaneLoop:
	push  di
	mov   bl,[BMHeight]
	mov   al,ah
	out   dx,al
@@RowLoop:
	mov   cl,bh
	shr   cl,1
	rep   movsw                       ; Copy a complete row for curr plane
	adc   cl,0
	rep   movsb
	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1                        ; Shift mask for next plane
	adc   di,0                        ; If wrapped increment dest address
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputpbm  endp

xflippbm  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword,Orientation:word
LOCAL Plane:byte,BMHeight:byte,LineInc:word
	push  si
	push  di
	push  ds
	cld
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ax,[Y]                      ; Calculate dest screen row
	mov   bx,[ScrnLogicalByteWidth]   ;  by mult. dest Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	mov   di,[ScrnOffs]               ;  store result in DI
	add   di,ax
	mov   cx,[X]                      ; Load X coord into CX and make a
	mov   dx,cx                       ;  copy in DX
	shr   dx,2                        ; Find starting byte in dest row
	add   di,dx                       ;  add to DI giving screen offset of
																					;  first pixel's byte
	lds   si,[Bitmap]                 ; DS:SI -> Bitmap data
	lodsw                             ; Al = B.M. width (bytes) AH = B.M.
																					;  height
	cmp   Orientation,0
	jz    UnFlipped

	mov   [BMHeight],ah               ; Save source bitmap dimensions
				xor   ah,ah                       ; LineInc = bytes to the begin.
	add   bx,ax                       ;  of bitmaps next row on screen
	mov   [LineInc],bx
	mov   bh,al                       ; Use bh as column loop count
				and   cx,0003h              ; mask X coord giving plane of 1st
																		; bitmap pixel(zero CH coincidentally)
	mov   ah,11h                      ; Init. mask for VGA plane selection
	shl   ah,cl                       ; Shift for starting pixel plane
	mov   dx,SCINDEX                  ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
@@PlaneLoop:
	push  di                          ; Save bitmap's start dest. offset
	mov   bl,[BMHeight]               ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
@@ColLoop:
	lodsb
	mov   es:[di],al
	dec   di
	sub   di,2
	loop  @@ColLoop                   ; loop if more columns left
@@DoneCol:
	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   di                          ; Restore bitmaps start dest byte
	ror   ah,1                        ; Shift mask for next plane
	sbb   di,0                        ; If wrapped increment dest address
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

xflippbm  endp

xgetpbm  proc far X:word,Y:word,SrcWidth:byte,SrcHeight:byte,ScrnOffs:word,Bitmap:dword
LOCAL Plane:byte,LineInc:word
	push  si
	push  di
	push  ds
	cld

	mov   ax,[Y]                      ; Calculate screen row
	mov   bx,[ScrnLogicalByteWidth]   ;  by mult. Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	mov   si,[ScrnOffs]               ;  store result in SI
	add   si,ax
	mov   cx,[X]                      ; Load X coord into CX and make a
	mov   dx,cx                       ;  copy in DX
	shr   dx,2                        ; Find starting byte in screen row
	add   si,dx                       ;  add to SI giving screen offset of
																		;  first pixel's byte
	mov   ax,SCREENSEG
	mov   ds,ax
	les   di,[Bitmap]                 ; ES:DI -> Bitmap data
	mov   al,[SrcWidth]
	mov   ah,[SrcHeight]
	stosw                             ; Al = B.M. width (bytes) AH = B.M.
																		;  height
	xor   ah,ah                                             ; LineInc = bytes to the begin.
	sub   bx,ax                       ;  of bitmaps next row on screen
	mov   [LineInc],bx
	mov   bh,al
																		; Self Modifying, Shame, shame shame..
	and   cx,0003h                    ; mask X coord giving plane of 1st
																		; bitmap pixel(zero CH coincidentally)
	mov   ah,11h                      ; Init. mask for VGA plane selection
	shl   ah,cl                       ; Shift for starting pixel plane
	mov   dx,GCINDEX                  ; Prepare VGA for cpu to video reads
	mov   al,READMAP
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter (BH) to 4
	mov   al,cl
@@PlaneLoop:
	push  si
	mov   bl,[SrcHeight]
	out   dx,al
@@RowLoop:
	mov   cl,bh
	shr   cl,1
	rep   movsw                       ; Copy a complete row for curr plane
	adc   cl,0
	rep   movsb
	add   si,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   si                          ; Restore bitmaps start dest byte

	inc   al                          ; Select next plane to read from
	and   al,3                        ;

	rol   ah,1                        ; Shift mask for next plane
	adc   si,0                        ; If wrapped increment dest address
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xgetpbm  endp

xputmaskedpbmclipx  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   Plane:byte,CType,LeftSkip,DataInc,AWidth,Height,TopRow,LineInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]                 ; Point ES:SI to start of bitmap

	xor   ax,ax                       ; Clear AX
	mov   [CType],ax                  ; Clear Clip type descision var
	mov   al,byte ptr es:[si]         ; AX=width (byte coverted to word)


	mov   di,[X]                      ; DI = X coordinate of dest
	mov   cx,di                       ; copy to CX
	sar   di,2                        ; convert to offset in row
	mov   dx,[LeftClip]               ; Is X Coord to the right of
	sub   dx,di                       ; LeftClip ?
	jle   @@NotLeftClip               ; Yes! => no left clipping
	cmp   dx,ax                       ; Is dist of X Coord from
	jnl   @@NotVisible                ; ClipLeft > Width ? yes => the
						; bitmap is not visible
	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   ax,dx
	mov   [CType],1
	jmp   short @@HorizClipDone

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di
	pop   si
	ret

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,ax
	jge   @@HorizClipDone
	inc   dx
	sub   ax,dx
	mov   [DataInc],ax
	mov   ax,dx
	mov   [CType],-1

@@HorizClipDone:

	xor   bh,bh
	mov   bl,byte ptr es:[si+1]

	mov   [AWidth],ax
	mov   [Height],bx


	add   si,2
	add   si,[LeftSkip]
	mov   bx,[ScrnLogicalByteWidth]
	mov   dx,bx
	sub   dx,ax
	mov   [LineInc],dx

	mov   ax,[Y]
	mul   bx
	add   di,ax
	add   di,[ScrnOffs]

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	and   cx,3
	mov   ah,11h
	shl   ah,cl

	mov   dx,SCINDEX
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4
	mov   bh,byte ptr [AWidth]
@@PlaneLoop:
	push  di
	mov   bl,byte ptr [Height]
	mov   al,ah
	out   dx,al
@@RowLoop:
	mov   cl,bh
	jcxz  @@NoWidth
@@ColLoop:
	lodsb
	or    al,al
	jz    @@NoPixel
	mov   es:[di],al
@@NoPixel:
	inc   di
	loop @@ColLoop
@@NoWidth:
	add   si,[DataInc]
	add   di,[LineInc]
	dec   bl
	jnz   @@RowLoop
	pop   di
	rol   ah,1

	jnb   @@Nocarry                   ; Jump if not plane transition
	mov   bl,ah                       ; Save Plane Mask
	mov   ax,[CType]                  ; set AX to clip type inc variable
	add   bh,al                       ; Update advancing variables
	sub   [DataInc],ax                ;
	sub   [LineInc],ax                ;
	cmp   al,0                        ; What type of clip do we have
	mov   ah,bl                       ;   restore Plane mask
	jg    @@RightAdvance              ; jump on a right clip!
	inc   di                          ; otherwise increment DI
	jmp   @@Nocarry
@@RightAdvance:
	dec si
@@Nocarry:
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedpbmclipx  endp

xputmaskedpbmclipy  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   AWidth,Height,TopRow,LineInc,PlaneInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]

	xor   bh,bh
	mov   bl,byte ptr es:[si+1]       ; BX = height

	xor   ah,ah
	mov   al,byte ptr es:[si]         ; AX = width

	mov   cx,ax                       ; Save AX
	mul   bx                          ; AX = AX*BX = bytes/plane
	mov   [PlaneInc],ax               ;  save as PlaneInc
	mov   ax,cx                       ; Restore AX

	mov   di,[X]
	mov   cx,di
	shr   di,2

	;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,bx
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   bx,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED P.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,bx
	jg    @@VertClipDone
	inc   dx
	mov   bx,dx

@@VertClipDone:

	mov   [AWidth],ax
	mov   [Height],bx                 ; Calculate relative offset in data
	mul   [TopRow]                    ;  of first visible scanline
	add   ax,2                        ; Skip dimension bytes in source
	add   si,ax                       ; Skip top rows that arent visible


	mov   ax,[Y]                      ; Calculate screen row
	mov   bx,[ScrnLogicalByteWidth]  ;  by mult. Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	add   di,ax
	add   di,[ScrnOffs]
	sub   bx,[AWidth]                  ; calculate difference from end of
	mov   [LineInc],bx                ; b.m. in curr line to beginning of
						; b.m. on next scan line

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	mov   ah,11h                      ; Set up initial plane mask
	and   cx,3
	shl   ah,cl

	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   bh,4                        ; Set plane counter to 4
@@PlaneLoop:
	push  di        ; Save bitmap's start dest. offset
	push  si                          ; Save Bitmaps data offset
	mov   bl,byte ptr [Height]        ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,byte ptr [AWidth]         ; Reset Column counter cl
@@ColLoop:
	lodsb                             ; Get next source bitmap byte
	or    al,al                       ; If not zero then write to dest.
	jz    @@NoPixel                   ; otherwise skip to next byte
	mov   es:[di],al
@@NoPixel:
	inc   di
	loop  @@ColLoop                   ; loop if more columns left
	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   si                          ; Restore SI and set to offset of
	add   si,[PlaneInc]               ; first vis pixel in next plane data
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1                        ; Shift mask for next plane
	adc   di,0                        ; if carry increment screen offset
	dec   bh                          ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedpbmclipy   endp

xputmaskedpbmclipxy  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   Plane:byte,CType,LeftSkip,DataInc,AWidth,Height,TopRow,LineInc,PlaneInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]

	xor   ax,ax
	mov   [CType],ax
	mov   al,byte ptr es:[si]         ; AX = width
	xor   bh,bh
	mov   bl,byte ptr es:[si+1]       ; BX = height

	mov   cx,ax                       ; Save AX
	mul   bx                          ; AX = AX*BX = bytes/plane
	mov   [PlaneInc],ax               ;  save as PlaneInc
	mov   ax,cx                       ; Restore AX


	mov   di,[X]                      ; DI = X coordinate of dest.
	mov   cx,di                       ; save in CX
	sar   di,2                        ; convert to address byte


		;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,bx
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   bx,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED P.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,bx
	jg    @@VertClipDone
	inc   dx
	mov   bx,dx

@@VertClipDone:

	;;;;; CLIP PROCESSING FOR LEFT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

	mov   dx,[LeftClip]
	sub   dx,di
	jle   @@NotLeftClip
	cmp   dx,ax
	jnl   @@NotVisible

	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   ax,dx
	mov   [CType],1
	jmp   short @@HorizClipDone

	;;;;; CLIP PROCESSING FOR RIGHT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,ax
				jge   @@HorizClipDone       ; was jg
	inc   dx
	sub   ax,dx
	mov   [DataInc],ax
	mov   ax,dx


	mov   [CType],-1

@@HorizClipDone:



	mov   [AWidth],ax                  ; Save width and height of clipped
	mov   [Height],bx                 ;  image

	add   ax,[DataInc]                ; AX = original width of image
	mul   [TopRow]                    ; Calculate bytes in clipped top
	add   si,ax             ;  rows
	add   si,2                        ; Skip dimension bytes in source
	add   si,[LeftSkip]               ; Skip pixels in front of row that
						;  are clipped

	mov   bx,[ScrnLogicalByteWidth]  ; Set BX to Logical Screen Width
	mov   dx,bx                       ; BX - Width of image = No. bytes
	sub   dx,[AWidth]                  ;  to first byte of next screen
	mov   [LineInc],dx                ;  row.

	mov   ax,[Y]                      ; Calculate screen start row
	mul   bx                          ;  then adding screen offset
	add   di,ax
	add   di,[ScrnOffs]

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	and   cx,3
	mov   ah,11h                      ; Set up initial plane mask
	shl   ah,cl

	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
	mov   bh,byte ptr [AWidth]         ; set bh to width for fast looping
@@PlaneLoop:
	push  di        ; Save bitmap's start dest. offset
	push  si
	mov   bl,byte ptr [Height]        ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
	jcxz   @@NoWidth
@@ColLoop:
	lodsb                     ; Get next source bitmap byte
	or    al,al                       ; If not zero then write to dest.
	jz    @@NoPixel                   ; otherwise skip to next byte
	mov   es:[di],al
@@NoPixel:
	inc   di
	loop @@ColLoop
@@NoWidth:
	add   si,[DataInc]                ; Move to next source row
	add   di,[LineInc]                ; Move to next screen row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   si                          ; Restore SI and set to offset of
	add   si,[PlaneInc]               ; first vis pixel in next plane data
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1              ; Shift mask for next plane

	; Plane Transition (A HACK but it works!)

	jnb   @@Nocarry                   ; Jump if not plane transition
	mov   bl,ah                       ; Save Plane Mask
	mov   ax,[CType]                  ; set AX to clip type inc variable
	add   bh,al                       ; Update advancing variables
	sub   [DataInc],ax                ;
	sub   [LineInc],ax                ;
	cmp   al,0                        ; What type of clip do we have
	mov   ah,bl                       ;   restore Plane mask
	jg    @@RightAdvance              ; jump on a right clip!
	inc   di                          ; otherwise increment DI
	jmp   @@Nocarry
@@RightAdvance:
	dec   si
@@Nocarry:
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedpbmclipxy  endp

xputpbmclipx  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   Plane:byte,CType,LeftSkip,DataInc,AWidth,Height,TopRow,LineInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]

	xor   ax,ax
	mov   [CType],ax
	mov   al,byte ptr es:[si]         ; AX = width


	mov   di,[X]                      ; DI = X coordinate of dest.
	mov   cx,di                       ; save in CX
	sar   di,2                        ; convert to address byte



	;;;;; CLIP PROCESSING FOR LEFT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

	mov   dx,[LeftClip]
	sub   dx,di
	jle   @@NotLeftClip
	cmp   dx,ax
	jnl   @@NotVisible

	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   ax,dx
	mov   [CType],1
	jmp   short @@HorizClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED P.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR RIGHT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,ax
				jge   @@HorizClipDone       ; was jg
	inc   dx
	sub   ax,dx
	mov   [DataInc],ax
	mov   ax,dx
	mov   [CType],-1

@@HorizClipDone:

	xor   bh,bh
	mov   bl,byte ptr es:[si+1]       ; BX = height

	mov   [AWidth],ax                  ; Save width and height of clipped
	mov   [Height],bx                 ;  image


	add   si,2                        ; Skip dimension bytes in source
	add   si,[LeftSkip]               ; Skip pixels in front of row that
						;  are clipped


	mov   bx,[ScrnLogicalByteWidth]  ; Set BX to Logical Screen Width
	mov   dx,bx                       ; BX - Width of image = No. bytes
	sub   dx,ax                       ;  to first byte of next screen
	mov   [LineInc],dx                ;  row.

	mov   ax,[Y]                      ; Calculate screen start row
	mul   bx                          ;  then adding screen offset
	add   di,ax
	add   di,[ScrnOffs]

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	and   cx,3
	mov   ah,11h                      ; Set up initial plane mask
	shl   ah,cl

	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
	mov   bh,byte ptr [AWidth]         ; set bh to width for fast looping
@@PlaneLoop:
	push  di        ; Save bitmap's start dest. offset
	mov   bl,byte ptr [Height]        ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
	shr   cl,1
	rep   movsw                       ; Copy a complete row
	adc   cl,0
	rep   movsb
	add   si,[DataInc]                ; Move to next source row
	add   di,[LineInc]                ; Move to next screen row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1              ; Shift mask for next plane

	; Plane Transition (A HACK but it works!)

	jnb   @@Nocarry                   ; Jump if not plane transition
	mov   bl,ah                       ; Save Plane Mask
	mov   ax,[CType]                  ; set AX to clip type inc variable
	add   bh,al                       ; Update advancing variables
	sub   [DataInc],ax                ;
	sub   [LineInc],ax                ;
	cmp   al,0                        ; What type of clip do we have
	mov   ah,bl                       ;   restore Plane mask
	jg    @@RightAdvance              ; jump on a right clip!
	inc   di                          ; otherwise increment DI
	jmp   @@Nocarry
@@RightAdvance:
	dec si
@@Nocarry:
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputpbmclipx  endp

xputpbmclipy  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   AWidth,Height,TopRow,LineInc,PlaneInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]

	xor   bh,bh
	mov   bl,byte ptr es:[si+1]   ; BX = height
	;mov   [Height],bx

	xor   ah,ah
	mov   al,byte ptr es:[si]     ; AX = width
	mov   [AWidth],ax

	mov   cx,ax                       ; Save AX
	mul   bx                          ; AX = AX*BX = bytes/plane
	mov   [PlaneInc],ax               ;  save as PlaneInc
	mov   ax,cx                       ; Restore AX

	mov   di,[X]
	mov   cx,di
	and   cx,3
	shr   di,2

	;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,bx
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   bx,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED P.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,bx
	jg    @@VertClipDone
	inc   dx
	mov   bx,dx

@@VertClipDone:

	mov   [Height],bx                 ; Calculate relative offset in data
	mul   [TopRow]                    ;  of first visible scanline
	add   ax,2                        ; Skip dimension bytes in source
	add   si,ax                       ; Skip top rows that arent visible


	mov   ax,[Y]                      ; Calculate screen row
	mov   bx,[ScrnLogicalByteWidth]  ;  by mult. Y coord by Screen
	mul   bx                          ;  width then adding screen offset
	add   di,ax
	add   di,[ScrnOffs]
	sub   bx,[AWidth]                  ; calculate difference from end of
	mov   [LineInc],bx                ; b.m. in curr line to beginning of
						; b.m. on next scan line

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	mov   ah,11h                      ; Set up initial plane mask
	shl   ah,cl

	mov   dx,SCINDEX                 ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   bh,4                        ; Set plane counter to 4
@@PlaneLoop:
	push  di        ; Save bitmap's start dest. offset
	push  si                          ; Save Bitmaps data offset
	mov   bl,byte ptr [Height]        ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,byte ptr [AWidth]         ; Reset Column counter cl
	shr   cl,1
	rep   movsw                       ; Copy a complete row
	adc   cl,0
	rep   movsb

	add   di,[LineInc]                ; Move to next row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   si                          ; Restore SI and set to offset of
	add   si,[PlaneInc]               ; first vis pixel in next plane data
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1                        ; Shift mask for next plane
	adc   di,0                        ; if carry increment screen offset
	dec   bh                          ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputpbmclipy   endp


xputpbmclipxy  proc far X:word,Y:word,ScrnOffs:word,Bitmap:dword
LOCAL   Plane:byte,CType,LeftSkip,DataInc,AWidth,Height,TopRow,LineInc,PlaneInc:word
	push  si
	push  di
	push  ds
	cld

	les   si,[Bitmap]

	xor   ax,ax
	mov   [CType],ax
	mov   al,byte ptr es:[si]         ; AX = width
	xor   bh,bh
	mov   bl,byte ptr es:[si+1]       ; BX = height

	mov   cx,ax                       ; Save AX
	mul   bx                          ; AX = AX*BX = bytes/plane
	mov   [PlaneInc],ax               ;  save as PlaneInc
	mov   ax,cx                       ; Restore AX


	mov   di,[X]                      ; DI = X coordinate of dest.
	mov   cx,di                       ; save in CX
	sar   di,2                        ; convert to address byte


		;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,bx
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   bx,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED P.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,bx
	jg    @@VertClipDone
	inc   dx
	mov   bx,dx

@@VertClipDone:

	;;;;; CLIP PROCESSING FOR LEFT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

	mov   dx,[LeftClip]
	sub   dx,di
	jle   @@NotLeftClip
	cmp   dx,ax
	jnl   @@NotVisible

	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   ax,dx
	mov   [CType],1
	jmp   short @@HorizClipDone

	;;;;; CLIP PROCESSING FOR RIGHT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,ax
				jge   @@HorizClipDone       ; was jg
	inc   dx
	sub   ax,dx
	mov   [DataInc],ax
	mov   ax,dx
	mov   [CType],-1

@@HorizClipDone:



	mov   [AWidth],ax                  ; Save width and height of clipped
	mov   [Height],bx                 ;  image

	add   ax,[DataInc]                ; AX = original width of image
	mul   [TopRow]                    ; Calculate bytes in clipped top
	add   si,ax             ;  rows
	add   si,2                        ; Skip dimension bytes in source
	add   si,[LeftSkip]               ; Skip pixels in front of row that
						;  are clipped

	mov   bx,[ScrnLogicalByteWidth]  ; Set BX to Logical Screen Width
	mov   dx,bx                       ; BX - Width of image = No. bytes
	sub   dx,[AWidth]                  ;  to first byte of next screen
	mov   [LineInc],dx                ;  row.

	mov   ax,[Y]                      ; Calculate screen start row
	mul   bx                          ;  then adding screen offset
	add   di,ax
	add   di,[ScrnOffs]

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx



	and   cx,3
	mov   ah,11h                      ; Set up initial plane mask
	shl   ah,cl

	mov   dx,SCINDEX                  ; Prepare VGA for cpu to video writes
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   [Plane],4                   ; Set plane counter to 4
	mov   bh,byte ptr [AWidth]        ; set bh to width for fast looping
@@PlaneLoop:
	push  di        ; Save bitmap's start dest. offset
	push  si
	mov   bl,byte ptr [Height]        ; Reset row counter (BL)
	mov   al,ah
	out   dx,al                       ; set vga write plane
@@RowLoop:
	mov   cl,bh                       ; Reset Column counter cl
	shr   cl,1
	rep   movsw                       ; Copy a complete row
	adc   cl,0
	rep   movsb
	add   si,[DataInc]                ; Move to next source row
	add   di,[LineInc]                ; Move to next screen row
	dec   bl                          ; decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows left
	pop   si                          ; Restore SI and set to offset of
	add   si,[PlaneInc]               ; first vis pixel in next plane data
	pop   di                          ; Restore bitmaps start dest byte
	rol   ah,1              ; Shift mask for next plane

	; Plane Transition (A HACK but it works!)

	jnb   @@Nocarry                   ; Jump if not plane transition
	mov   bl,ah                       ; Save Plane Mask
	mov   ax,[CType]                  ; set AX to clip type inc variable
	add   bh,al                       ; Update advancing variables
	sub   [DataInc],ax                ;
	sub   [LineInc],ax                ;
	cmp   al,0                        ; What type of clip do we have
	mov   ah,bl                       ;   restore Plane mask
	jg    @@RightAdvance              ; jump on a right clip!
	inc   di                          ; otherwise increment DI
	jmp   @@Nocarry
@@RightAdvance:
	dec si
@@Nocarry:
	dec   [Plane]                     ; Decrement plane counter
	jnz   @@PlaneLoop                 ; Jump if more planes left

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputpbmclipxy  endp

xstorevbmimage  proc far VramOffs:word,AAlign:word,LBitmap:dword
LOCAL BMWidth:byte

	push  si
	push  di
	push  ds
	cld

	mov   ax,SCREENSEG               ; Point ES to screen segment
	mov   es,ax
	mov   di,[VramOffs]               ; Point ES:DI to VRAM dest start
	mov   bx,[AAlign]                  ; Set BL to first pixel plane align
				and   bl,03h

	lds   si,[LBitmap]                ; DS:SI -> source linear Bitmap
				lodsw                             ; Al = B.M. width (bytes) AH = B.M.
	mov   bh,ah                       ; Save source bitmap dimensions
	mov   [BMWidth],al                ;

	mov   dx,SCINDEX                 ; Initialize Map Mask for plane
	mov   al,MAPMASK                 ; selection
				out   dx,al
	inc   dx
	xor   ch,ch                       ; clear CH
@@RowLoop:
	mov   cl,bl                       ; Set initial plane for current
	mov   ah,11h                      ; allignment
	shl   ah,cl

	mov   cl,[BMWidth]                ; Initialize column counter
@@ColLoop:
	mov   al,ah
	out   dx,al                       ; set vga write plane
	lodsb                             ; load next LBM pixel
	mov   es:[di],al                  ; store it in Video Ram
	shl   ah,1                        ; rotate plane mask
	jnb   @@NoAddrIncr                ; Time to increment dest address ?
	inc   di                          ; Yes: increment addr and reset
	mov   ah,11h                      ;  plane mask to plane 0
@@NoAddrIncr:
	loop  @@ColLoop                   ; Loop to next pixel column
	cmp   ah,11h
; je    @@skip
	inc   di          ; Increment dest addr
;@@skip:
	dec   bh                          ; Decrement row counter
	jnz   @@RowLoop                   ; Jump if more rows to go
	mov   ax,di                       ; calculate video RAM consumed and
	sub   ax,[VramOffs]               ;   return value

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xstorevbmimage  endp


xputmaskedvbm  proc far X:word,Y:word,ScrnOffs:word,SrcVBM:dword
LOCAL VBMWidth:word,VBMHeight:word,NextLineIncr:word
	push  si
	push  di
	push  ds
	cld

	mov   ax,SCREENSEG               ; Point es to VGA segment
	mov   es,ax
	mov   ax,[Y]                      ; Calculate dest screen row
	mov   cx,[ScrnLogicalByteWidth]  ;  by mult. dest Y coord by Screen
	mul   cx                          ;  width then adding screen offset

	mov   di,[ScrnOffs]               ;  store result in DI
	add   di,ax
	mov   si,[X]                      ; Load X coord into CX and make a
	mov   bx,si                       ;  copy in DX
	shr   bx,2                        ; Find starting byte in dest row
	add   di,bx                       ;  add to DI giving screen offset of
																					;  first pixel's byte

	and   si,3                        ; get pixel alignment in si

	lds   bx,[SrcVBM]                 ; DS:BX -> VBM data structure
	shl   si,2                        ; si = offset of data  for curr
						; alignment

	mov ax,word ptr [bx+ImageHeight]  ; Get image height
	mov   [VBMHeight],ax
	mov ax,word ptr [bx+ImageWidth]   ; Get image width
	mov   [VBMWidth],ax

	sub   cx,ax                       ; NextLineIncr = bytes to the begin.
	mov   [NextLineIncr],cx           ;  of bitmaps next row on screen
	mov   dx,[bx+MaskPtr+AlignData+si]  ; DS:SI -> mask data
	mov   bx,[bx+ImagePtr+AlignData+si] ; ES:BX -> source video bitmap
	mov   si,dx

	mov   dx,GCINDEX                 ; Set bit mask for all bits from
	mov   ax,BITMASK                 ; VGA latches and none from CPU
	out   dx,ax

	mov   dx,SCINDEX                 ; Point SC register to map mask
	mov   al,MAPMASK                 ; in preperation for masking data
	out   dx,al
	inc   dx                          ; Point dx to SC data register
	mov   ah,byte ptr [VBMHeight]     ; AH = Scanline loop counter

@@RowLoop:
	mov   cx,[VBMWidth]               ; Width in bytes across

@@ColumnLoop:
	lodsb
	out   dx,al
	mov   al,es:[bx]                  ; load latches from source bitmap
	stosb                             ; store latches to dest. bitmap
	inc   bx
	loop  @@ColumnLoop

	add   di,[NextLineIncr]           ; point to start of next dest row
	dec   ah                          ; decrement scan line counter
	jnz   @@RowLoop                   ; jump if more scanlines left

	mov   dx,GCINDEX+1               ; Restore bitmask to the default -
	mov   al,0ffh                     ;  all data from cpu
	out   dx,al

	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedvbm  endp


xputmaskedvbmclipx  proc far X:word,Y:word,ScrnOffs:word,SrcVBM:dword
LOCAL DataInc,LeftSkip,VBMWidth,VBMHeight,NextLineIncr:word
	push  si
	push  di
	push  ds
	cld

	mov   di,[X]                  ; load X coord int DI and make a
	mov   si,di                   ;  copy in SI
	sar   di,2                    ; Find Byte offset of X coord

	and   si,3                    ; Calculate pixels plane alignment
	shl   si,2                    ; Prepare to lookup mask & data
	les   bx,[SrcVBM]             ; ES:BX -> begining of VBM data

	mov   cx,es:[bx+ImageWidth]   ; Get image width and save in CX



	;;;;; CLIP PROCESSING FOR LEFT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

	mov   dx,[LeftClip]
	sub   dx,di
	jle   @@NotLeftClip
	cmp   dx,cx
	jnl   @@NotVisible
	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   cx,dx
	jmp   short @@HorizClipDone

				;;;; EXIT FOR COMPLETELY OBSCURED V.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR RIGHT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,cx
	jge   @@HorizClipDone
	inc   dx
	sub   cx,dx
	mov   [DataInc],cx
	mov   cx,dx

@@HorizClipDone:


	add   di,[ScrnOffs]           ; Add the current page offset
	mov   [VBMWidth],cx
	mov   ax,es:[bx+ImageHeight]  ; Get image height and save in AX
	mov   [VBMHeight],ax


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov   ax,[Y]                      ; Calculate dest screen row
	mov   cx,[ScrnLogicalByteWidth]  ;  by mult. dest Y coord by Screen
	mul   cx                          ;  width then adding screen offset
	add   di,ax                       ; Add Dest Screen Row to di
	sub   cx,[VBMWidth]
	mov   [NextLineIncr],cx

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	mov   ax,[bx+MaskPtr+AlignData+si]  ; DS:SI -> mask data
	mov   bx,[bx+ImagePtr+AlignData+si] ; ES:BX -> source video bitmap
	mov   si,ax

	mov   ax,[LeftSkip]               ; Skip data/mask bytes in
	add   bx,ax                       ; each row that have been clipped
	add   si,ax                       ; by the L.H.S border


	mov   dx,GCINDEX                 ; Set bit mask for all bits from
	mov   ax,BITMASK                 ; VGA latches and none from CPU
	out   dx,ax
	mov   dx,SCINDEX                 ; Point SC register to map mask
	mov   al,MAPMASK                 ; in preperation for masking data
	out   dx,al
	inc   dx                          ; Point dx to SC data register
	mov   ah,byte ptr [VBMHeight]     ; AH = Scanline loop counter

@@RowLoop:
	mov   cx,[VBMWidth]               ; Width in bytes across

@@ColumnLoop:
	lodsb
	out   dx,al
	mov   al,es:[bx]                  ; load latches from source bitmap
	stosb                             ; store latches to dest. bitmap
	inc   bx
	loop  @@ColumnLoop
	add   bx,[DataInc]
	add   si,[DataInc]
	add   di,[NextLineIncr]           ; point to start of next dest row
	dec   byte ptr ah                 ; decrement scan line counter
	jnz   @@RowLoop                   ; jump if more scanlines left

	mov   dx,GCINDEX+1               ; Restore bitmask to the default -
	mov   al,0ffh                     ;  all data from cpu
	out   dx,al
	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedvbmclipx  endp


xputmaskedvbmclipy  proc far X:word,Y:word,ScrnOffs:word,SrcVBM:dword
LOCAL VBMWidth,VBMHeight,TopRow,NextLineIncr:word
	push  si
	push  di
	push  ds
	cld

	mov   di,[X]                  ; load X coord int DI and make a
	mov   si,di                   ;  copy in SI


	and   si,3                    ; Calculate pixels plane alignment
	shl   si,2                    ; Prepare to lookup mask & data
	les   bx,[SrcVBM]             ; ES:BX -> begining of VBM data


	mov   ax,es:[bx+ImageHeight]  ; Get image height and save in AX



	;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,ax
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   ax,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED V.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,ax
	jg    @@VertClipDone
	inc   dx
	mov   ax,dx

@@VertClipDone:


	shr   di,2                    ; Find Byte offset of X coord
	add   di,[ScrnOffs]           ; Add the current page offset
	mov   cx,es:[bx+ImageWidth]   ; Get image width and save in CX
	mov   [VBMWidth],cx
	mov   [VBMHeight],ax

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov   ax,[Y]                      ; Calculate dest screen row
	mov   cx,[ScrnLogicalByteWidth]  ;  by mult. dest Y coord by Screen
	mul   cx                          ;  width then adding screen offset
	add   di,ax                       ; Add Dest Screen Row to di
	sub   cx,[VBMWidth]
	mov   [NextLineIncr],cx

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	mov   ax,[bx+MaskPtr+AlignData+si]  ; DS:SI -> mask data
	mov   bx,[bx+ImagePtr+AlignData+si] ; ES:BX -> source video bitmap
	mov   si,ax



	mov   ax,[VBMWidth]               ; Increment DS:BX and DS:SI to
	mul   [TopRow]                    ;  skip image/mask data that has
	add   bx,ax                       ;  been clipped by the top border
	add   si,ax


	mov   dx,GCINDEX                 ; Set bit mask for all bits from
	mov   ax,BITMASK                 ; VGA latches and none from CPU
	out   dx,ax
	mov   dx,SCINDEX                 ; Point SC register to map mask
	mov   al,MAPMASK                 ; in preperation for masking data
	out   dx,al
	inc   dx                          ; Point dx to SC data register
	mov   ah,byte ptr [VBMHeight]     ; AH = Scanline loop counter

@@RowLoop:
	mov   cx,[VBMWidth]               ; Width in bytes across

@@ColumnLoop:
	lodsb
	out   dx,al
	mov   al,es:[bx]                  ; load latches from source bitmap
	stosb                             ; store latches to dest. bitmap
	inc   bx
	loop  @@ColumnLoop
	add   di,[NextLineIncr]           ; point to start of next dest row
	dec   byte ptr ah                 ; decrement scan line counter
	jnz   @@RowLoop                   ; jump if more scanlines left

	mov   dx,GCINDEX+1               ; Restore bitmask to the default -
	mov   al,0ffh                     ;  all data from cpu
	out   dx,al

	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedvbmclipy  endp

xputmaskedvbmclipxy  proc far X:word,Y:word,ScrnOffs:word,SrcVBM:dword
LOCAL DataInc,LeftSkip,VBMWidth,VBMHeight,TopRow,NextLineIncr:word
	push  si
	push  di
	push  ds
	cld

	mov   di,[X]                  ; load X coord int DI and make a
	mov   si,di                   ;  copy in SI
	sar   di,2                    ; Find Byte offset of X coord
	and   si,3                    ; Calculate pixels plane alignment
	shl   si,2                    ; Prepare to lookup mask & data
	les   bx,[SrcVBM]             ; ES:BX -> begining of VBM data

	mov   cx,es:[bx+ImageWidth]   ; Get image width and save in CX
	mov   ax,es:[bx+ImageHeight]  ; Get image height and save in AX



	;;;;; CLIP PROCESSING FOR TOP CLIP BORDER ;;;;;;;;;;;;;;;;;;;;;

	mov   dx,[TopClip]           ; Compare u.l. Y coord with Top
	sub   dx,[Y]                  ; clipping border
	jle   @@NotTopClip            ; jump if VBM not clipped from above
	cmp   dx,ax
	jnl   @@NotVisible            ; jump if VBM is completely obscured
	mov   [TopRow],dx
	sub   ax,dx
	add   [Y],dx
	jmp   short @@VertClipDone

	;;;; EXIT FOR COMPLETELY OBSCURED V.B.M's ;;;;;;;;;;;;;;;;;;;;;;

@@NotVisible:
	mov   ax,1
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret

	;;;;; CLIP PROCESSING FOR BOTTOM CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotTopClip:
	mov   dx,[BottomClip]
	sub   dx,[Y]
	js    @@NotVisible
	mov   [TopRow],0
	cmp   dx,ax
	jg    @@VertClipDone
	inc   dx
	mov   ax,dx

@@VertClipDone:

	;;;;; CLIP PROCESSING FOR LEFT CLIP BORDER ;;;;;;;;;;;;;;;;;;;


	mov   dx,[LeftClip]
	sub   dx,di
	jle   @@NotLeftClip
	cmp   dx,cx
	jnl   @@NotVisible
	add   di,dx
	mov   [LeftSkip],dx
	mov   [DataInc],dx
	sub   cx,dx
	jmp   short @@HorizClipDone

	;;;;; CLIP PROCESSING FOR RIGHT CLIP BORDER ;;;;;;;;;;;;;;;;;;;

@@NotLeftClip:
	mov   dx,[RightClip]
	sub   dx,di
	js    @@NotVisible
	mov   [LeftSkip],0
	mov   [DataInc],0
	cmp   dx,cx
	jge    @@HorizClipDone
	inc   dx
	sub   cx,dx
	mov   [DataInc],cx
	mov   cx,dx

@@HorizClipDone:

	add   di,[ScrnOffs]           ; Add the current page offset
	mov   [VBMWidth],cx
	mov   [VBMHeight],ax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov   ax,[Y]                      ; Calculate dest screen row
	mov   cx,[ScrnLogicalByteWidth]   ;  by mult. dest Y coord by Screen
	mul   cx                          ;  width then adding screen offset
	add   di,ax                       ; Add Dest Screen Row to di
	sub   cx,[VBMWidth]
	mov   [NextLineIncr],cx

	mov   ax,es                       ; copy ES to DS
	mov   dx,SCREENSEG                ; Point ES to VGA segment
	mov   ds,ax
	mov   es,dx

	mov   ax,[bx+MaskPtr+AlignData+si]  ; DS:SI -> mask data
	mov   bx,[bx+ImagePtr+AlignData+si] ; ES:BX -> source video bitmap
	mov   si,ax



	mov   ax,[VBMWidth]               ; Increment DS:BX and DS:SI to
	add   ax,[DataInc]                ;  skip image/mask data that has
	mul   [TopRow]                    ;  been clipped by the top border
	add   ax,[LeftSkip]               ; Skip also data/mask bytes in
	add   bx,ax                       ; each row that have been clipped
	add   si,ax                       ; by the L.H.S border


	mov   dx,GCINDEX                  ; Set bit mask for all bits from
	mov   ax,BITMASK                  ; VGA latches and none from CPU
	out   dx,ax
	mov   dx,SCINDEX                  ; Point SC register to map mask
	mov   al,MAPMASK                  ; in preperation for masking data
	out   dx,al
	inc   dx                          ; Point dx to SC data register
	mov   ah,byte ptr [VBMHeight]     ; AH = Scanline loop counter

@@RowLoop:
	mov   cx,[VBMWidth]               ; Width in bytes across

@@ColumnLoop:
	lodsb
	out   dx,al
	mov   al,es:[bx]                  ; load latches from source bitmap
	stosb                             ; store latches to dest. bitmap
	inc   bx
	loop  @@ColumnLoop
	add   bx,[DataInc]
	add   si,[DataInc]
	add   di,[NextLineIncr]           ; point to start of next dest row
	dec   byte ptr ah                 ; decrement scan line counter
	jnz   @@RowLoop                   ; jump if more scanlines left

	mov   dx,GCINDEX+1                ; Restore bitmask to the default -
	mov   al,0ffh                     ;  all data from cpu
	out   dx,al
	xor   ax,ax
	pop   ds                          ; restore data segment
	pop   di                          ; restore registers
	pop   si
	ret
xputmaskedvbmclipxy  endp

xscale PROC FAR DestX:WORD, DestY:WORD, DestWidth:WORD, DestHeight:WORD,\
								ScrnOffs : WORD, Bitmap:DWord

LOCAL   DecisionX:WORD, DecisionY:WORD, ClippedWidth:WORD, ClippedHeight:WORD,\
				SourceWidth:WORD, SourceHeight:WORD, SourceOffset : Word,\
				SourceWidth2 : Word, SourceHeight2 : word, ByteWidth : word,\
				Plane : BYTE, DestWidth2 : word, DestHeight2 : word

				push            ds
				push    ds
				lds                     si, Bitmap
				xor     ah, ah
				lodsb
				mov     SourceWidth, ax
				lodsb
				mov     SourceHeight, ax
				pop     ds

				shl                     LeftClip, 2
				shl     RightClip, 2

				cmp     DestWidth, 2        ; If destination width is less than 2
				jl      @@Done                ;     then don't draw it.

				cmp     DestHeight, 2       ; If destination height is less than 2
				jl      @@Done                ;     then don't draw it.

				mov     ax, DestY           ; If it is completely below the
				cmp     ax, BottomClip          ; lower clip bondry,
				jg      @@Done                ;     then don't draw it.

				add     ax, DestHeight      ; If it is above clip boundries
				dec     ax                  ;     then don't draw it.
				cmp     ax, TopClip
				jl      @@Done

				mov     ax, DestX           ; If it is to the right of the
				cmp     ax, RightClip          ;     then don't draw it.
				jg      @@Done

				add     ax, DestWidth       ; If it is completely to the left
				dec     ax                  ; of the left clip boundry,
				cmp     ax, LeftClip          ;     then don't draw it.
				jl      @@Done

				mov     ax, DestWidth
				mov     ClippedWidth, ax

				shl     ax,1                ; Initialize the X decision var
				neg     ax                  ; to be -2*DestWidth
				mov     DecisionX, ax       ;

				mov     ax, DestHeight      ; ClippedHeight is initially set to
				mov     ClippedHeight, ax   ; the requested dest size.

				shl     ax,1                ; Initialize the Y decision var
				neg     ax                  ; to be -2*DestHeight
				mov     DecisionY, ax       ;

				mov                     SourceOffset, 0

				movsx   eax, TopClip        ; If Y is below the top
				mov     edx, eax            ; clipping boundry, then we don't
				sub     dx, DestY           ; need to clip the top, so we can
				js      @@NoTopClip         ; jump over the clipping stuff.

				mov     DestY, ax           ; This block performs clipping on the
				sub     ClippedHeight, dx   ; top of the bitmap.  I have heavily
				movsx   ecx, SourceHeight   ; optimized this block to use only 4
				imul    ecx, edx            ; 32-bit registers, so I'm not even
				mov     eax, ecx            ; gonna try to explain what it's doing.
				mov     edx, 0              ; But I can tell you what results from
				movsx   ebx, DestHeight     ; this:  The DecisionY var is updated
				idiv    ebx                 ; to start at the right clipped row.
				movsx   edx, SourceWidth    ; Y is moved to the top clip
				imul    edx, eax            ; boundry. ClippedHeight is lowered since
				add     si, dx              ; we won't be drawing all the requested
				imul    eax, ebx            ; rows.  SI is changed to point over
				sub     ecx, eax            ; the bitmap data that is clipped off.
				sub     ecx, ebx            ;
				shl     ecx, 1              ;
				mov     DecisionY, cx       ; <end of top clipping block >

@@NoTopClip:
				mov     ax, DestY           ; If the bitmap doesn't extend over the
				add     ax, ClippedHeight   ; bottom clipping boundry, then we
				dec     ax                  ; don't need to clip the bottom, so we
				cmp     ax, BottomClip      ; can jump over the bottom clip code.
				jle     @@NoBottomClip      ;

				mov     ax, BottomClip      ; Clip off the bottom by reducing the
				sub     ax, DestY           ; ClippedHeight so that the bitmap won't
				inc     ax                  ; extend over the lower clipping
				mov     ClippedHeight, ax   ; boundry.

@@NoBottomClip:
				movsx   eax, LeftClip       ; If X is to the left of the
				mov     edx, eax            ; top clipping boundry, then we don't
				sub     dx, DestX           ; need to clip the left, so we can
				js      @@NoLeftClip        ; jump over the clipping stuff.

				mov     DestX, ax           ; This block performs clipping on the
				sub     ClippedWidth, dx    ; left of the bitmap.  I have heavily
				movsx   ecx, SourceWidth    ; optimized this block to use only 4
				imul    ecx, edx            ; 32-bit registers, so I'm not even
				mov     eax, ecx            ; gonna try to explain what it's doing.
				mov     edx, 0              ; But I can tell you what results from
				movsx   ebx, DestWidth      ; this:  The DecisionX var is updated
				idiv    ebx                 ; to start at the right clipped column.
				add     SourceOffset, ax    ; X is moved to the left clip
				imul    eax, ebx            ; boundry. ClippedWidth is reduced since
				sub     ecx, eax            ; we won't be drawing all the requested
				sub     ecx, ebx            ; cols.  SI is changed to point over
				shl     ecx, 1              ; the bitmap data that is clipped off.
				mov     DecisionX, cx       ; <end of left clipping block >

@@NoLeftClip:
				mov     ax, DestX           ; If the bitmap doesn't extend over the
				add     ax, ClippedWidth    ; right clipping boundry, then we
				dec     ax                  ; don't need to clip the right, so we
				cmp     ax, RightClip       ; can jump over the right clip code.
				jle     @@NoClipRight       ;

				mov     ax, RightClip       ; Clip off the right by reducing the
				sub     ax, DestX           ; ClippedWidth so that the bitmap won't
				inc     ax                  ; extend over the right clipping
				mov     ClippedWidth, ax    ; boundry.

				;Calculate starting video address
@@NoClipRight:
				mov                     ax, SourceWidth
				shl     ax, 1
				mov     SourceWidth2, ax

				mov     ax, SourceHeight
				shl     ax, 1
				mov     SourceHeight2, ax

				mov     ax, DestHeight
				shl     ax, 1
				mov     DestHeight2, ax

				mov     ax, DestWidth
				shl     ax, 1
				mov     DestWidth2, ax

				mov                     ax, ScrnLogicalByteWidth
				mov     ByteWidth, ax

				mov     ax, SCREENSEG
				mov     es, ax
				mov     ax, DestY
				mov     bx, ScrnLogicalByteWidth
				mul     bx
				mov     di, ScrnOffs
				add     di, ax

				mov     cx, DestX
				mov     dx, cx
				shr     dx, 2
				add     di, dx

				lds     si, Bitmap
				add     si, 2
				add     si, SourceOffset

				mov     dx, SCINDEX         ; Point the VGA Sequencer to the Map
				mov     al, MAPMASK         ; Mask register, so that we only need
				out     dx, al              ; to send out 1 byte per column.

				inc     dx                  ; Move to the Sequencer's Data register.
				and     cx, 3               ; Calculate the starting plane. This is
				mov     al, 11h             ; just:
				shl     al, cl              ; Plane =  (11h << (X AND 3))
				mov     Plane, al
				out     dx, al              ; Select the first plane.

@@RowLoop:
				push    si                  ; Save the starting source index
				push    di                  ; Save the starting dest index

				mov     cx, ClippedHeight
				mov     bx, DecisionY
				mov     dx, ByteWidth

				mov     al, ds:[si]

@@ColumnLoop:
				mov     es:[di], al
				add     di, dx
				dec     cx
				jz      @@DoneWithCol
				add     bx, SourceHeight2
				js      @@ColumnLoop

@@IncSourceRow:
				add     si, SourceWidth
				sub     bx, DestHeight2
				jns     @@IncSourceRow
				mov     al, ds:[si]
				jmp     @@ColumnLoop

@@DoneWithCol:
				pop     di
				pop     si

				rol     Plane, 1
				adc     di, 0
				mov     dx, SCINDEX
				inc     dx
				mov     al, Plane
				out     dx, al

				mov     ax, SourceWidth2
				add     DecisionX, ax
				js      @@NextCol
@@IncSourceCol:
				inc     si
				mov     ax, DestWidth2
				sub     DecisionX, ax
				jns     @@IncSourceCol
@@NextCol:
				dec     ClippedWidth        ; If we're not at last column
				jnz     @@RowLoop           ;    then do another column
@@Done:
				pop     ds
				shr                     LeftClip, 2
				shr     RightClip, 2
				ret                         ; We're done!

xscale     ENDP

xmaskedscale PROC FAR DestX:WORD, DestY:WORD, DestWidth:WORD, DestHeight:WORD,\
								ScrnOffs : WORD, Bitmap:DWord

LOCAL   DecisionX:WORD, DecisionY:WORD, ClippedWidth:WORD, ClippedHeight:WORD,\
				SourceWidth:WORD, SourceHeight:WORD, SourceOffset : Word,\
				SourceWidth2 : Word, SourceHeight2 : word, ByteWidth : word,\
				Plane : BYTE, DestWidth2 : word, DestHeight2 : word

				push            ds
				push    ds
				lds                     si, Bitmap
				xor     ah, ah
				lodsb
				mov     SourceWidth, ax
				lodsb
				mov     SourceHeight, ax
				pop     ds

				shl                     LeftClip, 2
				shl     RightClip, 2

				cmp     DestWidth, 2        ; If destination width is less than 2
				jl      @@Done                ;     then don't draw it.

				cmp     DestHeight, 2       ; If destination height is less than 2
				jl      @@Done                ;     then don't draw it.

				mov     ax, DestY           ; If it is completely below the
				cmp     ax, BottomClip          ; lower clip bondry,
				jg      @@Done                ;     then don't draw it.

				add     ax, DestHeight      ; If it is above clip boundries
				dec     ax                  ;     then don't draw it.
				cmp     ax, TopClip
				jl      @@Done

				mov     ax, DestX           ; If it is to the right of the
				cmp     ax, RightClip          ;     then don't draw it.
				jg      @@Done

				add     ax, DestWidth       ; If it is completely to the left
				dec     ax                  ; of the left clip boundry,
				cmp     ax, LeftClip          ;     then don't draw it.
				jl      @@Done

				mov     ax, DestWidth
				mov     ClippedWidth, ax

				shl     ax,1                ; Initialize the X decision var
				neg     ax                  ; to be -2*DestWidth
				mov     DecisionX, ax       ;

				mov     ax, DestHeight      ; ClippedHeight is initially set to
				mov     ClippedHeight, ax   ; the requested dest size.

				shl     ax,1                ; Initialize the Y decision var
				neg     ax                  ; to be -2*DestHeight
				mov     DecisionY, ax       ;

				mov                     SourceOffset, 0

				movsx   eax, TopClip        ; If Y is below the top
				mov     edx, eax            ; clipping boundry, then we don't
				sub     dx, DestY           ; need to clip the top, so we can
				js      @@NoTopClip         ; jump over the clipping stuff.

				mov     DestY, ax           ; This block performs clipping on the
				sub     ClippedHeight, dx   ; top of the bitmap.  I have heavily
				movsx   ecx, SourceHeight   ; optimized this block to use only 4
				imul    ecx, edx            ; 32-bit registers, so I'm not even
				mov     eax, ecx            ; gonna try to explain what it's doing.
				mov     edx, 0              ; But I can tell you what results from
				movsx   ebx, DestHeight     ; this:  The DecisionY var is updated
				idiv    ebx                 ; to start at the right clipped row.
				movsx   edx, SourceWidth    ; Y is moved to the top clip
				imul    edx, eax            ; boundry. ClippedHeight is lowered since
				add     si, dx              ; we won't be drawing all the requested
				imul    eax, ebx            ; rows.  SI is changed to point over
				sub     ecx, eax            ; the bitmap data that is clipped off.
				sub     ecx, ebx            ;
				shl     ecx, 1              ;
				mov     DecisionY, cx       ; <end of top clipping block >

@@NoTopClip:
				mov     ax, DestY           ; If the bitmap doesn't extend over the
				add     ax, ClippedHeight   ; bottom clipping boundry, then we
				dec     ax                  ; don't need to clip the bottom, so we
				cmp     ax, BottomClip      ; can jump over the bottom clip code.
				jle     @@NoBottomClip      ;

				mov     ax, BottomClip      ; Clip off the bottom by reducing the
				sub     ax, DestY           ; ClippedHeight so that the bitmap won't
				inc     ax                  ; extend over the lower clipping
				mov     ClippedHeight, ax   ; boundry.

@@NoBottomClip:
				movsx   eax, LeftClip       ; If X is to the left of the
				mov     edx, eax            ; top clipping boundry, then we don't
				sub     dx, DestX           ; need to clip the left, so we can
				js      @@NoLeftClip        ; jump over the clipping stuff.

				mov     DestX, ax           ; This block performs clipping on the
				sub     ClippedWidth, dx    ; left of the bitmap.  I have heavily
				movsx   ecx, SourceWidth    ; optimized this block to use only 4
				imul    ecx, edx            ; 32-bit registers, so I'm not even
				mov     eax, ecx            ; gonna try to explain what it's doing.
				mov     edx, 0              ; But I can tell you what results from
				movsx   ebx, DestWidth      ; this:  The DecisionX var is updated
				idiv    ebx                 ; to start at the right clipped column.
				add     SourceOffset, ax    ; X is moved to the left clip
				imul    eax, ebx            ; boundry. ClippedWidth is reduced since
				sub     ecx, eax            ; we won't be drawing all the requested
				sub     ecx, ebx            ; cols.  SI is changed to point over
				shl     ecx, 1              ; the bitmap data that is clipped off.
				mov     DecisionX, cx       ; <end of left clipping block >

@@NoLeftClip:
				mov     ax, DestX           ; If the bitmap doesn't extend over the
				add     ax, ClippedWidth    ; right clipping boundry, then we
				dec     ax                  ; don't need to clip the right, so we
				cmp     ax, RightClip       ; can jump over the right clip code.
				jle     @@NoClipRight       ;

				mov     ax, RightClip       ; Clip off the right by reducing the
				sub     ax, DestX           ; ClippedWidth so that the bitmap won't
				inc     ax                  ; extend over the right clipping
				mov     ClippedWidth, ax    ; boundry.

				;Calculate starting video address
@@NoClipRight:
				mov                     ax, SourceWidth
				shl     ax, 1
				mov     SourceWidth2, ax

				mov     ax, SourceHeight
				shl     ax, 1
				mov     SourceHeight2, ax

				mov     ax, DestHeight
				shl     ax, 1
				mov     DestHeight2, ax

				mov     ax, DestWidth
				shl     ax, 1
				mov     DestWidth2, ax

				mov                     ax, ScrnLogicalByteWidth
				mov     ByteWidth, ax

				mov     ax, SCREENSEG
				mov     es, ax
				mov     ax, DestY
				mov     bx, ScrnLogicalByteWidth
				mul     bx
				mov     di, ScrnOffs
				add     di, ax

				mov     cx, DestX
				mov     dx, cx
				shr     dx, 2
				add     di, dx

				lds     si, Bitmap
				add     si, 2
				add     si, SourceOffset

				mov     dx, SCINDEX         ; Point the VGA Sequencer to the Map
				mov     al, MAPMASK         ; Mask register, so that we only need
				out     dx, al              ; to send out 1 byte per column.

				inc     dx                  ; Move to the Sequencer's Data register.
				and     cx, 3               ; Calculate the starting plane. This is
				mov     al, 11h             ; just:
				shl     al, cl              ; Plane =  (11h << (X AND 3))
				mov     Plane, al
				out     dx, al              ; Select the first plane.

@@RowLoop:
				push    si                  ; Save the starting source index
				push    di                  ; Save the starting dest index

				mov     cx, ClippedHeight
				mov     bx, DecisionY
				mov     dx, ByteWidth

				mov     al, ds:[si]

@@ColumnLoop:
				or      al, al
				jz      @@DontDraw
				mov     es:[di], al
@@DontDraw:
				add     di, dx
				dec     cx
				jz      @@DoneWithCol
				add     bx, SourceHeight2
				js      @@ColumnLoop

@@IncSourceRow:
				add     si, SourceWidth
				sub     bx, DestHeight2
				jns     @@IncSourceRow
				mov     al, ds:[si]
				jmp     @@ColumnLoop

@@DoneWithCol:
				pop     di
				pop     si

				rol     Plane, 1
				adc     di, 0
				mov     dx, SCINDEX
				inc     dx
				mov     al, Plane
				out     dx, al

				mov     ax, SourceWidth2
				add     DecisionX, ax
				js      @@NextCol
@@IncSourceCol:
				inc     si
				mov     ax, DestWidth2
				sub     DecisionX, ax
				jns     @@IncSourceCol
@@NextCol:
				dec     ClippedWidth        ; If we're not at last column
				jnz     @@RowLoop           ;    then do another column
@@Done:
				pop     ds
				shr                     LeftClip, 2
				shr     RightClip, 2
				ret                         ; We're done!

xmaskedscale     ENDP

end
