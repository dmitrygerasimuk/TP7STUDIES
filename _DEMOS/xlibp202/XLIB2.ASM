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
		.DATA

	OldHandlerSeg      dw  ?
	OldHandlerOffs     dw  ?
	OldHandlerMask     dw  ?
	OldX               dw  ?
	OldY               dw  ?
	OldScrnOffs        dw  ?

	level              dw  ?
	gencount           dw  ?
	AdjustedOffs       dw  ?
	p1xt               dw  ?
	p1yt               dw  ?
	p2xt               dw  ?
	p2yt               dw  ?
	p4xt               dw  ?
	p4yt               dw  ?
	p5xt               dw  ?
	p5yt               dw  ?
	c1xt               dw  ?
	c1yt               dw  ?
	c2xt               dw  ?
	c2yt               dw  ?
	xdiff              dw  ?
	ydiff              dw  ?
	moveline           dw  ?
	stepper            dw  ?
	bptemp             dw  ?
	Colort             dw  ?

	TicksPerSecond         dw ?
	VsyncIntTicks          label dword
	VsyncIntTicksLo        dw ?
	VsyncIntTicksHi        dw ?
	VsyncPeriod            dw ?       ;Time (in clicks) between each vsync
																		;1 click = 1.193 microseconds

	ClockRate              dw ?             ;Clock rate (in clicks) for timer 0
	ClockCounter           dw ?             ;Counts total clicks modulo 65536
	UserVsyncHandler       label dword      ;Pointer to user routine called
	UserVsyncOffs          dw ?             ;called once each vsync period.
	UserVsyncSeg           dw ?
	InUserHandler          dw ?
				db 100h dup(?)
	LocalStack             label byte       ;Local stack for user handler
	StackSeg               dw ?
	StackPtr               dw ?


	ElapsedVrts            dw ?
	VrtsToSkip             dw ?
	MouseVSyncHandler      dd ?


		.CODE

XSetMode PROC FAR Mode : Word, WidthInPixels : Word

	mov InGraphics,0
	mov ErrorValue,0
	mov DoubleScanFlag,0
	mov CurrXMode,0
	mov ScrnPhysicalByteWidth,0
	mov ScrnPhysicalPixelWidth,0
	mov ScrnPhysicalHeight,0
	mov SplitScrnOffs,0
	mov SplitScrnScanLine,0
	mov SplitScrnVisibleHeight,0
	mov SplitScrnActive,0
	mov Page0Offs,0
	mov Page1Offs,0
	mov Page2Offs,0
	mov ScrnLogicalByteWidth,0
	mov ScrnLogicalPixelWidth,0
	mov ScrnLogicalHeight,0
	mov MaxScrollX,0
	mov MaxScrollY,0
	mov DoubleBufferActive,0
	mov VisiblePageIdx,0
	mov HiddenPageOffs,0
	mov VisiblePageOffs,0
	mov NonVisualOffs,0
	mov TopClip,0
	mov BottomClip,0
	mov LeftClip,0
	mov RightClip,0
	mov PhysicalStartPixelX,0
	mov PhysicalStartByteX,0
	mov PhysicalStartY,0
IFDEF _DPMI_
	mov	ax,__AHIncr
	mov SelectorInc,ax
	mov ax, __0000H
	mov Seg0000,ax
	mov ax, __A000H
ELSE
	mov ax, 0A000h
ENDIF
	mov ScreenSeg,ax
	cld
	mov   ax,ds
	mov   es,ax
	mov   cx,mode
	cmp   cx,LastXMode
	jle   @@ValidMode
	mov   InGraphics,0
	mov   ax,-1
	jmp @@Done

@@ValidMode:
	mov   CurrXMode,cx
	mov   InGraphics,1
	xor   al,al
	cmp   cx,3
	jg    @@SetDoubleScanFlag
	mov   al,1

@@SetDoubleScanFlag:
	mov   DoubleScanFlag,al
	push  cx
	mov   ax,13h
	int   10h
	pop   cx
	mov   dx,ScIndex
	mov   ax,0604h
	out   dx,ax
	mov   ax,0100h
	out   dx,ax
	mov   bx,offset ModeTable
	shl   cx,1
	add   bx,cx
	mov   si, word ptr [bx]
	lodsb
	or    al,al
	jz    @@DontSetDot
	mov   dx,MISCOUTPUT
	out   dx,al

@@DontSetDot:
	mov   dx,ScIndex
	mov   ax,0300h
	out   dx,ax
	mov   dx,CrtcIndex
	mov   al,11h
	out   dx,al
	inc   dx
	in    al,dx
	and   al,07fh
	out   dx,al
	dec   dx
	cld
	xor   cx,cx
	lodsb
	mov   cl,al

@@SetCRTParmsLoop:
	lodsw

	out   dx,ax
	loop  @@SetCRTParmsLoop
	mov   dx,ScIndex
	mov   ax,0f02h
	out   dx,ax
	mov   ax,ScreenSeg
	mov   es,ax
	sub   di,di
	sub   ax,ax
	mov   cx,8000h
	rep   stosw
	lodsw
	mov   ScrnPhysicalPixelWidth,ax
	mov   SplitScrnScanLine,ax
	mov   bx,ax
	shr   ax,2
	mov   ScrnPhysicalByteWidth,ax
	lodsw
	mov   ScrnPhysicalHeight,ax
	mov   cx,widthinpixels
	mov   dx,CrtcIndex
	mov   al,CRTCOFFSET
	out   dx,al
	inc   dx
	mov   ax,cx
	cmp   ax,ScrnPhysicalPixelWidth
	jge   @@ValidLogicalWidth
	mov   ax,bx

@@ValidLogicalWidth:
	shr   ax,3
	out   dx,al
	shl   ax,1
	mov   bx,ax
	mov   ScrnLogicalByteWidth,ax
	mov   RightClip,ax
	sub   ax,ScrnPhysicalByteWidth
	shl   ax,2
	mov   MaxScrollX,ax
	mov   ax,bx
	shl   ax,2
	mov   ScrnLogicalPixelWidth,ax
	mov   cx,ax
	mov   ax,0ffffh
	sub   dx,dx
	div   bx
	mov   ScrnLogicalHeight,ax
	mov   BottomClip,ax
	sub   ax,ScrnPhysicalHeight
	mov   MaxScrollY,ax
	mov   ax,cx
	mov   ax,ScrnLogicalByteWidth
	mul   ScrnPhysicalHeight
	mov   NonVisualOffs,ax

@@Done:
	mov   ax, 0CB00h
	int   10h
	ret

XSetMode ENDP

XSelectDefaultPlane PROC FAR Plane : Byte

	mov  cl,Plane
	and  cl,011b
	mov  ax,0100h + MapMask
	shl  ah,cl
	mov  dx,ScIndex
	out  dx,ax
	mov  ah,cl
	mov  al,ReadMap
	mov  dx,GcIndex
	out  dx,ax
	ret

XSelectDefaultPlane ENDP

XSetSplitscreen PROC FAR Line : Word

	xor  si,si
	cmp  DoubleBufferActive,0
	jne  @@error
	cmp  SplitScrnActive,0
	je   @@NotPreviouslyCalled

@@error:
	mov  ErrorValue,ERROR
	ret

@@NotPreviouslyCalled:
	mov  dx,InputStatus0
	in   al,dx
	mov  al,ACMODECONTROL+20h
	mov  dx,ACINDEX
	out  dx,al
	inc  dx
	in   al,dx
	or   al,20h
	dec  dx
	out  dx,al
	mov  PhysicalStartByteX,ax
	mov  PhysicalStartPixelX,ax
	mov  PhysicalStartY,ax
	mov  SplitScrnActive,1
	mov  ax,Line
	jns  @@NotNeg
	mov  ax,0

@@NotNeg:
	mov  SplitScrnScanLine,ax
	or   DoubleScanFlag,0
	jz   @@NotDoubleScanned
	shl  ax,1
	dec  ax

@@NotDoubleScanned:
	mov  bx,ax
	mov  dx,InputStatus0

@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync

@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	cli
	mov  dx,CrtcIndex
	mov  ah,bl
	mov  al,LINECOMPARE
	out  dx,ax
	mov  ah,bh
	and  ah,1
	shl  ah,4
	mov  al,Overflow
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 10h
	or   al,ah
	out  dx,al
	dec  dx
	mov  ah,bh
	and  ah,2
	ror  ah,3
	mov  al,MAXSCANLINE
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 40h
	or   al,ah
	out  dx,al
	sti
	mov  ax,ScrnPhysicalHeight
	sub  ax,SplitScrnScanLine
	mov  SplitScrnVisibleHeight,ax
	mov  bx,ScrnLogicalByteWidth
	mul  bx
	mov  Page0Offs,ax
	mov  Page1Offs,ax
	mov  Page2Offs,ax
	mov  cx,0ffffh
	sub  cx,ax
	xchg cx,ax
	sub  dx,dx
	div  bx
	mov  ScrnLogicalHeight,ax
	cmp  ax,BottomClip
	jle  @@BottomClipOK
	mov  BottomClip,ax

@@BottomClipOK:
	sub  ax,SplitScrnScanLine
	mov  MaxScrollY,ax
	xchg cx,ax
	mov  bh,al
	mov  ch,ah
	mov  bl,ADDRLOW
	mov  cl,ADDRHIGH
	and  si,0003h
	mov  ah,byte ptr PelPanMask[si]
	mov  al,PELPANNING+20h
	mov  si,ax

; VSync Handler stuff

	cmp  VSyncHandlerActive, TRUE
	jne   @@NoVsyncHandler

@@WaitLast:
	cmp   StartAddressFlag,0
	jne   @@WaitLast
	cli
	mov  WaitingStartLow,bx
	mov  WaitingStartHigh,cx
	mov  WaitingPelPan,si
	mov  StartAddressFlag,1
	sti
	jmp  short @@Return

; End VSync Handler stuff

@@NoVsyncHandler:
	mov  dx,InputStatus0

@@WaitDE:
	in   al,dx
	test al,01h
	jnz  @@WaitDE
	mov  dx,CrtcIndex
	mov  ax,bx
	cli
	out  dx,ax
	mov  ax,cx
	out  dx,ax
	sti
	mov  dx,InputStatus0

@@WaitVS:
	in   al,dx
	test al,08h
	jz @@WaitVS

	mov  dx,ACINDEX
	mov  ax,si
	cli
	out  dx,al
	mov  al,ah
	out  dx,al
	sti

@@Return:
	mov  ErrorValue,OK
	ret

XSetSplitScreen ENDP

XSetStartAddr PROC FAR X : Word, Y : Word

	mov  si,x
	mov  ax,ScrnLogicalByteWidth
	mov  cx,y
	mul  cx
	cmp  DoubleBufferActive,1
	je   @@PageResolution
	cmp  TripleBufferActive,1
	je   @@PageResolution

@@PageFlipEntry1:
	add  ax,Page0Offs
	jmp  @@AddColumn

@@PageFlipEntry2:
	mov  PhysicalStartPixelX,si
	mov  PhysicalStartY,cx

@@PageResolution:
	add  ax,VisiblePageOffs

@@AddColumn:
	mov  cx,si
	shr  cx,2
	mov  PhysicalStartByteX,cx
	add  ax,cx
	mov  bh,al
	mov  ch,ah

@@StartAddrEntry:
	mov  bl,ADDRLOW
	mov  cl,ADDRHIGH
	and  si,0003h
	mov  ah,byte ptr PelPanMask[si]
	mov  al,PELPANNING+20h
	mov  si,ax

; VSync Handler stuff

	cmp  VSyncHandlerActive, TRUE
	jne   @@NoVsyncHandler

@@WaitLast:
	cmp   StartAddressFlag,0
	jne   @@WaitLast
	cli
	mov  WaitingStartLow,bx
	mov  WaitingStartHigh,cx
	mov  WaitingPelPan,si
	mov  StartAddressFlag,1
	sti
	jmp  short @@Return

; End VSync Handler stuff

@@NoVsyncHandler:
	mov  dx,InputStatus0

@@WaitDE:
	in   al,dx
	test al,01h
	jnz  @@WaitDE
	mov  dx,CrtcIndex
	mov  ax,bx
	cli
	out  dx,ax
	mov  ax,cx
	out  dx,ax
	sti
	mov  dx,InputStatus0

@@WaitVS:
	in   al,dx
	test al,08h
	jz @@WaitVS

	mov  dx,ACINDEX
	mov  ax,si
	cli
	out  dx,al
	mov  al,ah
	out  dx,al
	sti

@@Return:
	mov  ErrorValue,OK
	ret

XSetStartAddr ENDP

XHideSplitscreen PROC FAR

	cmp  SplitScrnActive,1
	je   @@SplitScreenEnabled

@@error:
	mov  ErrorValue,ERROR
	jmp  @@Done

@@SplitScreenEnabled:
	cmp  CurrXMode,4
	jg   @@error
	mov  bx,ScrnPhysicalHeight
	mov  ax,ScrnLogicalHeight
	sub  ax,bx
	mov  MaxScrollY,ax
	xor  ax,ax
	mov  SplitScrnVisibleHeight,ax
	or   DoubleScanFlag,0
	jz   @@NotDoubleScanned
	shl  bx,1
	dec  bx

@@NotDoubleScanned:
	cmp  VSyncHandlerActive,1
	je   @@VSyncHandling
	mov  dx,InputStatus0

@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync

@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	jmp  short @@SetRegs
@@VSyncHandling:
	cmp  StartAddressFlag,0
	jne  @@VSyncHandling
	mov  StartAddressFlag,1
