program testgif;

uses
	xgif2,crt,xlib2;

var
	x, y : word;
	palette : array[0..767] of byte;

function NextPixel : integer; far;
begin
	inc(x);
	if x> 64000 then
		NextPixel := -1
	else
		NextPixel := mem[$A000:x-1];
end;

procedure dummy(var line; x,y:integer); far;
begin
	move(line, mem[$A000:x*320], y);
end;

begin
	x := 0;
	y := 0;
	GifInPixelProc := NextPixel;
	GifOutLineProc := dummy;
	asm
		mov ax, 13h
		int 10h
	end;
	loadgif('D:\GAMES\DOOM\XDOOM.GIF');
	xputpalraw(gifpalette,256,0);
	{savegif('D:\GAMES\DOOM\XDOOM.GIF',320,200,8,gifpalette);}
	readkey;
end.