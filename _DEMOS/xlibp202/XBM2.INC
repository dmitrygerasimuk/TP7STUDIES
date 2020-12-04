	GLOBAL xcompilebitmap          :PROC
	GLOBAL xsizeofcbitmap          :PROC
	GLOBAL xputcbitmap             :PROC
	GLOBAL xclipmaskedpbm          :PROC
	GLOBAL xclippbm                :PROC
	GLOBAL xputmaskedpbm           :PROC
	GLOBAL xflipmaskedpbm          :PROC
	GLOBAL xputpbm                 :PROC
	GLOBAL xflippbm                :PROC
	GLOBAL xgetpbm                 :PROC

	GLOBAL xputmaskedpbmclipx      :PROC
	GLOBAL xputmaskedpbmclipy      :PROC
	GLOBAL xputmaskedpbmclipxy     :PROC

	GLOBAL xputpbmclipx            :PROC
	GLOBAL xputpbmclipy            :PROC
	GLOBAL xputpbmclipxy           :PROC
	GLOBAL xpbmtobm                :PROC
	GLOBAL xbmtopbm                :PROC
	GLOBAL xcompilepbm             :PROC
	GLOBAL xsizeofcpbm             :PROC

	GLOBAL xscale                  :PROC
	GLOBAL xmaskedscale            :PROC
	GLOBAL xscalepbm               :PROC
	GLOBAL xmaskedscalepbm         :PROC

	VBMinfostruc struc
		ASize       dw ?
		ImageWidth  dw ?
		ImageHeight dw ?
	VBMinfostruc ends

	VBMalignmentstruc struc
		ImagePtr    dw ?
		MaskPtr     dw ?
	VBMalignmentstruc ends

Emitb macro arg
	mov byte ptr es:[di],&arg&
	inc di
	endm

Emitw macro arg
	mov word ptr es:[di],&arg&
	add di,2
	endm

ROLAL          EQU 0c0d0h              ; rol al
SHORTSTORE8   EQU 044c6h              ; mov [si]+disp8,  imm8
STORE8         EQU 084c6h              ; mov [si]+disp16, imm8
SHORTSTORE16  EQU 044c7h              ; mov [si]+disp8,  imm16
STORE16        EQU 084c7h              ; mov [si]+disp16, imm16
ADCSIIMMED    EQU 0d683h              ; adc si,imm8
OUTAL          EQU 0eeh                ; out dx,al
RETURN          EQU 0cbh                ; ret