@@SetRegs:
	cli
	mov  dx,CrtcIndex
	mov  ah,bl
	mov  al,LINECOMPARE
	out  dx,ax
	mov  ah,bh
	and  ah,1
	shl  ah,4
	mov  al,Overflow
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 10h
	or   al,ah
	out  dx,al
	dec  dx
	mov  ah,bh
	and  ah,2
	ror  ah,3
	mov  al,MAXSCANLINE
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 40h
	or   al,ah
	out  dx,al
	sti

@@done:
	mov  ErrorValue,OK
	ret

XHideSplitScreen ENDP

XShowSplitscreen PROC FAR

	cmp  SplitScrnActive,1
	je   @@SplitScreenEnabled

@@error:
	mov  ErrorValue,ERROR
	jmp  @@Done

@@SplitScreenEnabled:
	cmp  CurrXMode,4
	jg   @@error
	mov  bx,SplitScrnScanLine
	mov  ax,ScrnLogicalHeight
	sub  ax,bx
	mov  MaxScrollY,ax
	mov  ax,ScrnPhysicalHeight
	sub  ax,bx
	mov  SplitScrnVisibleHeight,ax
	or   DoubleScanFlag,0
	jz   @@NotDoubleScanned
	shl  bx,1
	dec  bx

@@NotDoubleScanned:
	cmp  VsyncHandlerActive,1
	je   @@VSyncHandling
	mov  dx,InputStatus0

@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync

@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	jmp short @@SetRegs
@@VSyncHandling:
	cmp  StartAddressFlag,0
	jne  @@VSyncHandling
	mov  StartAddressFlag,1
@@SetRegs:
	cli
	mov  dx,CrtcIndex
	mov  ah,bl
	mov  al,LINECOMPARE
	out  dx,ax
	mov  ah,bh
	and  ah,1
	shl  ah,4
	mov  al,Overflow
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 10h
	or   al,ah
	out  dx,al
	dec  dx
	mov  ah,bh
	and  ah,2
	ror  ah,3
	mov  al,MAXSCANLINE
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 40h
	or   al,ah
	out  dx,al
	sti

@@Done:
	mov  ErrorValue,0
	ret

XShowSplitScreen ENDP

XAdjustSplitScreen PROC FAR Line : Word

	cmp  SplitScrnActive,1
	je   @@SplitScreenEnabled

@@error:
	mov  ErrorValue,ERROR
	jmp  @@Done

@@SplitScreenEnabled:
	cmp  CurrXMode,4
	jg   @@error
	mov  bx,Line
	cmp  bx,SplitScrnScanLine
	js   @@Done

@@ValidScanLine:
	mov  ax,ScrnLogicalHeight
	sub  ax,bx
	mov  MaxScrollY,ax
	mov  ax,ScrnPhysicalHeight
	sub  ax,bx
	mov  SplitScrnVisibleHeight,ax
	or   DoubleScanFlag,0
	jz   @@NotDoubleScanned
	shl  bx,1
	dec  bx

@@NotDoubleScanned:
	cmp  VsyncHandlerActive,1
	je   @@VsyncHandling

	mov  dx,InputStatus0

@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync

@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	jmp  short @@SetRegs

@@VsyncHandling:
	cmp  StartAddressFlag,0
	jne  @@VSyncHandling
	mov  StartAddressFlag,2
@@SetRegs:
	cli
	mov  dx,CrtcIndex
	mov  ah,bl
	mov  al,LINECOMPARE
	out  dx,ax
	mov  ah,bh
	and  ah,1
	shl  ah,4
	mov  al,Overflow
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 10h
	or   al,ah
	out  dx,al
	dec  dx
	mov  ah,bh
	and  ah,2
	ror  ah,3
	mov  al,MAXSCANLINE
	out  dx,al
	inc  dx
	in   al,dx
	and  al, not 40h
	or   al,ah
	out  dx,al
	sti

@@Done:
	mov  ErrorValue,OK
	ret

XAdjustSplitScreen ENDP

XSetDoubleBuffer PROC FAR PageHeight : Word

	cmp   DoubleBufferActive,0
	je    @@OkToContinue
@error:
	mov   ErrorValue,ERROR
	ret

@@OkToContinue:
	mov  VisiblePageIdx,0
	mov  ax,ScrnLogicalHeight
	shr  ax,1
	mov  bx,PageHeight
	cmp  ax,bx
	js   @@InvalidHeight
	mov  ax,bx

@@InvalidHeight:
	mov   ScrnLogicalHeight,ax
	cmp   ax,BottomClip
	jle   @@BottomClipOK
	mov   BottomClip,ax
@@BottomClipOK:
	mov   dx,ax
	mul   ScrnLogicalByteWidth
	mov   cx,ax
	mov   bx,Page0Offs
	mov   VisiblePageOffs,bx
	add   ax,bx
	mov   Page1Offs,ax
	mov   HiddenPageOffs,ax
	add   ax,cx
	mov   NonVisualOffs,ax
	mov   DoubleBufferActive,1
	mov   ax,dx
	sub   ax,ScrnPhysicalHeight
	add   ax,SplitScrnVisibleHeight
	mov   MaxScrollY,ax
	mov   ax,dx
	mov   ErrorValue,OK
	ret

XSetDoubleBuffer ENDP

XSetTripleBuffer PROC FAR PageHeight : word

	cmp   DoubleBufferActive,0
	jne   @@Error
	cmp   TripleBufferActive,0
	je    @@OkToContinue

@@Error:
	mov   ErrorValue,ERROR
	jmp @@Done

@@OkToContinue:
	mov   VisiblePageIdx,0
	mov   ax,ScrnLogicalHeight
	mov   bx,3
	xor   dx,dx
	idiv  bx
	mov   bx,PageHeight
	cmp   ax,bx
	js    @@InvalidHeight
	mov   ax,bx

@@InvalidHeight:
	mov   ScrnLogicalHeight,ax
	cmp   ax,BottomClip
	jle   @@BottomClipOK
	mov   BottomClip,ax

@@BottomClipOK:
	push  ax
	mul   ScrnLogicalByteWidth
	mov   cx,ax
	mov   bx,Page0Offs
	mov   VisiblePageOffs,bx
	add   ax,bx
	mov   Page1Offs,ax
	mov   HiddenPageOffs,ax
	add   ax,cx
	mov   Page2Offs,ax
	mov   WaitingPageOffs,ax
	add   ax,cx
	mov   NonVisualOffs,ax
	mov   TripleBufferActive,1
	pop   ax
	sub   ax,ScrnPhysicalHeight
	add   ax,SplitScrnVisibleHeight
	mov   MaxScrollY,ax
	mov   ax,dx
	mov   ErrorValue,OK

@@Done:
	ret

XSetTripleBuffer ENDP

XPageFlip PROC FAR X : Word, Y : Word

	mov  si,x
	mov  ax,ScrnLogicalByteWidth
	mov  cx,y
	mul  cx
	cmp  DoubleBufferActive,1
	je   @@DoubleBuffer
	cmp  TripleBufferActive,1
	jne  @@PageFlipEntry1
	mov  bx,HiddenPageOffs
	xchg bx,VisiblePageOffs
	xchg bx,WaitingPageOffs
	mov  HiddenPageOffs,bx
	mov  bx, VisiblePageIdx
	inc  bx
	cmp  bx,3
	jne  @@IdxOk
	xor  bx,bx
@@IdxOk:
	mov  VisiblePageIdx,bx
	jmp  @@PageFlipEntry2

@@DoubleBuffer:
	mov  bx,HiddenPageOffs
	xchg bx,VisiblePageOffs
	xchg HiddenPageOffs,bx
	xor  VisiblePageIdx,01h
	jmp  @@PageFlipEntry2

@@PageFlipEntry1:
	add  ax,Page0Offs
	jmp  @@AddColumn

@@PageFlipEntry2:
	mov  PhysicalStartPixelX,si
	mov  PhysicalStartY,cx

@@PageResolution:
	add  ax,VisiblePageOffs

@@AddColumn:
	mov  cx,si
	shr  cx,2
	mov  PhysicalStartByteX,cx
	add  ax,cx
	mov  bh,al
	mov  ch,ah

@@StartAddrEntry:
	mov  bl,ADDRLOW
	mov  cl,ADDRHIGH
	and  si,0003h
	mov  ah,byte ptr PelPanMask[si]
	mov  al,PELPANNING+20h
	mov  si,ax
; VSync Handler stuff

	cmp  VSyncHandlerActive, TRUE
	jne   @@NoVsyncHandler

@@WaitLast:
	cmp   StartAddressFlag,0
	jne   @@WaitLast
	cli
	mov  WaitingStartLow,bx
	mov  WaitingStartHigh,cx
	mov  WaitingPelPan,si
	mov  StartAddressFlag,1
	sti
	jmp  short @@Return

; End VSync Handler stuff

@@NoVsyncHandler:
	mov  dx,InputStatus0

@@WaitDE:
	in   al,dx
	test al,01h
	jnz  @@WaitDE
	mov  dx,CrtcIndex
	mov  ax,bx
	cli
	out  dx,ax
	mov  ax,cx
	out  dx,ax
	sti
	mov  dx,InputStatus0

@@WaitVS:
	in   al,dx
	test al,08h
	jz @@WaitVS

	mov  dx,ACINDEX
	mov  ax,si
	cli
	out  dx,al
	mov  al,ah
	out  dx,al
	sti

@@Return:
	mov  ErrorValue,OK
	ret

XPageFlip ENDP

XSetClipRect PROC FAR Left : Word, Top : Word, Right : Word, Bottom : Word

	mov   ax,left
	mov   bx,right
	cmp   bx,ax
	jns   @@CorrectXOrder
	xchg  bx,ax
@@CorrectXOrder:
	mov   LeftClip,ax
	mov   RightClip,bx
	mov   ax,top
	mov   bx,bottom
	cmp   bx,ax
	jns   @@CorrectYOrder
	xchg  bx,ax
@@CorrectYOrder:
	mov   TopClip,ax
	mov   BottomClip,bx
	ret

XSetClipRect ENDP

XTextMode PROC FAR

	mov   ax,03h
	int   10h
	ret

XTextMode ENDP

XWaitVSync PROC FAR

	mov   dx,InputStatus0
@@WaitNotVsync:
	in    al,dx
	test  al,08h
	jnz   @@WaitNotVsync

@@WaitVsync:
	in    al,dx
	test  al,08h
	jz    @@WaitVsync
	ret

XWaitVSync ENDP

XLine PROC FAR x1 : Word, y1 : Word, x2 : Word, y2 : Word, Color : Word,\
							 PgOffs : Word
LOCAL vertincr : Word, incr1 : Word, incr2 : Word, routine : Word

	mov ax,ScreenSeg
	mov es,ax

	mov dx,ScIndex
	mov si,ScrnLogicalByteWidth
	mov cx,x2
	sub cx,x1
	jz  @@VertLine
	jns @@L01

	neg cx

	mov bx,x2
	xchg  bx,x1
	mov x2,bx

	mov bx,y2
	xchg  bx,y1
	mov y2,bx

@@L01:
	mov bx,y2
	sub bx,y1
	jnz @@skip
	jmp @@HorizLine

@@skip:
	jns @@L03
	neg bx
	neg si

@@L03:
	mov vertincr,si
	mov routine,offset @@LoSlopeLine
	cmp bx,cx
	jle @@L04
	mov routine,offset @@HiSlopeLine
	xchg  bx,cx


@@L04:
	shl bx,1
	mov incr1,bx
	sub bx,cx
	mov si,bx
	sub bx,cx
	mov incr2,bx

	push  cx
	mov ax,y1
	mov bx,x1
	mov cl,bl
	push dx
	mov dx,ScrnLogicalByteWidth
	mul dx
	pop dx
	shr bx,2
	add bx,ax
	add bx,PgOffs
	and cl,3
	mov di,bx
	mov al,1
	shl al,cl
	mov ah,al
	shl al,4
	add ah,al
	mov bl,ah
	pop cx
	inc cx
	jmp routine

@@VertLine:
	mov ax,y1
	mov bx,y2
	mov cx,bx
	sub cx,ax
	jge @@L31
	neg cx
	mov ax,bx

@@L31:
	inc cx
	mov bx,x1
	push  cx
	mov cl,bl
	push dx
	mov dx,ScrnLogicalByteWidth
	mul dx
	pop dx
	shr bx,2
	add bx,ax
	add bx,PgOffs
	and cl,3

	mov ah,1
	shl ah,cl
	mov al,MapMask
	out dx,ax
	pop cx
	mov ax, word ptr [Color]

@@L32:
	mov es:[bx],al
	add bx,si
	loop  @@L32
	jmp @@Lexit

@@HorizLine:
	push  ds

	mov ax,y1
	mov bx,x1
	mov cl,bl
	push dx
	mov dx,ScrnLogicalByteWidth
	mul dx
	pop dx
	shr bx,2
	add bx,ax
	add bx,PgOffs
	and cl,3

	mov di,bx
	mov dl,00fh
	shl dl,cl

	mov cx,x2
	and cl,3
	mov dh,00eh
	shl dh,cl
	not dh

	mov ax,x2
	mov bx,x1

	shr ax,2
	shr bx,2
	mov cx,ax
	sub cx,bx

	mov ax,dx
	mov dx,SCINDEX
	mov bx, [Color]
	or  cx,cx
	jnz @@L42
	and ah,al
	jmp @@L44

@@L42:
	push ax
	mov ah,al
	mov al,MAPMASK
	out dx,ax
	mov al,bl
	stosb
	dec cx

