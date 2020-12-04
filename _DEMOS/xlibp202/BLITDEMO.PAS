{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}

Program BlitDemo;

Uses
{$IFDEF DPMI}
	WinAPI,
{$ENDIF}
	Crt,
	XLib2,
	XBm2;

const
	turtle : array[0..601] of byte =
	( 20,30,
		8,14, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		8, 2,14, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		8, 2, 2, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		8, 0, 2,14, 0, 0,14,14,14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		8, 0, 2, 5, 0, 4, 4, 4, 4,14,14, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		8, 0, 2, 2, 4, 4, 0, 4, 4, 0, 4,14, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 2, 4, 4, 4, 0, 4, 4, 0, 4, 4,14, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 2, 4, 4, 4, 0, 0, 0, 0, 4, 4,14, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 4, 0, 4, 4, 4, 0, 0, 0, 4, 0, 0, 2, 2, 0, 0, 0,
		0, 0, 0, 4, 0, 4, 4, 4, 0, 4, 4, 4, 0,14, 0, 0, 2, 2, 0, 0,
		0, 0, 0, 4, 4, 0, 0, 0, 4, 4, 0, 4, 0, 4, 2, 2, 2, 2, 0, 0,
		0, 0, 0, 4, 4, 4, 0, 4, 4, 0, 4, 4, 0, 4,14, 2, 2, 2, 0, 0,
		0, 0, 0, 4, 4, 4, 0, 0, 0, 4, 4, 0, 4, 0, 0, 2, 2, 0, 0, 0,
		0, 0, 0, 2, 4, 4, 4, 4, 4, 4, 4, 0, 4, 4,14, 2, 0, 0, 0, 0,
		0, 0, 2, 2, 0, 4, 4, 4, 4, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0,
		2, 2, 2, 2, 4, 0, 0, 4, 4, 0, 4, 4, 0, 4,14, 0, 0, 0, 0, 0,
		0, 2, 2, 0, 4, 4, 4, 0, 0, 4, 4, 0, 4, 0, 2, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 4, 4, 0, 4, 4, 4, 0, 4, 4, 2,14, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 0, 4, 0, 2, 2,14,14, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 4, 4, 2, 2, 2, 2, 2,14, 0,
		0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 5,14, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 2, 2, 0, 0, 2, 2, 2, 0, 2,14,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2,14,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 2, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );


var
	TurtleSprite, TurtleSprite32, newfnt, pbm : array[0..2048] of byte;
	vbm : pointer;


Procedure AllocatedSprite( width, height, logicalwidth : integer; var bitmap );
begin
	xbmtopbm(bitmap,pbm);
	XCompileBitmap( logicalwidth, bitmap, TurtleSprite );
end;

Procedure loaduserfonts;
var
	f : file;
	i : integer;
begin
	assign(f,'fonts\smalthin.fnt');
	reset(f,1);
	blockread(f,newfnt,filesize(f));
	close(f);
	xtextinit;
	xregisteruserfont(newfnt);
	xsetfont(2);
end;

