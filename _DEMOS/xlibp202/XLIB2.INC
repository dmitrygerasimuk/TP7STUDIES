ACINDEX       EQU  03c0h    ; Attribute controller index register
MISCOUTPUT    EQU  03c2h    ; Miscellaneous Output register
SCINDEX       EQU  03c4h    ; SEQUence Controller Index 1
SCINDEX2      EQU  03c5h    ; SEQUence Controller Index 2
GCINDEX       EQU  03ceh    ; Graphics controller Index
CRTCINDEX     EQU  03d4h    ; CRT Controller Index
DACREADINDEX  EQU  03c7h    ;
DACWRITEINDEX EQU  03c8h    ;
DACDATA       EQU  03c9h    ;
INPUTSTATUS0  EQU  03dah    ; Input status 0 register

MAPMASK       EQU  02h      ; index in SC of Map Mask register
READMAP       EQU  04h      ; index in GC of the Read Map register
BITMASK       EQU  08h      ; index in GC of Bit Mask register

OVERFLOW      EQU  07h      ; CRTC overflow register index
MAXSCANLINE   EQU  09h      ; CRTC maximum scan line register index
ADDRHIGH      EQU  0ch      ; Index of Start Address High reg in CRTC
ADDRLOW       EQU  0dh      ;                        Low
CRTCOFFSET    EQU  13h      ; CRTC offset register index
UNDERLINE     EQU  14h      ; CRTC underline location register index
MODECONTROL   EQU  17h      ; CRTC mode control register index
LINECOMPARE   EQU  18h      ; CRTC line compare reg. index (bits 0-7 of
														; split screen scan line

ACMODECONTROL EQU  10h      ; Index of Mode COntrol register in AC
PELPANNING    EQU  13h      ; Pel panning register index in AC

PATTERNBUFFER EQU  0fffch   ; offset in screen memory of pattern buffer

TRUE          EQU 1
FALSE         EQU 0

OK            EQU 0
ERROR         EQU 1
LASTXMODE     EQU 17

i86           EQU 0
i186          EQU 1
i286          EQU 2
i386sx        EQU 3
i386dx        EQU 4
i486          EQU 5


NONE          EQU 0
MDA           EQU 1
CGA           EQU 2
EGAMono       EQU 3
EGAColor      EQU 4
VGAMono       EQU 5
VGAColor      EQU 6
MCGAMono      EQU 7
MCGAColor     EQU 8

LowWord       EQU 0
HighWord      EQU 2

XCoord        EQU 4
YCoord        EQU 0

E1Src         EQU 48
C1Src         EQU 40
C2Src         EQU 32
E2Src         EQU 24

E1Dest        EQU 48
P1Dest        EQU 40
P4Dest        EQU 32
P6Dest        EQU 24
P5Dest        EQU 16
P2Dest        EQU 8
E2Dest        EQU 0

E1Draw        EQU 24
C1Draw        EQU 16
C2Draw        EQU 8
E2Draw        EQU 0

AlignData     EQU 6

TIMERVECT     equ 08h

PICCMD        equ 20h
NONSPECEOI    equ 20h
TIMERMODE     equ 34h
TIMERCONTROL  equ 43h
TIMER0        equ 40h

LATCHCOUNT    equ 00h
INTINADVANCE  equ 100

DOSGETVECT    equ 3500h
DOSSETVECT    equ 2500h

IFDEF _DPMI_

; DPMI interrupt vector

DPMI            EQU     31H

; DPMI function codes

dpmiGetDesc       EQU   0000H           ;Allocate descriptors
dpmiFreeDesc    EQU     0001H           ;Free descriptor
dpmiSegToDesc   EQU     0002H           ;Map segment to descriptor
dpmiGetSelInc   EQU     0003H           ;Get selector increment value
dpmiGetSegBase  EQU     0006H   ;Get segment base address
dpmiSetSegBase  EQU     0007H   ;Set segment base address
dpmiSetSegSize  EQU     0008H   ;Set segment size
dpmiGetRealInt  EQU     0200H   ;Get real mode int handler
dpmiSetRealInt  EQU     0201H   ;Set real mode int handler
dpmiGetExcept   EQU     0202H           ;Get exception handler
dpmiSetExcept   EQU     0203H           ;Set exception handler
dpmiGetInt        EQU   0204H           ;Get interrupt handler
dpmiSetInt        EQU   0205H           ;Set interrupt handler
dpmiGetRMCB       EQU   0303H           ;Get real mode call-back
dpmiGetVersion  EQU     0400H           ;Get version information

ENDIF



; ***************************************************************************
; **                               Macros                                  **
; ***************************************************************************

WaitVsyncStart  MACRO
	LOCAL WaitNotVsync,WaitVsync

	mov     dx,INPUTSTATUS0

WaitNotVsync:
	in      al,dx
	test    al,08h
	jnz     WaitNotVsync

WaitVsync:
	in      al,dx
	test    al,08h
	jz      WaitVsync

	ENDM

WaitVsyncEnd  MACRO
	LOCAL WaitNotVsync,WaitVsync

	mov     dx,INPUTSTATUS0

WaitVsync2:
	in      al,dx
	test    al,08h
	jz      WaitVsync2

WaitNotVsync2:
	in      al,dx
	test    al,08h
	jnz     WaitNotVsync2

	ENDM

WordOut MACRO
	IFDEF nw
		out  dx,al
		inc  dx
		xchg al,ah
		out  dx,al
		xchg al,ah
		dec  dx
	ELSE
		out  dx,al
	ENDIF

	ENDM

LoadV0 macro loc, field
		mov ax, word ptr [bp + loc + field + LowWord]
		mov di, word ptr [bp + loc + field + HighWord]
		endm

LoadV1 macro loc, field
		mov bx, word ptr [bp + loc + field + LowWord]
		mov si, word ptr [bp + loc + field + HighWord]
		endm

LoadV2 macro loc, field
		mov dx, word ptr [bp + loc + field + LowWord]
		mov cx, word ptr [bp + loc + field + HighWord]
		endm

; to store data --

StoreV0 macro loc, field
		mov word ptr [bp + loc + field + LowWord], ax
		mov word ptr [bp + loc + field + HighWord], di
		endm

StoreV1 macro loc, field
		mov word ptr [bp + loc + field + LowWord], bx
		mov word ptr [bp + loc + field + HighWord], si
		endm


; to take the average of two registers (result is in first register) --

AverageV0nV1 macro
	add ax, bx
	adc di, si
	shr di, 1
	rcr ax, 1
	endm

AverageV0nV2 macro
	add ax, dx
	adc di, cx
	shr di, 1
	rcr ax, 1
	endm

AverageV1nV2 macro
	add bx, dx
	adc si, cx
	shr si, 1
	rcr bx, 1
	endm


; to take the average of a register and data --

AverageV1nData macro loc, field
		add bx, word ptr [bp + loc + field + LowWord]
		adc si, word ptr [bp + loc + field + HighWord]
		shr si, 1
		rcr bx, 1
		endm

AverageV2nData macro loc, field
		add dx, word ptr [bp + loc + field + LowWord]
		adc cx, word ptr [bp + loc + field + HighWord]
		shr cx, 1
		rcr dx, 1
		endm


; to turn a 32-bit fixed point data into a regular integer --

Extract macro reg, source, field
	mov reg, word ptr [bp + source + field + HighWord]
	shr reg, 3
	adc reg, 0          ; round
	endm


; to turn an integer argument into a 32-bit fixed point number
; and store it as local data --

Convert macro source, dest, field
	mov ax, source
	add ax, 1024
	shl ax, 3
	push ax
	push 0
	endm


; ***************************************************************************
; **                              Globals                                  **
; ***************************************************************************

	.DATA

	GLOBAL InGraphics              :BYTE
	GLOBAL CurrXMode               :WORD
	GLOBAL ScrnPhysicalByteWidth   :WORD
	GLOBAL ScrnPhysicalPixelWidth  :WORD
	GLOBAL ScrnPhysicalHeight      :WORD
	GLOBAL ErrorValue              :BYTE
	GLOBAL ModeTable               :BYTE
	GLOBAL ScreenSeg               :WORD
	GLOBAL Seg0000                 :WORD
IFDEF _DPMI_
	GLOBAL __A000H                 :ABS
	GLOBAL __C000H                 :ABS
	GLOBAL __AHIncr                :ABS
	GLOBAL __0000H                 :ABS
ENDIF

	GLOBAL SplitScrnOffs           :WORD
	GLOBAL SplitScrnScanLine       :WORD
	GLOBAL SplitScrnVisibleHeight  :WORD
	GLOBAL SplitScrnActive         :BYTE
	GLOBAL Page0Offs               :WORD
	GLOBAL Page1Offs               :WORD
	GLOBAL Page2Offs               :WORD
	GLOBAL ScrnLogicalByteWidth    :WORD
	GLOBAL ScrnLogicalPixelWidth   :WORD
	GLOBAL ScrnLogicalHeight       :WORD

	GLOBAL MaxScrollX              :WORD
	GLOBAL MaxScrollY              :WORD
	GLOBAL DoubleBufferActive      :WORD
	GLOBAL TripleBufferActive      :WORD
	GLOBAL VisiblePageIdx          :WORD
	GLOBAL VisiblePageOffs         :WORD
	GLOBAL HiddenPageOffs          :WORD
	GLOBAL WaitingPageOffs         :WORD
	GLOBAL NonVisualOffs           :WORD
	GLOBAL TopClip                 :WORD
	GLOBAL BottomClip              :WORD
	GLOBAL LeftClip                :WORD
	GLOBAL RightClip               :WORD

	GLOBAL PhysicalStartByteX      :WORD
	GLOBAL PhysicalStartPixelX     :WORD
	GLOBAL PhysicalStartY          :WORD

	GLOBAL VsyncHandlerActive      :WORD
	GLOBAL MouseRefreshFlag        :WORD
	GLOBAL StartAddressFlag        :WORD
	GLOBAL WaitingStartLow         :WORD
	GLOBAL WaitingStartHigh        :WORD
	GLOBAL WaitingPelPan           :WORD
	GLOBAL VsyncPaletteStart       :WORD
	GLOBAL VsyncPaletteCount       :WORD
	GLOBAL VsyncPaletteBuffer      :BYTE

	GLOBAL xcircle                 :PROC
	GLOBAL xfilledcircle           :PROC

	GLOBAL LeftBound               :WORD
	GLOBAL RightBound              :WORD
	GLOBAL TopBound                :WORD
	GLOBAL BottomBound             :WORD

	GLOBAL MouseButtonCount        :WORD
	GLOBAL MouseVersion            :WORD
	GLOBAL MouseType               :BYTE
	GLOBAL MouseIRQ                :BYTE


	GLOBAL xgraphicscard           :PROC
	GLOBAL xprocessor              :PROC
	GLOBAL xcoprocessor            :PROC
	GLOBAL xmousedriver            :PROC

	GLOBAL xfloodfill              :PROC
	GLOBAL xboundaryfill           :PROC

	GLOBAL xbezier                 :PROC

	GLOBAL xline                   :PROC

	GLOBAL xsetmode                :PROC
	GLOBAL xpageflip               :PROC
	GLOBAL xsetstartaddr           :PROC
	GLOBAL xsetsplitscreen         :PROC
	GLOBAL xtextmode               :PROC
	GLOBAL xsetmode                :PROC
	GLOBAL xselectdefaultplane     :PROC
	GLOBAL xhidesplitscreen        :PROC
	GLOBAL xshowsplitscreen        :PROC
	GLOBAL xadjustsplitscreen      :PROC
	GLOBAL xsetdoublebuffer        :PROC
	GLOBAL xsettriplebuffer        :PROC
	GLOBAL xsetcliprect            :PROC
	GLOBAL xwaitvsync              :PROC

	GLOBAL xputcursor              :PROC
	GLOBAL xmouseinit              :PROC
	GLOBAL xdefinemousecursor      :PROC
	GLOBAL xmousewindow            :PROC
	GLOBAL xshowmouse              :PROC
	GLOBAL xhidemouse              :PROC
	GLOBAL xmouseremove            :PROC
	GLOBAL xpositionmouse          :PROC
	GLOBAL xupdatemouse            :PROC


	GLOBAL xgetpalstruc            :PROC
	GLOBAL xgetpalraw              :PROC
	GLOBAL xputpalstruc            :PROC
	GLOBAL xputpalraw              :PROC
	GLOBAL xsetrgb                 :PROC
	GLOBAL xrotpalstruc            :PROC
	GLOBAL xrotpalraw              :PROC
	GLOBAL xputcontrastpalstruc    :PROC
	GLOBAL xtransposepalstruc      :PROC
	GLOBAL xcpcontrastpalstruc     :PROC

	GLOBAL xputpix                 :PROC
	GLOBAL xgetpix                 :PROC

	GLOBAL xtriangle               :PROC
	GLOBAL xpolygon                :PROC

	GLOBAL xrectfill               :PROC
	GLOBAL xrectfillclipped        :PROC
	GLOBAL xrectpattern            :PROC
	GLOBAL xrectpatternclipped     :PROC
	GLOBAL xcpvidpage              :PROC
	GLOBAL xcpvidrect              :PROC
	GLOBAL xshiftrect              :PROC

	GLOBAL xtextinit               :PROC
	GLOBAL xsetfont                :PROC
	GLOBAL xcharput                :PROC
	GLOBAL xregisteruserfont       :PROC
	GLOBAL xgetcharwidth           :PROC

	GLOBAL CharHeight              :BYTE
	GLOBAL CharWidth               :BYTE
	GLOBAL FontPtr                 :WORD:2
	GLOBAL FirstChar               :BYTE
	GLOBAL UserFontPtr             :WORD:2
	GLOBAL UserChHeight            :BYTE
	GLOBAL UserChWidth             :BYTE
	GLOBAL UserFirstCh             :BYTE

	GLOBAL xstorevbmimage          :PROC
	GLOBAL xputmaskedvbm           :PROC
	GLOBAL xputmaskedvbmclipx      :PROC
	GLOBAL xputmaskedvbmclipy      :PROC
	GLOBAL xputmaskedvbmclipxy     :PROC

	GLOBAL xstorevbmimage          :PROC
	GLOBAL xinstallvsynchandler    :PROC
	GLOBAL xremovevsynchandler     :PROC
	GLOBAL xsetuservsynchandler    :PROC

	GLOBAL PelPanMask              :BYTE

	GLOBAL DoubleScanFlag          :BYTE

	GLOBAL ColumnMask              :BYTE
	GLOBAL LeftMaskTable           :BYTE
	GLOBAL RightMaskTable          :BYTE
	GLOBAL PelPanMask              :BYTE
	GLOBAL LeftClipPlaneMask       :BYTE
	GLOBAL RightClipPlaneMask      :BYTE
	GLOBAL MirrorTable             :BYTE
	GLOBAL LeftDelay               :BYTE
	GLOBAL RightDelay              :BYTE
	GLOBAL F8x8Ptr                 :WORD:2
	GLOBAL F8x14Ptr                :WORD:2
	GLOBAL MirrorTableOffs         :WORD
	GLOBAL FontDriverActive        :BYTE

	GLOBAL PS2Cards                :BYTE

	GLOBAL MouseMask               :BYTE
	GLOBAL InHandler               :BYTE
	GLOBAL BGSaveOffs              :WORD
	GLOBAL MouseInstalled          :WORD
	GLOBAL MouseHidden             :WORD
	GLOBAL MouseButtonStatus       :WORD
	GLOBAL MouseX                  :WORD
	GLOBAL MouseY                  :WORD
	GLOBAL MouseFrozen             :BYTE
	GLOBAL MouseColor              :BYTE
	GLOBAL InitMouseDef            :BYTE

	GLOBAL WhenToDraw              :BYTE

	GLOBAL SelectorInc             :WORD
	