@@L43:
	mov ah,0Fh
	mov al,MAPMASK
	out dx,ax
	mov al,bl
	rep stosb
	pop     ax

@@L44:
	mov al,MAPMASK
	out dx, ax
	mov     byte ptr es:[di],bl
	pop ds
	jmp @@Lexit


@@LoSlopeLine:
	mov al,MAPMASK
	mov bh,byte ptr [Color]
@@L10:
	mov ah,bl

@@L11:
	or  ah,bl
	rol bl,1
	jc  @@L14

	or  si,si
	jns @@L12
	add si,incr1
	loop  @@L11

	out dx,ax
	mov es:[di],bh
	jmp @@Lexit

@@L12:
	add si,incr2
	out dx,ax
	mov es:[di],bh
	add di,vertincr
	loop  @@L10
	jmp @@Lexit

@@L14:
	out dx,ax
	mov es:[di],bh
	inc di
	or  si,si
	jns @@L15
	add si,incr1
	loop  @@L10
	jmp @@Lexit

@@L15:
	add si,incr2
	add di,vertincr
	loop  @@L10
	jmp @@Lexit

@@HiSlopeLine:
	mov bx,vertincr
	mov al,MAPMASK
@@L21:
	out dx,ax
	push  ax
	mov ax,Color
	mov es:[di],al
	pop ax
	add di,bx

@@L22:
	or  si,si
	jns @@L23

	add si,incr1
	loop  @@L21
	jmp @@Lexit

@@L23:
	add si,incr2
	rol ah,1
	adc di,0
@@lx21: loop  @@L21


@@Lexit:
	ret

XLine ENDP

XPutPix PROC FAR X : Word, Y : Word, PgOfs : Word, Color : Word

	mov  ax,ScrnLogicalByteWidth
	mul  Y
	mov  bx,X
	shr  bx,2
	add  bx,ax
	add  bx,PgOfs
	mov  ax,SCREENSEG
	mov  es,ax

	mov  cl,byte ptr X
	and  cl,011b
	mov  ax,0100h + MAPMASK
	shl  ah,cl
	mov  dx,SCINDEX
	out  dx,ax
	mov  al,byte ptr Color
	mov  es:[bx],al
	ret

XPutPix ENDP

XGetPix PROC FAR x : Word, y : Word, PageBase : Word

	mov  ax,ScrnLogicalByteWidth
	mul  Y
	mov  bx,X
	shr  bx,1
	shr  bx,1
	add  bx,ax
	add  bx,PageBase
	mov  ax,SCREENSEG
	mov  es,ax
	mov  ah,byte ptr X
	and  ah,011b
	mov  al,READMAP
	mov  dx,GCINDEX
	out  dx,ax
	mov  al,es:[bx]
	sub  ah,ah
	ret

XGetPix ENDP

XRectFill PROC FAR StartX : Word, StartY : Word, EndX : Word, EndY : Word,\
						PageBase : Word, Color : Word

	push bp
	cld
	mov  ax,ScrnLogicalByteWidth
	mul  StartY
	mov  di,StartX
	shr  di,1
	shr  di,1
	add  di,ax
	add  di,PageBase
	mov  ax,SCREENSEG
	mov  es,ax
	mov  dx,SCINDEX
	mov  al,MAPMASK
	out  dx,al
	inc  dx
	mov  si,StartX
	and  si,0003h
	mov  bh,byte ptr LeftClipPlaneMask[si]
	mov  si,EndX
	and  si,0003h
	mov  bl,byte ptr RightClipPlaneMask[si]
	mov  cx,EndX
	mov  si,StartX
	cmp  cx,si
	jle  @@FillDone
	dec  cx
	and  si,not 011b
	sub  cx,si
	shr  cx,1
	shr  cx,1
	jnz  @@MasksSet
	and  bh,bl

@@MasksSet:
	mov  si,EndY
	sub  si,StartY
	jle  @@FillDone
	mov  ah,byte ptr Color
	mov  bp,ScrnLogicalByteWidth
	sub  bp,cx
	dec  bp
@@FillRowsLoop:
	push cx
	mov  al,bh
	out  dx,al
	mov  al,ah
	stosb
	dec  cx
	js   @@FillLoopBottom
	jz   @@DoRightEdge
	mov  al,00fh
	out  dx,al
	mov  al,ah
	rep  stosb
@@DoRightEdge:
	mov  al,bl
	out  dx,al
	mov  al,ah
	stosb
@@FillLoopBottom:
	add  di,bp
	pop  cx
	dec  si
	jnz  @@FillRowsLoop
@@FillDone:
	pop bp
	ret

XRectFill ENDP



XRectPattern PROC FAR StartX : Word, StartY : Word, EndX : Word, EndY : Word,\
											PageBase : Word, Pattern : DWord
LOCAL NextScanOffset : Word, RectAddrWidth : Word, Height : word

	push ds
	cld
	mov  ax,SCREENSEG
	mov  es,ax
	lds  si,Pattern
	mov  di,PATTERNBUFFER
	mov  dx,SCINDEX
	mov  al,MAPMASK
	out  dx,al
	inc  dx
	mov  cx,4
@@DownloadPatternLoop:
	mov  al,1
	out  dx,al
	movsb
	dec  di
	mov  al,2
	out  dx,al
	movsb
	dec  di
	mov  al,4
	out  dx,al
	movsb
	dec  di
	mov  al,8
	out  dx,al
	movsb
	loop @@DownloadPatternLoop
	pop  ds

	mov  dx,GCINDEX
	mov  ax,00000h+BITMASK
	out  dx,ax

	mov  ax,StartY
	mov  si,ax
	and  si,011b
	add  si,PATTERNBUFFER

	mov  dx,ScrnLogicalByteWidth
	mul  dx
	mov  di,StartX
	mov  bx,di
	shr  di,1
	shr  di,1
	add  di,ax
	add  di,PageBase

	and  bx,0003h
	mov  ah,byte ptr LeftClipPlaneMask[bx]
	mov  bx,EndX
	and  bx,0003h
	mov  al,byte ptr RightClipPlaneMask[bx]
	mov  bx,ax

	mov  cx,EndX
	mov  ax,StartX
	cmp  cx,ax
	jle  @@FillDone
	dec  cx
	and  ax,not 011b
	sub  cx,ax
	shr  cx,1
	shr  cx,1
	jnz  @@MasksSet
	and  bh,bl

@@MasksSet:
	mov  ax,EndY
	sub  ax,StartY
	jle  @@FillDone
	mov  Height,ax
	mov  ax,ScrnLogicalByteWidth
	sub  ax,cx
	dec  ax
	mov  NextScanOffset,ax
	mov  RectAddrWidth,cx
	mov  dx,SCINDEX+1

@@FillRowsLoop:
	mov  cx,RectAddrWidth
	mov  al,es:[si]
	inc  si
	jnz  @@NoWrap
	sub  si,4
@@NoWrap:
	mov  al,bh
	out  dx,al
	stosb

	dec  cx
	js   @@FillLoopBottom
	jz   @@DoRightEdge
	mov  al,00fh
	out  dx,al
	rep  stosb

@@DoRightEdge:
	mov  al,bl
	out  dx,al
	stosb

@@FillLoopBottom:
	add  di,NextScanOffset
	dec  word ptr Height
	jnz  @@FillRowsLoop
@@FillDone:
	mov  dx,GCINDEX+1
	mov  al,0ffh
	out  dx,al
	ret

XRectPattern ENDP

XCpVidPage PROC FAR SourceOffs : Word, DestOffs : Word

LOCAL ScreenSize : Word

	push    ds
	cld
	mov     ax, ScrnLogicalByteWidth
	mov     bx, ScrnLogicalHeight
	mul     bx
	mov     ScreenSize, ax
	mov     ax, SCREENSEG
	mov     ds, ax
	mov     es, ax

@@PlaneLoop:

	mov     si, SourceOffs
	mov     di, DestOffs

	mov     ax,BITMASK
	mov     dx,GCINDEX
	out     dx,ax
	mov     dx,SCINDEX+1
	mov     al, 00fh
	out     dx, al

	mov     cx,ScreenSize

	rep     movsb

	mov     dx,GCINDEX+1
	mov     al,0ffh
	out     dx,al
	pop     ds
	ret

XCpVidPage ENDP

XCpVidRect PROC FAR SrcStartX : Word, SrcStartY : Word, SrcEndX : Word,\
										SrcEndY : Word, DestStartX : Word, DestStartY : Word,\
										SrcPageBase : Word, DestPageBase : Word,\
										SrcBitmapW : Word, DestBitmapW : Word
LOCAL SrcNextOffs : Word, DestNextOffs : Word, RectAddrW : Word, Height : Word

	push    ds
	cld
	mov     dx,GCINDEX
	mov     ax,BITMASK
	out     dx,ax
	mov     ax,SCREENSEG
	mov     es,ax
	mov     ax,DestBitmapW
	shr     ax,2
	mul     DestStartY
	mov     di,DestStartX
	shr     di,2
	add     di,ax
	add     di,DestPageBase
	mov     ax,SrcBitmapW
	shr     ax,2
	mul     SrcStartY
	mov     si,SrcStartX
	mov     bx,si
	shr     si,2
	add     si,ax
	add     si,SrcPageBase
	and     bx,0003h
	mov     ah,byte ptr LeftClipPlaneMask[bx]
	mov     bx,SrcEndX
	and     bx,0003h
	mov     al,byte ptr RightClipPlaneMask[bx]
	mov     bx,ax
	mov     cx,SrcEndX
	mov     ax,SrcStartX
	cmp     cx,ax
	jle     @@CopyDone
	dec     cx
	and     ax,not 011b
	sub     cx,ax
	shr     cx,2
	jnz     @@MasksSet
	and     bh,bl
@@MasksSet:
	mov     ax,SrcEndY
	sub     ax,SrcStartY
	jle     @@CopyDone
	mov     Height,ax
	mov     ax,DestBitmapW
	shr     ax,2
	sub     ax,cx
	dec     ax
	mov     DestNextOffs,ax
	mov     ax,SrcBitmapW
	shr     ax,2
	sub     ax,cx
	dec     ax
	mov     SrcNextOffs,ax
	mov     RectAddrW,cx
	mov     dx,SCINDEX+1
	mov     ax,es
	mov     ds,ax
@@CopyRowsLoop:
	mov     cx,RectAddrW
	mov     al,bh
	out     dx,al
	movsb
	dec     cx
	js      @@CopyLoopBottom
	jz      @@DoRightEdge
	mov     al,00fh
	out     dx,al
	rep     movsb
@@DoRightEdge:
	mov     al,bl
	out     dx,al
	movsb
@@CopyLoopBottom:
	add     si,SrcNextOffs
	add     di,DestNextOffs
	dec     word ptr Height
	jnz     @@CopyRowsLoop
@@CopyDone:
	mov     dx,GCINDEX+1
	mov     al,0ffh
	out     dx,al
	pop     ds
	ret

XCpVidRect ENDP

XShiftRect PROC FAR SrcLeft : Word, SrcTop : Word, SrcRight : Word,\
										SrcBottom : Word, DestLeft : Word, DestTop : Word,\
										ScreenOffs : Word
LOCAL widthtemp : Word

	push ds
	mov si, SrcLeft
	shr si, 2

	mov di, DestLeft
	shr di, 2

	mov bx, SrcRight
	add bx, 3
	shr bx, 2
	sub bx, si
	mov ax, bx
	inc bx
	mov widthtemp, bx

	cld

	cmp si, di
	jge @@MovingLeft

	add si, ax
	add di, ax
	neg bx
	std

@@MovingLeft:

	mov cx, ScrnLogicalByteWidth
	mov ax, SrcTop
	mov dx, DestTop
	cmp ax, dx
	jge @@MovingUp

	mov ax, SrcBottom
	add dx, ax
	sub dx, SrcTop
	neg cx

@@MovingUp:
	push dx
	mul ScrnLogicalByteWidth
	add si, ax
	pop ax
	mul ScrnLogicalByteWidth
	add di, ax

	sub cx, bx

	add si, ScreenOffs
	add di, ScreenOffs

	mov dx, SCINDEX
	mov ax, 00f02h
	out dx, ax

	mov dx, GCINDEX
	mov ax, BITMASK
	out dx, ax

	mov ax, SCREENSEG
	mov es, ax
	mov ds, ax

	mov ah, byte ptr widthtemp

	mov bx, SrcBottom
	sub bx, SrcTop

	mov dx, cx

	xor ch, ch

@@LineLoop:
	mov cl, ah
	rep movsb

	add si, dx
	add di, dx

	dec bx
	jge @@LineLoop

	mov dx, GCINDEX + 1
	mov al, 0ffh
	out dx, al
	pop ds
	ret

XShiftRect ENDP

XCircle PROC FAR Left : Word, Top : Word, Diameter : Word, Color : Word,\
								 ScreenOffs : Word
LOCAL offset0 : Word, offset1 : Word, offset2 : Word, offset3 : Word,\
			offset4 : Word, offset5 : Word, offset6 : Word, offset7 : Word,\
			mask0n1 : Word, mask2n3 : Word, mask4n5 : Word, mask6n7 : Word,\
			shrunkradius : Word, diametereven : Word, Aerror : Word

	push ds
	mov di, ScrnLogicalByteWidth
	xor dx, dx
	mov ax, Diameter
	dec ax
	shr ax, 1
	adc dx, 0
	mov shrunkradius, ax
	mov diametereven, dx
	add ax, Top
	mul di
	add ax, ScreenOffs

	mov bx, Left
	mov cx, bx
	mov si, bx
	shr si, 2
	add si, ax
	mov offset6, si
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask6n7, bx

	add cx, Diameter
	dec cx
	mov bx, cx
	shr cx, 2
	add cx, ax
	mov offset2, cx
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask2n3, bx

	cmp diametereven, 1
	jne @@MiddlePlotsOverlap
	add si, di
	add cx, di
