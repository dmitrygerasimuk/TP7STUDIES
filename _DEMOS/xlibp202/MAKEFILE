#############################################################################
# XLibPas v2.0 Makefile                                                     #
# Tristan Tarrant ( tristant@cogs.susx.ac.uk )                              #
#############################################################################
#   MAKE   to make real mode units and programs                             #
#   MAKE -DDEBUG  to make units and the programs with debug information     #
#   MAKE -DDPMI   to make protected mode units and programs                 #
#############################################################################

!if $d(DEBUG)
TASM=tasm /m /q /t /z /zi
BPC=bpc -Q -$G+ -$N- -$E- -V -$D+ -$L+ -$Y+
!else
TASM=tasm /m /q /t /z /zn
BPC=bpc -Q -$G+ -$N- -$E- -V -$D- -$L- -$Y-
!endif

!if $d(DPMI)
.pas.exe:
	$(BPC) -CP $&.pas

.asm.obp:
	$(TASM) -d_DPMI_ $&.asm,$&.obp

.pas.tpp:
	$(BPC) -CP $&.pas

all     : allprotected

!else

.pas.exe:
	$(BPC) -CD $&.pas

.asm.obj:
	$(TASM) $&.asm,$&.obj

.pas.tpu:
	$(BPC) -CD $&.pas

all     : allreal

!endif

allreal      : xlib2.tpu xbm2.tpu xla2.tpu xmisc2.tpu xgif2.tpu\
				 xbmp2.tpu xconvert.exe xlarc.exe xlibdemo.exe blitdemo.exe\
				 fontdemo.exe

allprotected : xlib2.tpp xbm2.tpp xla2.tpp xmisc2.tpp xgif2.tpp xbmp2.tpp\
				 xconvert.exe xlarc.exe xlibdemo.exe blitdemo.exe fontdemo.exe

xlib2.obj    : xlib2.inc xlib2.asm

xlib2.obp    : xlib2.inc xlib2.asm

xlib2.tpu    : xlib2.obj xlib2.pas 

xlib2.tpp    : xlib2.obp xlib2.pas

xbm2.tpu     : xbm2.obj xbm2.pas xlib2.tpu

xbm2.tpp     : xbm2.obp xbm2.pas xlib2.tpp

xbm2.obj     : xbm2.inc xbm2.asm

xbm2.obp     : xbm2.inc xbm2.asm

xmisc2.tpu   : xmisc2.pas

xmisc2.tpp   : xmisc2.pas

xgif2.tpu    : xgif2.pas

xgif2.tpp    : xgif2.pas

xbmp2.tpu    : xbmp2.pas

xbmp2.tpp    : xbmp2.pas

xla2.tpu     : xmisc2.tpu xla2.pas

xla2.tpp     : xmisc2.tpp xla2.pas
!if $d(DPMI)
xlarc.exe    : xmisc2.tpp xla2.tpp xlarc.pas

xconvert.exe : xbm2.tpp xgif2.tpp xmisc2.tpp xconvert.pas

xlibdemo.exe : xlib2.tpp xbm2.tpp xlibdemo.pas

blitdemo.exe : xlib2.tpp xbm2.tpp blitdemo.pas

fontdemo.exe : xlib2.tpp xbm2.tpp fontdemo.pas
!else
xlarc.exe    : xmisc2.tpu xla2.tpu xlarc.pas

xconvert.exe : xbm2.tpu xgif2.tpu xmisc2.tpp xconvert.pas

xlibdemo.exe : xlib2.tpu xbm2.tpu xlibdemo.pas

blitdemo.exe : xlib2.tpu xbm2.tpu blitdemo.pas

fontdemo.exe : xlib2.tpu xbm2.tpu fontdemo.pas
!endif
clean        : 
				 del xlib2.tpu xbm2.tpu xla2.tpu xmisc2.tpu xgif2.tpu 
				 del xbmp2.tpu xconvert.exe xlarc.exe xlib2.obj xbm2.obj
				 del xlibdemo.exe blitdemo.exe fontdemo.exe
				 del xlib2.tpp xbm2.tpp xla2.tpp xmisc2.tpp xgif2.tpp
				 del xbmp2.tpp xlib2.obp xbm2.obp
				 del xlib2.tph

help: xlib2.tph

xlib2.tph: xlib2.pas xbm2.pas xmisc2.pas xgif2.pas xbmp2.pas xla2.pas
	scanhelp /FB /O xlib2.tph /T 2 xlib2.pas xbm2.pas xmisc2.pas xgif2.pas xbmp2.pas xla2.pas