procedure main;
var
	i,j,k : integer;
	ratio,ratio2,ratio3 : real;
	pbmt0, pbmt1, vbmt0, vbmt1, cbmt0, cbmt1, cbm32t0, cbm32t1,
	vbmticks,pbmticks,cbmticks,cbm32ticks : longint;
	timer : longint absolute $0040:$006C;
	size, size2, size3 : word;
{$IFDEF DPMI}
	dpmiptr : pointer;
	sel : word;
{$ENDIF}
begin
	xsetmode(XMODE320x240,360);
	AllocatedSprite(20, 30, 90,turtle);

	vbm := xmakevbm(turtle,NonVisualOffs);
	loaduserfonts;
	xbgprintf(0,0,0,14,0,'This is a demo to show the speed difference between');
	xbgprintf(0,8,0,14,0,'compiled, planar and video bitmaps.  The bitmap:');
	xputpbm(140, 18, 0, pbm);
	xbgprintf(0,48,0,14,0,'This demo uses the NON CLIPPED, MASKED versions of');
	xbgprintf(0,56,0,14,0,'       ''PBM'' and ''VBM'' put functions');
	xbgprintf(0,78,0,14,0,'Press a key to start with PLANAR BITMAP demo');
	readkey;
	xrectfill(0,0,ScrnPhysicalPixelWidth,ScrnPhysicalHeight,0,0);
	pbmt0 := timer;
	for k:=0 to 30 do
		for j:=0 to (ScrnPhysicalHeight div 30)-1 do
			for i:=0 to (ScrnPhysicalPixelWidth div 20)-1 do
				xputmaskedpbm(i*20, j*30, 0, pbm);
	pbmt1 := timer;
	pbmticks := abs(pbmt1-pbmt0);


	xbgprintf(0,0,0,14,0,'Press a key to start with the VIDEO BITMAP demo');

	readkey;
	xrectfill(0,0,ScrnPhysicalPixelWidth,ScrnPhysicalHeight,0,0);
	vbmt0 := timer;
	for k:=0 to 30 do
		for j:=0 to (ScrnPhysicalHeight div 30)-1 do
			for i:=0 to (ScrnPhysicalPixelWidth div 20)-1 do
				xputmaskedvbm(i*20, j*30, 0, vbm^);
	vbmt1 := timer;
	vbmticks := abs(vbmt1-vbmt0);
{$IFDEF DPMI}
	Sel := AllocSelector(dSeg);
	Sel := AllocDStoCSAlias( Sel );
	dpmiptr := ptr(Sel,Ofs(TurtleSprite));
{$ENDIF}
	xbgprintf(0,0,0,14,0,'Now Press a key to start with COMPILED BITMAP demo');
	readkey;
	xrectfill(0,0,ScrnPhysicalPixelWidth,ScrnPhysicalHeight,0,0);
	cbmt0 := timer;
	for k:=0 to 30 do
		for j:=0 to (ScrnPhysicalHeight div 30)-1 do
			for i:=0 to (ScrnPhysicalPixelWidth div 20)-1 do
{$IFDEF DPMI}
				xputcbitmap(i*20, j*30, 0, dpmiptr^);
{$ELSE}
				xputcbitmap(i*20, j*30, 0, TurtleSprite);
{$ENDIF}
	cbmt1 := timer;
	cbmticks := abs(cbmt1-cbmt0);
	size := XSizeOfCBitmap32( 90, turtle );
	size3 := XSizeOfCBitmap( 90, turtle );
	size2 := XCompileBitmap32( 90, turtle, TurtleSprite32 );
{$IFDEF DPMI}
	dpmiptr := ptr(Sel,Ofs(TurtleSprite32));
{$ENDIF}
	xbgprintf(0,0,0,14,0,'Now Press a key to start with 32BIT COMPILED BITMAP demo');
	readkey;
	xrectfill(0,0,ScrnPhysicalPixelWidth,ScrnPhysicalHeight,0,0);
	cbm32t0 := timer;
	for k:=0 to 30 do
		for j:=0 to (ScrnPhysicalHeight div 30)-1 do
			for i:=0 to (ScrnPhysicalPixelWidth div 20)-1 do
{$IFDEF DPMI}
				xputcbitmap(i*20, j*30, 0, dpmiptr^);
{$ELSE}
				xputcbitmap(i*20, j*30, 0, TurtleSprite32);
{$ENDIF}
	cbm32t1 := timer;
	cbm32ticks := abs(cbm32t1-cbm32t0);
	ratio3 := cbmticks/cbm32ticks;
	ratio := pbmticks/cbm32ticks;
	ratio2 := vbmticks/cbm32ticks;
	readkey;
	xtextmode;
{$IFDEF DPMI}
	writeln('DPMI version');
{$ENDIF}
	writeln('Planar Bitmaps         = ',pbmticks);
	writeln('Video Bitmaps          = ',vbmticks);
	writeln('Compiled Bitmaps       = ',cbmticks);
	writeln('32Bit Compiled Bitmaps = ',cbm32ticks);
	writeln;
	writeln('PBM/CBM32        = ',ratio:8:10);
	writeln('VBM/CBM32        = ',ratio2:8:10);
	writeln('CBM/CBM32        = ',ratio3:8:10);
	writeln( size,' = ',size2, ' = ', size3 );
end;

begin
	main;
end.