@@MiddlePlotsOverlap:
	mov offset7, si
	mov offset3, cx

	mov bx, Left
	add bx, shrunkradius

	mov ax, Top
	mul di
	add ax, ScreenOffs
	mov si, ax

	mov ax, Diameter
	dec ax
	mul di
	add ax, si

	mov di, bx
	shr di, 2
	add si, di
	mov offset4, si
	add di, ax
	mov offset5, di
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask4n5, bx

	cmp diametereven, 1
	jne @@TopAndBottomPlotsOverlap
	rol bl, 1
	jnc @@TopAndBottomPlotsOverlap
	inc si
	inc di
@@TopAndBottomPlotsOverlap:
	mov offset0, si
	mov offset1, di
	mov mask0n1, bx
	mov bx, ScrnLogicalByteWidth

	mov dx, SCREENSEG
	mov ds, dx

	mov dx, SCINDEX
	mov al, MAPMASK
	out dx, al
	inc dx

	mov si, Diameter
	inc si

	mov cx, si
	neg cx
	add cx, 2
	mov Aerror, cx

	xor cx, cx
	mov ah, byte ptr Color
	jmp @@CircleCalc

@@NoAdvance:
	mov al, byte ptr mask0n1
	out dx, al
	mov di, offset0
	mov [di], ah
	rol al, 1
	mov byte ptr mask0n1, al
	adc di, 0
	mov offset0, di
	mov di, offset1
	mov [di], ah
	ror al, 1
	adc di, 0
	mov offset1, di

	mov al, byte ptr mask2n3
	out dx, al
	mov di, offset2
	mov [di], ah
	sub di, bx
	mov offset2, di
	mov di, offset3
	mov [di], ah
	add di, bx
	mov offset3, di

	mov al, byte ptr mask4n5
	out dx, al
	mov di, offset4
	mov [di], ah
	ror al, 1
	mov byte ptr mask4n5, al
	sbb di, 0
	mov offset4, di
	mov di, offset5
	mov [di], ah
	rol al, 1
	sbb di, 0
	mov offset5, di

	mov al, byte ptr mask6n7
	out dx, al
	mov di, offset6
	mov [di], ah
	sub di, bx
	mov offset6, di
	mov di, offset7
	mov [di], ah
	add di, bx
	mov offset7, di

	jmp @@CircleCalc

@@Advance:
	mov al, byte ptr mask0n1
	out dx, al
	mov di, offset0
	mov [di], ah
	rol al, 1
	mov byte ptr mask0n1, al
	adc di, bx
	mov offset0, di
	mov di, offset1
	mov [di], ah
	ror al, 1
	adc di, 0
	sub di, bx
	mov offset1, di

	mov al, byte ptr mask2n3
	out dx, al
	mov di, offset2
	mov [di], ah
	ror al, 1
	mov byte ptr mask2n3, al
	sbb di, bx
	mov offset2, di
	mov di, offset3
	mov [di], ah
	rol al, 1
	sbb di, 0
	add di, bx
	mov offset3, di

	mov al, byte ptr mask4n5
	out dx, al
	mov di, offset4
	mov [di], ah
	ror al, 1
	mov byte ptr mask4n5, al
	sbb di, 0
	add di, bx
	mov offset4, di
	mov di, offset5
	mov [di], ah
	rol al, 1
	sbb di, bx
	mov offset5, di

	mov al, byte ptr mask6n7
	out dx, al
	mov di, offset6
	mov [di], ah
	rol al, 1
	mov byte ptr mask6n7, al
	adc di, 0
	sub di, bx
	mov offset6, di
	mov di, offset7
	mov [di], ah
	ror al, 1
	adc di, bx
	mov offset7, di

@@CircleCalc:
	add cx, 2
	mov di, Aerror
	add di, cx
	inc di
	jl @@CircleNoError
	cmp cx, si
	ja @@FleeFlyFlowFum
	sub si, 2
	sub di, si
	mov Aerror, di
	jmp @@Advance
@@CircleNoError:
	mov Aerror, di
	jmp @@NoAdvance

@@FleeFlyFlowFum:
	pop ds
	ret

XCircle ENDP

XFilledCircle PROC FAR Left : Word, Top : Word, Diameter : Word,\
											 Color : Word, ScreenOffs : Word
LOCAL offset0 : Word, offset1 : Word, offset2 : Word, offset3 : Word,\
			offset4 : Word, offset5 : Word, offset6 : Word, offset7 : Word,\
			mask0n1 : Word, mask2n3 : Word, mask4n5 : Word, mask6n7 : Word,\
			shrunkradius : Word, diametereven : Word, Aerror : Word,\
			jumpvector : Word

	cld
	mov di, ScrnLogicalByteWidth
	xor dx, dx
	mov ax, Diameter
	dec ax
	shr ax, 1
	adc dx, 0
	mov shrunkradius, ax
	mov diametereven, dx
	add ax, Top
	mul di
	add ax, ScreenOffs

	mov bx, Left
	mov cx, bx
	mov si, bx
	shr si, 2
	add si, ax
	mov offset6, si
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask6n7, bx

	add cx, Diameter
	dec cx
	mov bx, cx
	shr cx, 2
	add cx, ax
	mov offset2, cx
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask2n3, bx

	cmp diametereven, 1
	jne @@MiddlePlotsOverlap
	add si, di
	add cx, di
@@MiddlePlotsOverlap:
	mov offset7, si
	mov offset3, cx

	mov bx, Left
	add bx, shrunkradius

	mov ax, Top
	mul di
	add ax, ScreenOffs
	mov si, ax

	mov ax, Diameter
	dec ax
	mul di
	add ax, si

	mov di, bx
	shr di, 2
	add si, di
	mov offset4, si
	add di, ax
	mov offset5, di
	and bx, 3
	mov bl, byte ptr ColumnMask[bx]
	mov mask4n5, bx

	cmp diametereven, 1
	jne @@TopAndBottomPlotsOverlap
	rol bl, 1
	jnc @@TopAndBottomPlotsOverlap
	inc si
	inc di
@@TopAndBottomPlotsOverlap:
	mov offset0, si
	mov offset1, di
	mov mask0n1, bx

	mov bx, ScrnLogicalByteWidth

	mov dx, SCREENSEG
	mov es, dx

	mov dx, SCINDEX
	mov al, MAPMASK
	out dx, al
	inc dx
	mov si, Diameter
	inc si

	mov cx, si
	neg cx
	add cx, 2
	mov Aerror, cx
	xor cx, cx
	mov ah, byte ptr Color
	jmp @@FilledCircleCalc
@@PlotLines:
	push cx

	mov di, mask0n1
	and di, 0000fh
	mov al, byte ptr RightMaskTable[di]
	mov di, offset0
	cmp di, offset4
	jne @@PlotXMajorNontrivial
	mov di, mask4n5
	and di, 0000fh
	and al, byte ptr LeftMaskTable[di]
	out dx, al
	mov di, offset4
	mov es:[di], ah
	mov di, offset5
	mov es:[di], ah
	jmp @@PlotYMajor
@@PlotXMajorNontrivial:
	out dx, al
	mov es:[di], ah
	mov di, offset1
	mov es:[di], ah

	mov di, mask4n5
	and di, 0000fh
	mov al, byte ptr LeftMaskTable[di]
	out dx, al
	mov di, offset4
	mov es:[di], ah
	mov di, offset5
	mov es:[di], ah

	mov al, 0ffh
	out dx, al
	mov al, ah
	inc di
	mov cx, offset1
	sub cx, di
	push cx
	shr cx, 1
	rep stosw
	adc cx, 0
	rep stosb

	mov di, offset4
	inc di
	pop cx
	shr cx, 1
	rep stosw
	adc cx, 0
	rep stosb

@@PlotYMajor:
	mov di, mask2n3
	and di, 0000fh
	mov al, byte ptr RightMaskTable[di]
	mov di, offset2
	cmp di, offset6
	jne @@PlotYMajorNontrivial
	mov di, mask6n7
	and di, 0000fh
	and al, byte ptr LeftMaskTable[di]
	out dx, al
	mov di, offset6
	mov es:[di], ah
	mov di, offset7
	mov es:[di], ah
	jmp @@ClimaxOfPlot
@@PlotYMajorNontrivial:
	out dx, al
	mov es:[di], ah
	mov di, offset3
	mov es:[di], ah

	mov di, mask6n7
	and di, 0000fh
	mov al, byte ptr LeftMaskTable[di]
	out dx, al
	mov di, offset6
	mov es:[di], ah
	mov di, offset7
	mov es:[di], ah

	mov al, 0ffh
	out dx, al
	mov al, ah

	inc di
	mov cx, offset3
	sub cx, di
	push cx
	shr cx, 1
	rep stosw
	adc cx, 0
	rep stosb

	mov di, offset6
	inc di
	pop cx
	shr cx, 1
	rep stosw
	adc cx, 0
	rep stosb

@@ClimaxOfPlot:
	pop cx
	jmp [jumpvector]


@@NoAdvance:
	mov al, byte ptr mask0n1
	mov di, offset0
	rol al, 1
	mov byte ptr mask0n1, al
	adc di, 0
	mov offset0, di
	mov di, offset1
	ror al, 1
	adc di, 0
	mov offset1, di

	mov al, byte ptr mask4n5
	mov di, offset4
	ror al, 1
	mov byte ptr mask4n5, al
	sbb di, 0
	mov offset4, di
	mov di, offset5
	rol al, 1
	sbb di, 0
	mov offset5, di

	mov al, byte ptr mask2n3
	mov di, offset2
	sub di, bx
	mov offset2, di
	mov di, offset3
	add di, bx
	mov offset3, di

	mov al, byte ptr mask6n7
	mov di, offset6
	sub di, bx
	mov offset6, di
	mov di, offset7
	add di, bx
	mov offset7, di

	jmp @@FilledCircleCalc

@@Advance:
	mov al, byte ptr mask0n1
	mov di, offset0
	rol al, 1
	mov byte ptr mask0n1, al
	adc di, bx
	mov offset0, di
	mov di, offset1
	ror al, 1
	adc di, 0
	sub di, bx
	mov offset1, di

	mov al, byte ptr mask2n3
	mov di, offset2
	ror al, 1
	mov byte ptr mask2n3, al
	sbb di, bx
	mov offset2, di
	mov di, offset3
	rol al, 1
	sbb di, 0
	add di, bx
	mov offset3, di

	mov al, byte ptr mask4n5
	mov di, offset4
	ror al, 1
	mov byte ptr mask4n5, al
	sbb di, 0
	add di, bx
	mov offset4, di
	mov di, offset5
	rol al, 1
	sbb di, bx
	mov offset5, di

	mov al, byte ptr mask6n7
	mov di, offset6
	rol al, 1
	mov byte ptr mask6n7, al
	adc di, 0
	sub di, bx
	mov offset6, di
	mov di, offset7
	ror al, 1
	adc di, bx
	mov offset7, di

@@FilledCircleCalc:
	add cx, 2
	mov di, Aerror
	add di, cx
	inc di
	jl @@FilledCircleNoError
	cmp cx, si
	ja @@FleeFlyFlowFum
	sub si, 2
	sub di, si
	mov Aerror, di
	mov jumpvector, offset @@Advance
	jmp @@PlotLines
@@FilledCircleNoError:
	mov Aerror, di
	mov jumpvector, offset @@NoAdvance
	jmp @@PlotLines

@@FleeFlyFlowFum:
	ret

XFilledCircle ENDP

XGetPalStruc PROC FAR PalBuff : DWord, NumColors : Word, StartColor : Word

	cld
	les  di,PalBuff
	mov  si,StartColor
	mov  ax,si
	stosb
	mov  dx,NumColors
	mov  al,dl
	stosb
	mov  cx,dx
	cld
	cmp  VSyncHandlerActive,1
	je   @@HandleVVH
	mov  dx,INPUTSTATUS0
@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync
@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	jmp  short @@SkipVSync
@@HandleVVH:
	cmp  StartAddressFlag,0
	jne  @@HandleVVH
@@SkipVSync:
	mov  ax, si
	mov  dx, DACREADINDEX
	cli
	out  dx, al
	mov  dx, DACDATA
	mov  bx, cx
	shl  bx, 1
	add  cx, bx
	rep  insb
	sti
	ret

XGetPalStruc ENDP

XGetPalRaw PROC FAR PalBuff : DWord, NumColors : Word, StartColor : Word

	les  di,PalBuff
	mov  si,StartColor
	mov  cx,NumColors
@@ReadPalEntry:
	cld
	cmp  VSyncHandlerActive,1
	je   @@HandleVVH
	mov  dx,INPUTSTATUS0
@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync
@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	jmp  short @@SkipVSync
@@HandleVVH:
	cmp  StartAddressFlag,0
	jne  @@HandleVVH
@@SkipVSync:

	mov  ax,si
	mov  dx,DACREADINDEX
	cli
	out  dx,al
	mov  dx,DACDATA
	mov  bx,cx
	shl  bx,1
	add  cx,bx
	rep  insb
	sti
	ret

XGetPalRaw ENDP


XPutPalStruc PROC FAR CompPalBuff : DWord

	push ds
	cld
	lds  si,CompPalBuff
	lodsb
	mov  ah,0
	mov  bx,ax
	lodsb
	mov  ah,0
	mov  cx,ax

	mov  ax, @data
	mov  es, ax
	cmp  es:[VSyncHandlerActive], TRUE
	jne  @@NoVSyncHandler

@@WaitForLast:
	cmp  es:[VsyncPaletteCount],0
	jne  @@WaitForLast
	push cx
	push es
	mov  di, offset VsyncPaletteBuffer
	mov  ax,3
	mul  cx
	mov  cx,ax
	rep  movsb
	pop  ds
	pop  cx
	mov  VsyncPaletteStart,bx
	mov  VsyncPaletteCount,cx
	jmp  short @@Done

@@NoVsyncHandler:
	or   cx,cx
	jz   @@Done
	;cli
	cld
	mov  dx,INPUTSTATUS0
@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync
@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync

	;new stuff
	mov  ax,3
	mul  cx
	mov  cx,ax
	;end new stuff

	mov  ax,bx
	mov  bx,60
@@SetLoop:
	mov  dx,DACWRITEINDEX
	out  dx,al
	mov  dx,DACDATA

	rep outsb

;	outsb
;	outsb
;	outsb
;	inc  al
;	dec  bx
;	js   @@testvsync
;	loop @@SetLoop
	jmp  @@Done
@@testvsync:
	mov     dx,INPUTSTATUS0
	push    ax
@@Wait:
	in      al,dx
	test    al,08h
	jz      @@Wait
	pop     ax
	mov     bx,60
	loop @@SetLoop
@@Done:
	sti
	pop  ds
	ret

XPutPalStruc ENDP

XTransposePalStruc PROC FAR CompPalBuff : DWord, StartColor : Word

	push ds
	cld
	lds  si,CompPalBuff
	mov  bx,StartColor
	mov  [si],bl
	inc  si
	lodsb
	mov  ah,0
	mov cx,ax

	mov  ax, @data
	mov  es, ax
	cmp  es:[VSyncHandlerActive], TRUE
	jne  @@NoVSyncHandler

@@WaitForLast:
	cmp  es:[VsyncPaletteCount],0
	jne  @@WaitForLast
	push cx
	push es
	mov  di, offset VsyncPaletteBuffer
	mov  ax,3
	mul  cx
	mov  cx,ax
	rep  movsb
	pop  ds
	pop  cx
	mov  VsyncPaletteStart,bx
	mov  VsyncPaletteCount,cx
	jmp  short @@Done

@@NoVsyncHandler:
	or   cx,cx
	jz   @@Done
	;cli
	cld
	mov  dx,INPUTSTATUS0
@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync
@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync
	mov  ax,bx
	mov  bx,60
@@SetLoop:
	mov  dx,DACWRITEINDEX
	out  dx,al
	mov  dx,DACDATA
	outsb
	outsb
	outsb
	inc  al
;	dec  bx
;	js   @@testvsync
	loop @@SetLoop
	jmp  @@Done
@@testvsync:
	mov     dx,INPUTSTATUS0
	push    ax
@@Wait:
	in      al,dx
	test    al,08h
	jz      @@Wait
	pop     ax
	mov     bx,60
	loop @@SetLoop
@@Done:
	sti
	pop  ds
	ret

XTransposePalStruc ENDP


XPutPalRaw PROC FAR PalBuff : DWord, NumColors : Word, StartColor : Word

	push ds
	mov  cx,NumColors
	mov  bx,StartColor
	lds  si,PalBuff

@@WritePalEntry:
	mov  ax, @data
	mov  es, ax
	cmp  es:[VSyncHandlerActive], TRUE
	jne  @@NoVSyncHandler

@@WaitForLast:
	cmp  es:[VsyncPaletteCount],0
	jne  @@WaitForLast
	push cx
	push es
	mov  di, offset VsyncPaletteBuffer
	mov  ax,3
	mul  cx
	mov  cx,ax
	rep  movsb
	pop  ds
	pop  cx
	mov  VsyncPaletteStart,bx
	mov  VsyncPaletteCount,cx
	jmp  short @@Done

@@NoVsyncHandler:
	or   cx,cx
	jz   @@Done
	cld
	mov  dx,INPUTSTATUS0
@@WaitNotVsync:
	in   al,dx
	test al,08h
	jnz  @@WaitNotVsync
@@WaitVsync:
	in   al,dx
	test al,08h
	jz   @@WaitVsync

	;new stuff
	mov  ax,3
	mul  cx
	mov  cx,ax
	;end new stuff

	mov  ax,bx
	mov  bx,60
@@SetLoop:
	mov  dx,DACWRITEINDEX
	out  dx,al
	mov  dx,DACDATA

	rep outsb

;	outsb
;	outsb
;	outsb
;	inc  al
;	dec  bx
;	js   @@testvsync
;	loop @@SetLoop
	jmp  @@Done
@@testvsync:
	mov     dx,INPUTSTATUS0
	push    ax
@@Wait:
	in      al,dx
	test    al,08h
	jz      @@Wait
	pop     ax
	mov     bx,60
	loop @@SetLoop
@@Done:
	pop  ds
	ret

XPutPalRaw ENDP


XSetRGB PROC FAR ColorIndex : Byte, R : Byte, G : Byte, B : Byte

	mov  al,ColorIndex
	mov  dx,DACWRITEINDEX
	out  dx,al
	mov  dx,DACDATA
	mov  al,R
	out  dx,al
	mov  al,G
	out  dx,al
	mov  al,B
	out  dx,al
	ret

XSetRGB ENDP

XRotPalStruc PROC FAR PalBuff : DWord, Direction : Word

	push ds
	cld
	lds  si,PalBuff
	lodsw
	xor  ch,ch
	mov  cl,ah
	mov  ax,ds
	mov  es,ax
	dec  cx
	mov  bx,cx
	shl  bx,1
	add  cx,bx
	cmp  Direction,0
	jne  @@forward
	std
	add  si,cx
	add  si,2
@@forward:
	mov  ax,si
	mov  di,ax
	lodsb
	mov  dl,al
	lodsb
	mov  dh,al
	lodsb
	mov  bl,al
	rep  movsb
	mov  al,dl
	stosb
	mov  al,dh
	stosb
	mov  al,bl
	stosb
	pop  ds
	ret

XRotPalStruc ENDP

XRotPalRaw PROC FAR PalBuff : DWord, Direction : Word, NumColors : Word

	push ds
	cld
	mov  cx,NumColors
	lds  si,PalBuff
@@RotatePalEntry:
	mov  ax,ds
	mov  es,ax
	dec  cx
	mov  bx,cx
	shl  bx,1
	add  cx,bx
	cmp  Direction,0
	jne  @@forward
	std
	add  si,cx
	add  si,2
@@forward:
	mov  ax,si
	mov  di,ax
	lodsb
	mov  dl,al
	lodsb
	mov  dh,al
	lodsb
	mov  bl,al
	rep  movsb
	mov  al,dl
	stosb
	mov  al,dh
	stosb
	mov  al,bl
	stosb
	pop  ds
	ret

XRotPalRaw ENDP

XCpContrastPalStruc PROC FAR PalSrcBuff : DWord, PalDestBuff : DWord,\
														 Intensity : Byte

	push ds
	cld
	mov  bh,0ffh
	sub  bh,Intensity
	and  bh,07fh
	lds  si,PalSrcBuff
	les  di,PalDestBuff
	lodsw
	stosw
	xor  ch,ch
	mov  cl,ah
	mov  dx,0
@@MainLoop:
	lodsw
	sub  al,bh
	jns  @@DecrementOKR
	xor  al,al
@@DecrementOKR:
	sub  ah,bh
	jns  @@DecrementOKG
	xor  ah,ah
@@DecrementOKG:
	or   dx,ax
	or   dl,ah
	stosw
	lodsb
	sub  al,bh
	jns  @@DecrementOKB
	xor  al,al
@@DecrementOKB:
	or   dl,al
	stosb
	loop @@MainLoop
	mov  ax,dx
	pop  ds
	ret

XCpContrastPalStruc ENDP


XPutContrastPalStruc PROC FAR CompPalBuff : DWord, Intensity : Byte

	push    ds
	cld
	mov     bh,0ffh
	sub     bh,Intensity
	and     bh,07fh
	mov     di,40
	lds     si,CompPalBuff
	lodsb
	mov     bl,al
	lodsb
	mov     ah,0
	mov     cx,ax
	or      cx,cx
	jz      @@Done

	mov     dx,INPUTSTATUS0
@@WaitNotVsync:
	in      al,dx
	test    al,08h
	jnz     @@WaitNotVsync
@@WaitVsync:
	in      al,dx
	test    al,08h
	jz      @@WaitVsync

@@MainLoop:
	mov  al,bl
	mov  dx,DACWRITEINDEX
	out  dx,al
	inc  dx
	lodsb
	sub  al,bh
	jns  @@DecrementOKR
	xor  al,al
@@DecrementOKR:
	out  dx,al

	lodsb
	sub  al,bh
	jns  @@DecrementOKG
	xor  al,al
@@DecrementOKG:
	out  dx,al

	lodsb
	sub  al,bh
	jns  @@DecrementOKB
	xor  al,al
@@DecrementOKB:
	out  dx,al

	inc  bl
	dec  di
	js   @@testvsync
	loop @@MainLoop
	jmp  @@Done


@@testvsync:
	mov     dx,INPUTSTATUS0
	push    ax
@@Wait:
	in      al,dx
	test    al,08h
	jz      @@Wait
	pop     ax
	mov     di,40
	loop    @@MainLoop
@@Done:
	;sti
	pop  ds
	ret

XPutContrastPalStruc ENDP

XTextInit PROC FAR

	push bp
	mov  FontDriverActive,1
	mov  ax,1130h
	push ax
	mov  bh,3
	int  10h
	mov  word ptr F8x8Ptr,bp
IFDEF _DPMI_
	mov  ax, __C000H
	mov  es, ax
ENDIF
	mov  word ptr F8x8Ptr+2,es

	mov  word ptr FontPtr,bp
	mov  word ptr FontPtr+2,es

	pop  ax
	mov  bh,2
	int  10h
	mov  word ptr F8x14Ptr,bp
IFDEF _DPMI_
	mov  ax, __C000H
	mov  es, ax
ENDIF
	mov  word ptr F8x14Ptr+2,es


	mov  al,8
	mov  CharHeight,al
	mov  CharWidth ,al

	mov  dx,offset MirrorTable
	mov  MirrorTableOffs,dx
	pop  bp
	ret

XTextInit ENDP


XSetFont PROC FAR FontID : Word

	xor  dx,dx
	mov  cx,FontID
	cmp  cx,2

	jne  @@notuserfont
	mov  ax,word ptr UserFontPtr
	mov  word ptr FontPtr,ax

	mov  ax,word ptr UserFontPtr+2
	mov  word ptr FontPtr+2,ax

	mov  al,UserChHeight
	mov  CharHeight,al

	mov  al,UserChWidth
	mov  CharWidth,al

	mov  al,UserFirstCh
	mov  FirstChar,al
	jmp  @@done

@@notuserfont:

	mov  dx,offset MirrorTable
	mov  CharWidth,8
	mov  FirstChar,0
	cmp  cx,1
	jne  @@not8x14font

	mov  ax,word ptr F8x14Ptr
	mov  word ptr FontPtr,ax

	mov  ax,word ptr F8x14Ptr+2
	mov  word ptr FontPtr+2,ax

	mov  CharHeight,14
	jmp  @@done

@@not8x14font:
	mov  ax,word ptr F8x8Ptr
	mov  word ptr FontPtr,ax

	mov  ax,word ptr F8x8Ptr+2
	mov  word ptr FontPtr+2,ax

	mov  CharHeight,8

@@done:
	mov  MirrorTableOffs,dx
	ret

XSetFont ENDP

XRegisterUserFont PROC FAR FontToRegister : DWord

	mov  ax,word ptr FontToRegister
	mov  bx,word ptr FontToRegister+2
	add  ax,4
	mov  word ptr UserFontPtr,ax
	mov  word ptr UserFontPtr+2,bx

	push ds
	lds  si,FontToRegister
	lodsw
	mov  bx,ax
	lodsw
	pop  ds
	mov  UserChHeight,al
	mov  UserChWidth,ah
	mov  UserFirstCh,bl
	ret

XRegisterUserFont ENDP

XGetCharWidth PROC FAR ACh : Byte

	xor  ah,ah
	mov  al,CharWidth
	or   al,al
	jz   @@NotFixed
	jmp  @@Done

@@NotFixed:
	push si
	mov  al,CharHeight
	mov  bx,ax
	inc  al
	mov  dl, ACh
	sub  dl,FirstChar
	mul  dl
	add  ax,bx
	les  si,dword ptr FontPtr
	add  si,ax
	xor  ah,ah
	mov  al,byte ptr es:[si]
@@Done:
	ret

XGetCharWidth ENDP

XCharPut PROC FAR Chr : Byte, X : Word, Y : Word, ScrnOffs : Word, Color : Word
LOCAL ScreenInc : Word, Hold : Word

	push ds
	cld
	mov  ax,ScrnLogicalByteWidth
	mov  bx,ax
	sub  bx,3
	mov  ScreenInc,bx
	mul  Y
	mov  di,X
	mov  cx,di
	shr  di,2
	add  di,ax
	add  di,ScrnOffs

	mov  ax,SCREENSEG
	mov  es,ax

	and  cx,3

	mov  bx,MirrorTableOffs
	mov  al,CharHeight
	xor  ah,ah
	mov  ch,al

	cmp  CharWidth,0
	jne  @@NoWidthByte
	inc  al

@@NoWidthByte:
	mov  dl,Chr
	sub  dl,FirstChar
	mul  dl
	lds  si,dword ptr FontPtr
	add  si,ax

	mov  dx,SCINDEX

@@MainLoop:

	lodsb
	or   al,al
	jz   @@NoCharPixels

	or   bx,bx
	jz   @@DontMirror
	push ds
	mov  dx,seg @data
	mov  ds,dx
	xlat
	pop  ds
	mov  dx,SCINDEX

@@DontMirror:
	xor  ah,ah
	shl  ax,cl
	mov  Hold,ax

	mov  ah,al
	and  ah,0fh
	jnz  @@p1
	inc  di
	jmp  @@SecondNibble

@@p1:
	mov  al,MAPMASK
	out  dx,ax
	mov  al,byte ptr Color
	stosb

@@SecondNibble:
	mov  ax,Hold
	shl  ax,4
	and  ah,0fh
	jnz  @@p2
	inc  di
	jmp  @@ThirdNibble

@@p2:
	mov  al,MAPMASK
	out  dx,ax
	mov  al,byte ptr Color
	stosb

@@ThirdNibble:
	mov  ax,Hold
	and  ah,0fh
	jnz  @@p3
	inc  di
	jmp  @@NextCharRow

@@p3:
	mov  al,MAPMASK
	out  dx,ax
	mov  al,byte ptr Color
	stosb

@@NextCharRow:
	add  di,ScreenInc
	dec  ch
	jnz  @@MainLoop

@@done:
	pop  es
	mov  ah,0
	mov  al,es:CharWidth
	or   al,al
	jnz  @@FixedSpacing
	lodsb
@@FixedSpacing:

	mov  bx,es
	mov  ds,bx
	jmp @@TheEnd


@@NoCharPixels:
	add  di,3
	add  di,ScreenInc
	dec  ch
	jnz  @@MainLoop
	jmp  @@done

@@TheEnd:
	ret
XCharPut ENDP

HLineClipR PROC NEAR

	push    di
	cmp     dx,ax
	jl      @@Invisible

	cmp     cx,TopClip
	jl      @@Invisible

	cmp     cx,BottomClip
	jg      @@Invisible

	mov     di,RightClip
	sal     di,2
	cmp     ax,di
	jg      @@Invisible
	cmp     dx,di
	jle     @@ClipLeft
	mov     dx,di

@@ClipLeft:
	mov     di,LeftClip
	sal     di,2
	cmp     dx,di
	jl      @@Invisible
	cmp     ax,di
	jge     @@DoLine
	mov     ax,di
	jmp     @@DoLine

@@Invisible:
	pop     di
	ret

@@DoLine:
	pop     di
	xchg    cx,ax
	mov     si,dx
	mul     ScrnLogicalByteWidth
	mov     dx,si
	add     ax,di
	mov     di,cx
	sar     di,2
	add     di,ax
	and     si,03h
	mov     ah,byte ptr RightClipPlaneMask[si]
	mov     si,cx
	and     si,03h
	mov     al,byte ptr LeftClipPlaneMask[si]
	cmp     dx,cx
	jle     @@Invisible2
	xchg    cx,dx
	dec     cx
	and     dx,not 03h
	sub     cx,dx
	js      @@Invisible2
	shr     cx,2
	jnz     @@MasksSet
	and     al,ah
@@MasksSet:
	mov     dl,bl
	mov     bx,ax
	mov     ah,dl
	mov     dx,SCINDEX+1
	mov     al,bl
	out     dx,al
	mov     al,ah
	stosb
	dec     cx
	js      @@Invisible2
	jz      @@RightEnd
	mov     al,0fh
	out     dx,al
	mov     al,ah
	shr     cx,1
	rep     stosw
	adc     cx,cx
	rep     stosb

@@RightEnd:
	mov     al,bh
	out     dx,al
	mov     al,ah
	stosb
@@Invisible2:
	ret

HLineClipR ENDP

XTriangle PROC FAR X0, Y0, X1, Y1, X2, Y2, Color, PageOffset : Word
LOCAL DX01, DY01, DX02, DY02, DX12, DY12, DP01, DP02, DP12, XA01, XA02, XA12 : Word

	push    di
	push    es
	push    ds
	mov     ax,X0
	mov     bx,Y0
	mov     cx,X1
	mov     dx,Y1
	cmp     bx,dx
	jl      @@triY0lY1
	je      @@triY0eY1
	xchg    ax,cx
	xchg    bx,dx

@@triY0lY1:
	cmp     dx,Y2
	jg      @@tria
	jmp     @@trisorted
@@tria:
	xchg    cx,X2
	xchg    dx,Y2
	cmp     bx,dx
	jge     @@trib
	jmp     @@trisorted
@@trib:
	je      @@tribot
	xchg    ax,cx
	xchg    bx,dx
	jmp     @@trisorted
@@triY0eY1:
	cmp     bx,Y2
	jl      @@tribot
	jg      @@tric
	jmp     @@tridone
@@tric:
	xchg    ax,X2
	xchg    bx,Y2
	jmp     @@trisorted

@@tribot:
	cmp     ax,cx
	jl      @@tribotsorted
	jg      @@tribota
	jmp     @@tridone
@@tribota:
	xchg    ax,cx
@@tribotsorted:
	cmp     bx,BottomClip
	jle     @@triboty0ok
	jmp     @@tridone
@@triboty0ok:
	mov     si,Y2
	cmp     si,TopClip
	jge     @@triboty2ok
	jmp     @@tridone
@@triboty2ok:
	mov     X0,ax
	mov     Y0,bx
	mov     X1,cx
	mov     Y1,dx

	mov     bx,Y2
	sub     bx,Y0
	mov     DY02,bx
	mov     ax,X2
	sub     ax,X0
	mov     DX02,ax
	mov     cx,ax
	cwd
	idiv    bx
	cmp     cx,0
	jge     @@tribot02
	dec     ax
@@tribot02:
	mov     XA02,ax
	imul    bx
	sub     cx,ax
	mov     DP02,cx

	mov     bx,Y2
	sub     bx,Y1
	mov     DY12,bx
	mov     ax,X2
	sub     ax,X1
	mov     DX12,ax
	mov     cx,ax
	cwd
	idiv    bx
	cmp     cx,0
	jge     @@tribot12
	dec     ax
@@tribot12:
	mov     XA12,ax
	imul    bx
	sub     cx,ax
	mov     DP12,cx

	mov     ax,0
	mov     bx,0
	mov     cx,Y0
	mov     si,X0
	mov     di,X1
	dec     di
@@tribotloop:
	inc     cx

	add     ax,DP02
	jle     @@tribotshortl
	sub     ax,DY02
	inc     si
@@tribotshortl:
	add     si,XA02

	add     bx,DP12
	jle     @@tribotshortr
	sub     bx,DY12
	inc     di
@@tribotshortr:
	add     di,XA12

	push    di
	push    si
	cmp     cx,Y2
	jl      @@tribotloop

	jmp     @@tridrawlines


@@trisorted:
	cmp     bx,BottomClip
	jle     @@triy0ok
	jmp     @@tridone
@@triy0ok:
	mov     si,Y2
	cmp     si,TopClip
	jge     @@triy2ok
	jmp     @@tridone
@@triy2ok:
	mov     X0,ax
	mov     Y0,bx
	mov     X1,cx
	mov     Y1,dx

	mov     bx,dx
	sub     bx,Y0
	mov     DY01,bx
	mov     ax,X1
	sub     ax,X0
	mov     DX01,ax
	mov     cx,ax
	cwd
	idiv    bx
	cmp     cx,0
	jge     @@tripsl01
	dec     ax
@@tripsl01:
	mov     XA01,ax
	imul    bx
	sub     cx,ax
	mov     DP01,cx

	mov     bx,Y2
	sub     bx,Y0
	mov     DY02,bx
	mov     ax,X2
	sub     ax,X0
	mov     DX02,ax
	mov     cx,ax
	cwd
	idiv    bx
	cmp     cx,0
	jge     @@tripsl02
	dec     ax
@@tripsl02:
	mov     XA02,ax
	imul    bx
	sub     cx,ax
	mov     DP02,cx

	mov     bx,Y2
	sub     bx,Y1
	jle     @@triconstcomputed
	mov     DY12,bx
	mov     ax,X2
	sub     ax,X1
	mov     DX12,ax
	mov     cx,ax
	cwd
	idiv    bx
	cmp     cx,0
	jge     @@tripsl12
	dec     ax
@@tripsl12:
	mov     XA12,ax
	imul    bx
	sub     cx,ax
	mov     DP12,cx

@@triconstcomputed:
	mov     ax,DX01
	imul    word ptr DY02
	mov     bx,ax
	mov     cx,dx

	mov     ax,DX02
	imul    word ptr DY01
	cmp     cx,dx
	jg      @@tript1rt
	jl      @@tript1lt
	cmp     bx,ax
	ja      @@tript1rt
	jb      @@tript1lt
	jmp     @@tridone

@@tript1lt:
	mov     ax,0
	mov     bx,0
	mov     cx,Y0
	mov     si,X0
	mov     di,si
	dec     si
@@triltloop:
	inc     cx

	add     ax,DP02
	jle     @@triltshortl
	sub     ax,DY02
	inc     si
@@triltshortl:
	add     si,XA02
	add     bx,DP01
	jle     @@triltshortr
	sub     bx,DY01
	inc     di
@@triltshortr:
	add     di,XA01
	push    si
	push    di
	cmp     cx,Y1
	jl      @@triltloop
	jmp     @@trilbstart
@@trilbloop:
	inc     cx
	add     ax,DP02
	jle     @@trilbshortl
	sub     ax,DY02
	inc     si
@@trilbshortl:
	add     si,XA02

	add     bx,DP12
	jle     @@trilbshortr
	sub     bx,DY12
	inc     di
@@trilbshortr:
	add     di,XA12

	push    si
	push    di
@@trilbstart:
	cmp     cx,Y2
	jl      @@trilbloop
	jmp     @@tridrawlines

@@tript1rt:
	mov     ax,0
	mov     bx,0
	mov     cx,Y0
	mov     si,X0
	mov     di,si
	dec     di
@@trirtloop:
	inc     cx

	add     ax,DP02
	jle     @@trirtshortl
	sub     ax,DY02
	inc     si
@@trirtshortl:
	add     si,XA02

	add     bx,DP01
	jle     @@trirtshortr
	sub     bx,DY01
	inc     di
@@trirtshortr:
	add     di,XA01

	push    di
	push    si
	cmp     cx,Y1
	jl      @@trirtloop
	jmp     @@trirbstart

@@trirbloop:
	inc     cx
	add     ax,DP02
	jle     @@trirbshortl
	sub     ax,DY02
	inc     si
@@trirbshortl:
	add     si,XA02

	add     bx,DP12
	jle     @@trirbshorts
	sub     bx,DY12
	inc     di
@@trirbshorts:
	add     di,XA12

	push    di
	push    si
@@trirbstart:
	cmp     cx,Y2
	jl      @@trirbloop

@@tridrawlines:
	mov     cx,SCREENSEG
	mov     es,cx
	mov     dx,SCINDEX
	mov     al,MAPMASK
	out     dx,al

@@lineloop:
	pop     ax
	pop     dx
	cmp     ax,dx
	jg      @@tridrawnext
	mov     bx,Color
	mov     cx,Y2
	add     dx,2
	mov     di,PageOffset
	call    HLineClipR
@@tridrawnext:
	dec     word ptr Y2
	dec     word ptr DY02
	jnz     @@lineloop

@@tridone:
	pop     ds
	pop     es
	pop     di
	ret

XTriangle ENDP

XPolygon PROC FAR vertices : DWord, numvertices : Word, Color : Word,\
									PageOffset : Word
LOCAL x0 : Word, y0 : Word, tricount : Word

	mov   cx,numvertices
	cmp   cx,3
	jl    @@Done
	sub   cx,3
	mov   tricount,cx
	les   di,vertices
	mov   ax,es:[di]
	mov   x0,ax
	mov   ax,es:[di+2]
	mov   y0,ax

@@NextTriangle:
	add   di, 4
	mov   ax, x0
	push  ax
	mov   ax, y0
	push  ax
	mov   ax, es:[di+4]
	push  ax
	mov   ax, es:[di+6]
	push  ax
	mov   ax,es:[di]
	push  ax
	mov   ax,es:[di+2]
	push  ax
	mov   ax, color
	push  ax
	mov   ax, pageoffset
	push  ax
	call  xtriangle
	dec   tricount
	jns   @@NextTriangle
@@Done:
	ret

XPolygon ENDP

XPutCursor PROC FAR X : Word, Y : Word, ATopClip : Word, ABottomClip : Word,\
										ScrnOffs : Word
LOCAL Height : Word, TopRow : Word, NextLineIncr : Word

	push  si
	push  di
	push  ds
	mov   ax,seg @data
	mov   ds,ax
	cld
	mov   ax,14
	mov   bx,Y
	mov   dx,ATopClip
	sub   dx,bx
	jle   @@NotTopClip
	cmp   dx,ax
	jnl   @@NotVisible
	mov   cx,dx
	sub   ax,dx
	add   bx,dx
	jmp   @@VertClipDone

@@NotVisible:
	pop   ds
	pop   di
	pop   si
	jmp   @@Done

@@NotTopClip:
	mov   dx,ABottomClip
	sub   dx,bx
	js    @@NotVisible
	mov   cx,0
	cmp   dx,ax
	jg    @@VertClipDone
	inc   dx
	mov   ax,dx

@@VertClipDone:
	mov   Height,ax
	mov   TopRow,cx
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ax,bx
	mov   cx,ScrnLogicalByteWidth
	mul   cx
	mov   di,ax
	sub   cx,3
	mov   NextLineIncr,cx
	mov   cx,X
	mov   bx,cx
	shr   cx,2
	add   di,cx
	and   bx,3
	add   di,ScrnOffs
	mov   ax,42
	mul   bx
	mov   si,offset MouseMask
	add   si,ax
	mov   ax,3
	mul   TopRow
	add   si,ax
	mov   dx,SCINDEX
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   ah,byte ptr Height
	mov   bl,MouseColor

@@RowLoop:
	mov   cx,3

@@ColLoop:
	lodsb
	out   dx,al
	mov   es:[di],bl
	inc   di
	loop  @@ColLoop

	add   di,NextLineIncr
	dec   ah
	jnz   @@RowLoop

	pop   ds
	pop   di
	pop   si

@@Done:
	ret

ENDP

GetBG PROC NEAR

	push  ds
	cld
	mov   cx,ScrnLogicalByteWidth
	mul   cx
	add   si,ax
	sub   cx,3
	shr   bx,2
	add   si,bx
	mov   bx,cx
	mov   di,BGSaveOffs
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ds,ax
	mov   dx,GCINDEX
	mov   ax,BITMASK
	out   dx,ax
	mov   dx,SCINDEX
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   al,0fh
	out   dx,al
	mov   cx,14
@@Loop:
	movsb
	movsb
	movsb
	add si,bx
	loop @@Loop
	mov  dx,GCINDEX+1
	mov  al,0ffh
	out  dx,al
	pop  ds
	ret

GetBg ENDP

RestoreBG PROC NEAR

	push  ds
	cld
	mov   cx,ScrnLogicalByteWidth
	mul   cx
	add   di,ax
	sub   cx,3
	shr   bx,2
	add   di,bx
	mov   si,BGSaveOffs
	mov   ax,SCREENSEG
	mov   es,ax
	mov   ds,ax
	mov   dx,GCINDEX
	mov   ax,BITMASK
	out   dx,ax
	mov   dx,SCINDEX
	mov   al,MAPMASK
	out   dx,al
	inc   dx
	mov   al,0fh
	out   dx,al
	mov   bx,cx
	mov   cx,14
@@Loop:
	movsb
	movsb
	movsb
	add di,bx
	loop @@Loop
	mov  dx,GCINDEX+1
	mov  al,0ffh
	out  dx,al
	pop   ds
	ret

RestoreBg ENDP

UpdateCursor PROC FAR
	cmp VSyncHandlerActive,1
	je  @@SkipVS
	mov dx,InputStatus0
@@WaitNotVsync:
	in  al,dx
	test al,08h
	jnz @@WaitNotVSync
@@WaitVSync:
	in  al,dx
	test al,08h
	jz  @@WaitVSync
@@SkipVS:
	mov di,OldScrnOffs
	mov ax,OldY
	mov bx,OldX
	call restorebg
	mov si,VisiblePageOffs
	mov ax,MouseY
	mov bx,MouseX
	mov OldScrnOffs,si
	mov OldY,ax
	mov OldX,bx
	call getbg
	push OldX
	push OldY
	mov  ax,0
	push ax
	mov  ax,ScrnPhysicalHeight
	push ax
	push VisiblePageOffs
	call xputcursor
	ret

UpdateCursor ENDP

MouseHandler PROC FAR

	push  ds
	mov   di,seg @data
	mov   ds,di
	cmp   inhandler,1
	jne   @@NotActive
	jmp   @@Done2
@@NotActive:
	mov   inhandler,1
	mov   MouseButtonStatus,bx
	test  ax,1
	jz    @@Done
	shr   cx,1
	mov   MouseX,cx
	mov   MouseY,dx
	cmp   MouseHidden,1
	je    @@Done
	cmp   MouseFrozen,1
	je    @@Done
	cmp   VSyncHandlerActive,1
	je    @@VSyncHandle
	call  updatecursor
	jmp   short @@Done
@@VSyncHandle:
	mov   MouseRefreshFlag,1
@@Done:
	mov   inhandler,0
@@Done2:
	pop  ds
	ret

MouseHandler ENDP

XDefineMouseCursor PROC FAR MouseDef : DWord, MouseColour : Byte

	cmp   MouseInstalled,0
	je    @@Done
	mov   al,MouseColour
	mov   MouseColor,al
	push  si
	push  di
	push  ds
	mov   ax,ds
	mov   es,ax
	mov   di,offset MouseMask
	lds   si,MouseDef
	xor   cl,cl
@@AlignmentLoop:
	push  si
	mov   dh,14
@@RowLoop:
	lodsb
	xor   ah,ah
	shl   ax,cl
	mov   bl,al
	and   bl,0fh
	mov   es:[di],bl
	inc   di
	shr   al,4
	stosw
	dec   dh
	jnz   @@RowLoop
	pop   si
	inc   cl
	cmp   cl,4
	jne   @@AlignmentLoop
	pop   ds
	pop   di
	pop   si
@@Done:
	ret

XDefineMouseCursor ENDP


XMouseInit PROC FAR

	mov   InHandler,0
	mov   mousehidden,0
	mov   BGSaveOffs,0
	mov   MouseX,0
	mov   MOuseY,0
	mov   MouseButtonStatus,0
	mov   MouseFrozen,0
	mov   MouseColor,0
	mov   MouseInstalled,0
	cmp   MouseButtonCount,0
	jne   @@DontInitialize
	xor   ax,ax
	int   33h
	or    ax,ax
	jz    @@Done
	mov   MouseButtonCount,bx

@@DontInitialize:
	mov   MouseInstalled,ax
	or    ax,ax
	jz    @@Done
	mov   ax,NonVisualOffs
	mov   BGSaveOffs,ax
	add   ax,42
	mov   NonVisualOffs,ax
	mov   ax,02
	int   33h
	mov   MouseInstalled,1
	mov   ax,07h
	mov   cx,0
	mov   dx,ScrnPhysicalPixelWidth
	shl   dx,1
	int   33h
	mov   ax,08h
	mov   cx,0
	mov   dx,ScrnPhysicalHeight
	int   33h
	mov   ax,0fh
	mov   cx,4
	mov   dx,8
	int   33h
	mov   ax,3
	int   33h
	mov   MouseY,dx
	shr   cx,1
	mov   MouseX,cx
	mov   ax,12
	mov   bx,seg mousehandler
	mov   es,bx
	mov   dx,offset mousehandler
	mov   cx,1fh
	int   33h
	mov   MouseHidden,1
	push  ds
	mov   ax,offset InitMouseDef
	push  ax
	mov   al, MouseColor
	push  ax
	call  xdefinemousecursor
	cmp   VSyncHandlerActive,1
	jne   @@AllIsWell
	mov   ax, offset updatecursor
	mov   dx, seg updatecursor
	cli
	mov   word ptr [MouseVSyncHandler],ax
	mov   word ptr [MouseVsyncHandler+2],dx
	mov   MouseRefreshFlag,0
	sti
@@AllIsWell:
	mov   ax,MouseInstalled
@@Done:
	ret

XMouseInit ENDP

XMouseWindow PROC FAR x0 : Word, y0 : Word, x1 : Word, y1 : Word

	mov   ax,7
	mov   cx,x0
	shl   cx,1
	mov   dx,x1
	shl   dx,1
	int   33h
	mov   ax,8
	mov   cx,y0
	mov   dx,y1
	int   33h
	ret

XMouseWindow ENDP


XShowMouse PROC FAR

	cmp   MouseInstalled,0
	je    @@Done
	cmp   MouseHidden,0
	je    @@Done
	push  si
	push  di

@@WaitEndOfHandler:
	mov   cl,inhandler
	or    cl,cl
	jnz   @@WaitEndOfHandler
	mov   si,VisiblePageOffs
	mov   ax,MouseY
	mov   bx,MouseX
	mov   OldScrnOffs,si
	mov   OldY,ax
	mov   OldX,bx
	call  getbg
	push  OldX
	push  OldY
	xor   ax,ax
	push  ax
	push  ScrnLogicalHeight
	push  VisiblePageOffs
	call  xputcursor
	mov   MouseHidden,0
	pop   di
	pop   si
@@Done:
	ret

XShowMouse ENDP

XHideMouse PROC FAR

	cmp   MouseInstalled,0
	je    @@Done
	cmp   MouseHidden,0
	jne   @@Done
	push  si
	push  di
@@WaitEndOfHandler:
	mov   cl,inhandler
	or    cl,cl
	jnz   @@WaitEndOfHandler
	mov   MouseHidden,TRUE
	mov   di,OldScrnOffs
	mov   ax,OldY
	mov   bx,OldX
	call  restorebg
	pop   di
	pop   si
@@Done:
	ret

XHideMouse ENDP

XMouseRemove PROC FAR

	cmp   MouseInstalled,0
	je    @@Done
	call  xhidemouse
	mov   ax,12
	xor   cx,cx
	int   33h
	mov   MouseRefreshFlag,0
	mov   MouseInstalled,0
@@Done:
	ret

XMouseRemove ENDP

XPositionMouse PROC FAR X : Word, Y : Word

@@WaitEndOfHandler:
	mov   bl,inhandler
	or    bl,bl
	jnz   @@WaitEndOfHandler
	mov   ax,4
	mov   cx,X
	mov   dx,Y
	mov   MouseX,cx
	mov   MouseY,dx
	shl   cx,1
	mov   inhandler,1
	int   33h
	cmp   MouseHidden,FALSE
	jne   @@NotVisible
	push  di
	push  si
	call  updatecursor
	pop   si
	pop   di
@@NotVisible:
	mov   inhandler,0
	ret

XPositionMouse ENDP

XUpdateMouse PROC FAR

	cmp   MouseInstalled,0
	je    @@Done
	cmp   MouseHidden,0
	jne   @@Done
	mov   ax,03h
	int   33h
	shr   cx,1
	mov   MouseX,cx
	mov   MouseY,dx
	mov   MouseButtonStatus,bx
	cmp   VSyncHandlerActive,1
	je    @@HandleVSync
	call  updatecursor
	jmp   short @@Done
@@HandleVSync:
	mov   MouseRefreshFlag,1
@@Done:
	ret

XUpdateMouse ENDP


XFloodFill PROC FAR X : Word, Y : Word, PgOfs : Word, Color : Word
LOCAL len : Word, y1 : Word, y2 : Word, deltax : Word, floodval : Word,\
			Astackptr : Word, FillCount : Word

	mov  FillCount,0
	mov  si,Y
	mov  ax,ScrnLogicalByteWidth
	mul  si
	mov  di,X
	mov  bx,di
	shr  di,2
	add  di,ax
	add  di,PgOfs
	mov  ax,SCREENSEG
	mov  es,ax
	mov  ah,bl
	and  ah,011b
	mov  al,READMAP
	mov  dx,GCINDEX
	out  dx,ax

	mov  al,es:[di]
	cmp  al,byte ptr Color
	je   @@Done

	mov  cx,LeftClip
	sal  cx,2
	cmp  bx,cx
	jl   @@Done

	mov  cx,RightClip
	sal  cx,2
	cmp  bx,cx
	jg   @@Done

	mov  floodval,ax

	push bx
	push si
	push si
	mov  cx,1
	push cx
	mov  Astackptr,1

	mov  deltax,-1
	mov  y1,si
	mov  y2,si
	jmp  @@entry

@@Done2:
	jmp @@Done

@@NextScanCol:
	dec  Astackptr
	js   @@Done2

@@WhileLoop:
	pop  cx
	mov  deltax,cx
	pop  ax
	mov  y2,ax
	pop  si
	mov  y1,si
	pop  bx

	sub  ax,si
	jns  @@PositiveY
	neg  ax
@@PositiveY:
	add  FillCount,ax
	add  bx,cx
	mov  ax,bx
	sar  ax,2
	cmp  ax,LeftClip
	jl   @@NextScanCol
	cmp  ax,RightClip
	jg   @@NextScanCol

	mov  ah,bl
	and  ah,011b
	mov  al,READMAP
	mov  dx,GCINDEX
	out  dx,ax

@@entry:
	mov  cl,bl
	and  cl,011b
	mov  ax,0100h + MAPMASK
	shl  ah,cl
	mov  dx,SCINDEX
	out  dx,ax
	mov  ax,ScrnLogicalByteWidth
	mov  cx,ax
	mul  si
	mov  di,bx
	shr  di,2
	add  di,ax
	add  di,PgOfs
	mov  dx,di

	mov  al,byte ptr Color
	mov  ah,byte ptr floodval

@@FillColUpward:
	cmp  si,TopClip
	jl   @@UpwardFillDone

	cmp  es:[di],ah
	jne  @@UpwardFillDone

	mov  es:[di],al
	sub  di,cx
	dec  si
	jmp  @@FillColUpward

@@UpwardFillDone:
	cmp  si,y1
	jge  @@Skip

	inc  si
	mov  len,si

	cmp  si,y1
	jge  @@AtColumnTop

	push bx
	push si
	mov  ax,y1
	dec  ax
	push ax
	mov  ax,deltax
	neg  ax
	push ax
	inc  Astackptr

@@AtColumnTop:
	mov  si,y1
	mov  di,dx
	add  di,cx
	inc  si


@@ColumnLoop:
	mov  ah,byte ptr floodval
	mov  al,byte ptr Color

@@DownwardFill:
	cmp  si,BottomClip
	jg   @@DownwardFillDone
	cmp  es:[di],ah
	jne  @@DownwardFillDone
	mov  es:[di],al
	add  di,cx
	inc  si
	jmp  @@DownwardFill

@@DownwardFillDone:

	push bx
	mov  ax,len
	push ax
	mov  ax,si
	dec  ax
	push ax
	mov  ax,deltax
	push ax
	inc  Astackptr

	mov  ax,y2
	inc  ax
	cmp  si,ax
	jle  @@Skip

	push bx
	push ax
	mov  ax,si
	dec  ax
	push ax
	mov  ax,deltax
	neg  ax
	push ax
	inc  Astackptr

@@Skip:
	mov  ah,byte ptr floodval
	mov  dx,y2

@@Backtrack:
	add  di,cx
	inc  si
	cmp  si,dx
	jg   @@BacktrackDone

	cmp  byte ptr es:[di],ah
	jne  @@Backtrack

@@BacktrackDone:
	mov  len,si
	cmp  si,dx
	jle  @@ColumnLoop

	dec  Astackptr
	js   @@Done
	jmp  @@WhileLoop
@@Done:
	mov  ax,FillCount
	ret

XFloodFill ENDP


XBoundaryFill PROC FAR X : Word, Y : Word, PgOfs : Word, BoundaryColor : Word,\
											 Color : Word
LOCAL len : Word, y1 : Word, y2 : Word, deltax : Word, y1offs : Word,\
			Astackptr : Word, FillCount : Word

	mov  FillCount,0
	mov  si,Y
	mov  ax,ScrnLogicalByteWidth
	mul  si
	mov  di,X
	mov  bx,di
	shr  di,2
	add  di,ax
	add  di,PgOfs
	mov  ax,SCREENSEG
	mov  es,ax
	mov  ah,bl
	and  ah,011b
	mov  al,READMAP
	mov  dx,GCINDEX
	out  dx,ax
	mov  al,es:[di]
	cmp  al,byte ptr Color
	je   @@Done
	cmp  al,byte ptr BoundaryColor
	je   @@Done


	mov  cx,LeftClip
	sal  cx,2
	cmp  bx,cx
	jl   @@Done

	mov  cx,RightClip
	sal  cx,2
	cmp  bx,cx
	jg   @@Done

	push bx
	push si
	push si
	mov  cx,1
	push cx
	mov  Astackptr,1
	mov  al,byte ptr BoundaryColor
	mov  byte ptr [Color+1],al

	mov  deltax,-1
	mov  y1,si
	mov  y2,si
	jmp  @@entry

@@NextScanCol:
	dec  Astackptr
	js   @@Done

@@WhileLoop:
	pop  cx
	mov  deltax,cx
	pop  ax
	mov  y2,ax
	pop  si
	mov  y1,si
	pop  bx
	add  bx,cx

	sub  ax,si
	jns  @@PositiveY
	neg  ax
@@PositiveY:
	add  FillCount,ax
	mov  ax,bx
	sar  ax,2
	cmp  ax,LeftClip
	jl   @@NextScanCol
	cmp  ax,RightClip
	jg   @@NextScanCol
	mov  ah,bl
	and  ah,011b
	mov  al,READMAP
	mov  dx,GCINDEX
	out  dx,ax

@@entry:
	mov  cl,bl
	and  cl,011b
	mov  ax,0100h + MAPMASK
	shl  ah,cl
	mov  dx,SCINDEX
	out  dx,ax
	mov  ax,ScrnLogicalByteWidth
	mov  cx,ax
	mul  si
	mov  di,bx
	shr  di,2
	add  di,ax
	add  di,PgOfs
	mov  y1offs,di
	mov   ax,Color

@@FillColUpward:
	cmp  si,TopClip
	jl   @@UpwardFillDone

	mov  dl,es:[di]
	cmp  dl,ah
	je   @@UpwardFillDone

	cmp  dl,al
	je   @@UpwardFillDone

	mov  es:[di],al
	sub  di,cx
	dec  si
	jmp  @@FillColUpward

@@UpwardFillDone:
	cmp  si,y1
	jge  @@Skip

	inc  si
	mov  len,si

	cmp  si,y1
	jge  @@AtColumnTop

	push bx
	push si
	mov  ax,y1
	dec  ax
	push ax
	mov  ax,deltax
	neg  ax
	push ax
	inc  Astackptr

@@AtColumnTop:
	mov  si,y1
	mov  di,y1offs
	add  di,cx
	inc  si


@@ColumnLoop:
	mov   ax,Color

@@DownwardFill:
	cmp  si,BottomClip
	jg   @@DownwardFillDone

	cmp  es:[di],ah
	je   @@DownwardFillDone

	cmp  es:[di],al
	je   @@DownwardFillDone

	mov  es:[di],al
	add  di,cx
	inc  si
	jmp  @@DownwardFill

@@DownwardFillDone:

	push bx
	mov  ax,len
	push ax
	mov  ax,si
	dec  ax
	push ax
	mov  ax,deltax
	push ax
	inc  Astackptr

	mov  ax,y2
	inc  ax
	cmp  si,ax
	jle  @@Skip

	push bx
	push ax
	mov  ax,si
	dec  ax
	push ax
	mov  ax,deltax
	neg  ax
	push ax
	inc  Astackptr

@@Skip:
	mov  ax,Color

@@Backtrack:
	add  di,cx
	inc  si
	cmp  si,y2
	jg   @@BacktrackDone

	mov  dl,byte ptr es:[di]
	cmp  dl,al
	je   @@Backtrack

	cmp  dl,ah
	je   @@Backtrack

@@BacktrackDone:
	mov  len,si
	cmp  si,y2
	jle  @@ColumnLoop

	dec  Astackptr
	js   @@Done
	jmp  @@WhileLoop
@@Done:
	mov  ax,FillCount
	ret

XBoundaryFill ENDP

getvsyncperiod proc near
	mov    al,TIMERMODE            ;Start timer
	out    TIMERCONTROL,al
	mov    al,0
	out    TIMER0,al
	out    TIMER0,al

	WaitVsyncStart

	mov    al,LATCHCOUNT
	out    TIMERCONTROL,al
	in     al,TIMER0
	mov    cl,al
	in     al,TIMER0
	mov    ch,al                    ;cx=65536-clicks

	WaitVsyncStart

	mov    al,LATCHCOUNT
	out    TIMERCONTROL,al
	in     al,TIMER0
	mov    dl,al
	in     al,TIMER0
	mov    dh,al

	sub    cx,dx
	mov    ax,cx
	ret
getvsyncperiod endp

vsyncint proc far

	pusha
	push   ds
	push   es

	mov    ax,@data
	mov    ds,ax
	add    VsyncIntTicksLo,1
	adc    VsyncIntTicksHi,0

	inc    ElapsedVrts
	mov    cx,ElapsedVrts
	cmp    cx,VrtsToSkip
	jl     @@StopClock

	cmp    StartAddressFlag,1
	jne    @@StopClock

	mov    dx,CRTCINDEX
	mov    ax,WaitingStartLow
	mov    bx,WaitingStartHigh
	out    dx,ax
	mov    ax,bx
	out    dx,ax

@@StopClock:
	cli
	mov    al,TIMERMODE
	out    TIMERCONTROL,al
	mov    al,255
	out    TIMER0,al
	out    TIMER0,al
	sti

	cli
	mov    dx,INPUTSTATUS0
@@WaitVS:
	in     al,dx
	test   al,08h
	jz     @@WaitVS

	mov    al,TIMERMODE
	out    TIMERCONTROL,al
	mov    ax,ClockRate
	out    TIMER0,al
	mov    al,ah
	out    TIMER0,al

	cmp    cx,VrtsToSkip
	jl     @@PaletteInt

	cmp    StartAddressFlag,1
	jne    @@PaletteInt

	xor    cx,cx
	mov    ElapsedVrts,cx

	mov    ax,WaitingPelPan
	mov    dx,ACINDEX
	out    dx,al
	mov    al,ah
	out    dx,al

@@PaletteInt:
	mov    StartAddressFlag,0
	cmp    VsyncPaletteCount,0
	je     @@MouseInt
	mov    si, offset VsyncPaletteBuffer
	mov    cx, VsyncPaletteCount
	mov    ax, cx
	shl    cx, 1
	add    cx, ax
	mov    ax, VsyncPaletteStart
	mov    dx, DACWRITEINDEX
	out    dx, al
	mov    dx, DACDATA

	rep    outsb
	mov    VsyncPaletteCount,0

@@MouseInt:
	cmp    MouseRefreshFlag,1
	jne    @@UserInt
	call   dword ptr [MouseVsyncHandler]
	mov    MouseRefreshFlag,0

@@UserInt:
	cmp    UserVsyncSeg, 0
	je     short @@Sim182
	cmp    InUserHandler,0
	jne    short @@Sim182
	mov    InUserHandler,1
	mov    StackSeg,ss
	mov    StackPtr,sp
	push   ds
	pop    ss
	mov    sp, offset LocalStack
	sti
	call   dword ptr [UserVsyncHandler]
	cli
	mov    sp, StackPtr
	mov    ss, StackSeg
	mov    InUserHandler,0

@@Sim182:
	mov    ax,[VsyncPeriod]
	add    [ClockCounter],ax
	jnc    short @@DontChainOld
	pop    es
	pop    ds
	popa
	sti
	pushf
	db     09ah            ; call far
OldTimerInt dd 0         ; Self modifying code
	iret

@@DontChainOld:
	mov    al,NONSPECEOI
	out    PICCMD,al
	pop    es
	pop    ds
	popa
	sti
	iret

vsyncint endp


xinstallvsynchandler proc far VrtSkipCount:word

	mov     ax,[VrtSkipCount]
	or      ax,ax
	jnz     @@NonZeroCount
	mov     ax,1
@@NonZeroCount:
	mov     [VrtsToSkip],ax
	mov     [ElapsedVrts],0
	cmp     [VsyncHandlerActive],TRUE      ;Is it already active
	je      short @@Return
	call    getvsyncperiod                ;no, get the vsync period

	mov     [VsyncPeriod],ax
	sub     ax,INTINADVANCE               ;We need a little extra
	mov     [ClockRate],ax                  ;time

	mov     dx,18                           ;dx:ax=1193000
	mov     ax,13352
	idiv    [VsyncPeriod]
	mov     [TicksPerSecond],ax            ;1193/VsyncPeriod

	mov     word ptr [VsyncIntTicks],0
	mov     word ptr [VsyncIntTicks+2],0
	mov     MouseRefreshFlag, 0
	mov     StartAddressFlag, 0
	mov     VSyncPaletteCount, 0

	cli
	
IFDEF _DPMI_
	mov     ax, dpmiGetInt
	mov     bl, TIMERVECT
	int     DPMI                          ;Get Pmode vector
	mov     ax, cs                        ;vector = cx:dx
	add     ax, SelectorInc               ;Make Es = Cs so we can write to it
	mov     es, ax
	mov     word ptr es:[OldTimerInt],dx
	mov     word ptr es:[OldTimerInt+2],cx
ELSE
	mov     ax, DOSGETVECT+TIMERVECT      ;Get address of old timer int
	int     21h                           ;vector = es:bx
	mov     ax,es
	mov     word ptr cs:[OldTimerInt],bx       ;Store in OldTimerInt
	mov     word ptr cs:[OldTimerInt+2],ax
ENDIF
	mov     [VsyncHandlerActive],TRUE      ;Mark handler as active
IFDEF _DPMI_
	mov     ax, dpmiSetInt
	mov     bl, TIMERVECT
	mov     dx, offset vsyncint
	mov     cx, cs
	int     DPMI
ELSE
	mov     ax,DOSSETVECT+TIMERVECT       ;Set the new timer int
	push    ds
	mov     dx,cs
	mov     ds,dx
	mov     dx,offset vsyncint
	int     21h
	pop     ds
ENDIF
	mov     al,TIMERMODE                   ;Reprogram timer 0
	out     TIMERCONTROL,al
	mov     ax,ClockRate
	out     TIMER0,al
	mov     al,ah
	out     TIMER0,al
	sti
@@Return:
	ret

xinstallvsynchandler endp

xremovevsynchandler proc far

	cmp     [VsyncHandlerActive],FALSE
	je      short @@Return
	mov     dx, word ptr cs:[OldTimerInt]
	mov     cx, word ptr cs:[OldTimerInt+2]
IFDEF _DPMI_
	mov     ax, dpmiSetInt
	mov     bl, TIMERVECT
	int     DPMI
ELSE
	push    ds
	mov     ds,cx
	mov     ax,DOSSETVECT+TIMERVECT       ;Restore the old timer int
	cli
	int     21h
	pop     ds
ENDIF
	mov     al,TIMERMODE                   ;Restore timer 0
	out     TIMERCONTROL,al
	mov     al,0
	out     TIMER0,al
	out     TIMER0,al
	sti
@@Return:
	ret

xremovevsynchandler endp


xsetuservsynchandler proc far handlerproc:dword
	mov     ax, word ptr [handlerproc]
	mov     dx, word ptr [handlerproc+2]
	cli
	mov     word ptr [UserVsyncHandler],ax
	mov     word ptr [UserVsyncHandler+2],dx
	sti
	ret
xsetuservsynchandler endp


END
