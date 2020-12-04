{ VERY QUICK AND ULTRA-DIRTY DEMO USING XLIB
	Simple Demo of MODE X Split screen and panning
	Compile using Borland/Turbo Pascal 6.0/7.0 }

{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}

Program Xlibdemo;

Uses
	Crt, XLib2, xbm2;

Const
	MaxObjects = 10;
	ObjectCount : integer = 0;
	bm : array[0..193] of byte =
		(4,12,
		2,2,2,2,2,1,1,1,2,1,1,1,2,3,3,1,
		2,0,0,3,2,0,0,3,2,0,0,3,2,0,0,3,
		2,3,3,1,2,1,1,1,2,1,1,1,2,2,2,2,
		2,2,2,2,1,1,1,1,1,1,1,1,1,3,3,1,
		1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
		1,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,
		2,2,2,2,1,1,1,1,1,1,1,1,1,3,3,1,
		1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
		1,3,3,1,1,1,1,1,1,1,1,1,2,2,2,2,
		2,2,2,2,1,1,1,2,1,1,1,2,1,3,3,2,
		3,0,0,2,3,0,0,2,3,0,0,2,3,0,0,2,
		1,3,3,2,1,1,1,2,1,1,1,2,2,2,2,2 );

	bm2 : array[0..193] of byte =
		(4,12,
		2,2,2,2,2,4,4,4,2,4,4,4,2,2,2,4,
		2,0,0,2,2,0,0,2,2,0,0,2,2,0,0,2,
		2,2,2,4,2,4,4,4,2,4,4,4,2,2,2,2,
		2,2,2,2,4,4,4,4,4,4,4,4,4,2,2,4,
		4,0,0,4,4,0,0,4,4,0,0,4,4,0,0,4,
		4,2,2,4,4,4,4,4,4,4,4,4,2,2,2,2,
		2,2,2,2,4,4,4,4,4,4,4,4,4,2,2,4,
		4,0,0,4,4,0,0,4,4,0,0,4,4,0,0,4,
		4,2,2,4,4,4,4,4,4,4,4,4,2,2,2,2,
		2,2,2,2,4,4,4,2,4,4,4,2,4,2,2,2,
		2,0,0,2,2,0,0,2,2,0,0,2,2,0,0,2,
		4,2,2,2,4,4,4,2,4,4,4,2,2,2,2,2);

	palscrolldir : integer = 1;
	textwindowx : integer = 0;
	textwindowy : integer = 0;
Type
	AnimatedObject = record
		X,Y,Width,Height,XDir,YDir,XOtherPage,YOtherPage : integer;
		Image, bg, bgOtherPage : pointer;
	end;

Var
	objects : array[0..MaxObjects] of AnimatedObject;
	userfnt1, pal, pal2, SaveExitProc : pointer;
	xpos : integer;

procedure initobject( x, y, width, height, xdir, ydir : integer;
											var image : pointer );
begin
	objects[objectcount].X := x;
	objects[objectcount].XOtherPage := x;
	objects[objectcount].Y := y;
	objects[objectcount].YOtherPage := y;
	objects[objectcount].Width := width;
	objects[objectcount].Height := height;
	objects[objectcount].XDir := xdir;
	objects[objectcount].YDir := ydir;
	objects[objectcount].Image := image;
	GetMem( objects[objectcount].bg, 4*width*height+20);
	GetMem( objects[objectcount].bgOtherPage, 4*width*height+20);
	xgetpbm(x,y,width,height,VisiblePageOffs, objects[objectcount].bg^);
	xgetpbm(x,y,width,height,HiddenPageOffs, objects[objectcount].bgOtherPage^);
	inc(objectcount);
end;

procedure MoveObject( var ObjectToMove : AnimatedObject );
var
	X, Y : integer;
	cptr : pointer;
begin
	X := ObjectToMove.X + ObjectToMove.XDir;
	Y := ObjectToMove.Y + ObjectToMove.YDir;
	if (X < 0) or (X > (ScrnLogicalPixelWidth-(ObjectToMove.Width shl 2))) then
	begin
		ObjectToMove.XDir := -ObjectToMove.XDir;
		X := ObjectToMove.X + ObjectToMove.XDir;
	 end;
	if (Y < 0) or (Y > (ScrnLogicalHeight-ObjectToMove.Height)) then
	begin
		ObjectToMove.YDir := -ObjectToMove.YDir;
		Y := ObjectToMove.Y + ObjectToMove.YDir;
	end;
	ObjectToMove.XOtherPage := ObjectToMove.X;
	ObjectToMove.YOtherPage := ObjectToMove.Y;
	ObjectToMove.X := X;
	ObjectToMove.Y := Y;
	cptr := ObjectToMove.bg;
	ObjectToMove.bg := ObjectToMove.bgOtherPage;
	ObjectToMove.bgOtherPage := cptr;
end;

procedure animate;
var
	i : integer;
begin
	for i:=objectcount-1 downto 0 do
		xputpbm(objects[i].XOtherPage,objects[i].YOtherPage,
			HiddenPageOffs,objects[i].bgOtherPage^);
	for i:=0 to objectcount-1 do
	begin
		MoveObject(objects[i]);
		xgetpbm(objects[i].X,objects[i].Y,
			objects[i].Width,objects[i].Height,HiddenPageOffs,
			objects[i].bg^);
		xputmaskedpbm(objects[i].X,objects[i].Y,HiddenPageOffs,
			objects[i].Image^);
 end;
end;

procedure clearobjects;
var
	i : integer;
begin
	for i:=objectcount-1 downto 0 do
		xputpbm(objects[i].XOtherPage,objects[i].YOtherPage,
			HiddenPageOffs,objects[i].bgOtherPage^);
end;


procedure textwindow( Margin : integer );
var
	x0, y0, x1, y1 : integer;
begin
	 x0 := Margin;
	 y0 := Margin;
	 x1 := ScrnPhysicalPixelWidth-Margin;
	 y1 := ScrnPhysicalHeight-Margin;
	 xrectfill(x0, y0, x1,y1,VisiblePageOffs,1);
	 xline(x0,y0,x1,y0,2,VisiblePageOffs);
	 xline(x0,y1,x1,y1,2,VisiblePageOffs);
	 xline(x0,y0,x0,y1,2,VisiblePageOffs);
	 xline(x1,y0,x1,y1,2,VisiblePageOffs);
	 xline(x0+2,y0+2,x1-2,y0+2,2,VisiblePageOffs);
	 xline(x0+2,y1-2,x1-2,y1-2,2,VisiblePageOffs);
	 xline(x0+2,y0+2,x0+2,y1-2,2,VisiblePageOffs);
	 xline(x1-2,y0+2,x1-2,y1-2,2,VisiblePageOffs);
	 textwindowx:=x0;
	 textwindowy:=y0;
end;


procedure waitforkeypress;
begin
	xshowmouse;
	while keypressed do readkey;
	while MouseButtonStatus=LeftPressed do;
	palscrolldir := 1-palscrolldir;
	while (not keypressed) and (MouseButtonStatus<>LeftPressed) do
	begin
		xrotpalstruc(pal^,palscrolldir);
{$IFDEF DPMI}
		mousefrozen := 1;
{$ENDIF}
		{Notice that there is no need to freeze and update the mouse if the
		 vsync handler is installed while just updating the palette, because the
		 DAC is changed before the mouse handler is called}

		xputpalstruc(pal^);
{$IFDEF DPMI}
		xupdatemouse;
{$ENDIF}
	end;
	while keypressed do readkey;
	while MouseButtonStatus=LeftPressed do;
end;


procedure quit; far;
begin
	xremovevsynchandler;
	xmouseremove;
	textmode(co80+font8x8);
	ExitProc := SaveExitProc;
end;

procedure intro1;
begin
	xsetrgb(1,40,40,40);
	xsetrgb(2,63,63,0);
	xsetrgb(3,63,0,0);
	xsetrgb(4,0,63,0);
	xsetrgb(5,0,0,63);
	xsetrgb(6,0,0,28);
	xsetrgb(7,0,28,0);
	xsetrgb(8,28,0,0);
	xsetrgb(9,0,0,38);
	textwindow(20);
	xsetfont(1);
	xpos := xcentre(180,textwindowy+4,VisiblePageOffs,6,'XLibPas Version 2.0');
	xprintf(xpos-1,textwindowy+3,VisiblePageOffs,2,'XLibPas Version 2.0');
	xsetfont(0);
	xpos := xcentre(180,168,VisiblePageOffs,6,'Press any key to continue');
	xprintf(xpos-1,167,VisiblePageOffs,2,'Press any key to continue');
end;

procedure subsequentpage;
begin
	xhidemouse;
	textwindow(20);
	xsetfont(1);
	xpos := xcentre(180,textwindowy+4,VisiblePageOffs,6,'XLibPas Version 2.0');
	xprintf(xpos-1,textwindowy+3,VisiblePageOffs,2,'XLibPas Version 2.0');
	xsetfont(0);
	xpos := xcentre(180,168,VisiblePageOffs,6,'Press any key to continue');
	xprintf(xpos-1,167,VisiblePageOffs,2,'Press any key to continue');

end;

procedure loaduserfonts;
var
	f : File;
begin
	assign(f,'fonts\var6x8.fnt');
	reset(f,1);
	blockread( f, userfnt1^, filesize(f) );
	close(f);
	xregisteruserfont(userfnt1^);
end;



procedure main;
var
	i, j, xinc, yinc, Margin : integer;
	ch : char;
	a : byte;
	currx, curry : word;
	x0,x1,x2,y0,y1,y2 : integer;
	pt : pointer;
begin
	GetMem(pal,256*3);
	GetMem(pal2,256*3);
	GetMem(userfnt1,256*16+4);
	currx := 0;
	curry := 0;

	xtextmode;
	xsetmode(XMODE360x200,500);
{$IFNDEF DPMI}
	xinstallvsynchandler(1);
{$ENDIF}
	xsetsplitscreen(ScrnPhysicalHeight-61);
	xsetdoublebuffer(220);
	xhidesplitscreen;
	xtextinit;
	xmouseinit;
	xmousewindow(0,0,359,199);
	mousecolor := 2;
	for j:=0 to ScrnPhysicalHeight-1 do
		xline(0,j,ScrnLogicalPixelWidth,j,16+(j mod 239),VisiblePageOffs);

	xgetpalstruc(pal^,240,16);
	loaduserfonts;
	intro1;
	xsetfont(2);
	xhidemouse;
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, '  Hi, folks. This is yet another FREEWARE Mode X graphics');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' library. It is by no means complete, but I believe it');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' contains a rich enough set of functions to achieve its');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, ' design goal : a game development oriented library for');
	xprintf(textwindowx+5,50+32,VisiblePageOffs,9, ' Borland TP/BP programmers.');

	xprintf(textwindowx+5,50+48,VisiblePageOffs,9, '  This library comes with BP/TP sources.');
	xprintf(textwindowx+5,50+56,VisiblePageOffs,9, ' It was inspired by the DDJ Graphics column and many');
	xprintf(textwindowx+5,50+64,VisiblePageOffs,9, ' INTERNET and USENET authors who, unlike the majority of');
	xprintf(textwindowx+5,50+72,VisiblePageOffs,9, ' programmers (you know who you are!), willingly share');
	xprintf(textwindowx+5,50+80,VisiblePageOffs,9, ' their code and ideas with others.');


	waitforkeypress;

	subsequentpage;
	xsetfont(0);
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'Supported 256 colour resolutions.');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'Supported 256 colour resolutions.');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, ' 320x200   Standard for games       ~ 4 pages');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' 320x240   DDJ Mode X square pixels ~ 3.5 pages');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' 360x200   My favourite for games   ~ 3 pages  ');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, ' 360x240                            ~ 2.8 pages');
	xprintf(textwindowx+5,50+32,VisiblePageOffs,9, ' 320x400                            ~ 2 pages  ');
	xprintf(textwindowx+5,50+40,VisiblePageOffs,9, ' 320x480,360x400,360x480,376x282,360x360,376x308');
	xprintf(textwindowx+5,50+48,VisiblePageOffs,9, ' 376x564,256x200,256x240,256x224,256x256,360x270');
	xprintf(textwindowx+5,50+56,VisiblePageOffs,9, ' 400x300');
	xprintf(textwindowx+5,50+72,VisiblePageOffs,9, ' Phew! and they''ll run on all VGA cards and ');
	xprintf(textwindowx+5,50+80,VisiblePageOffs,9, ' monitors (some of the weird ones are best suited');
	xprintf(textwindowx+5,50+88,VisiblePageOffs,9, ' to monitors with both vert & horiz adjustments)');
	xprintf(textwindowx+5,50+98,VisiblePageOffs,2, '  ');
	xprintf(textwindowx+5,50+106,VisiblePageOffs,2,' Overkill? Maybe!! ');


	waitforkeypress;

	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'Text display functions.');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'Text display functions.');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, '   Several text printing functions are provided.');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' They support the VGA ROM 8x14 and 8x8 fonts as well');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' as user-defined fonts (like this 6x8 font).');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, ' A set of 70 fonts is provided, but no editor :-(');
	xprintf(textwindowx+5,50+32,VisiblePageOffs,9, ' ( is someone out there so kind...)');
	xprintf(textwindowx+5,50+40,VisiblePageOffs,9, ' User defined fonts may be proportionally spaced but');
	xprintf(textwindowx+5,50+58,VisiblePageOffs,9, ' have a maximum width of 8 pixels.');


	waitforkeypress;

	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'Advanced screen functions.');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'Advanced screen functions.');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, '   The library supports virtual screens larger');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' than the physical screen, panning of such');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' screens, and a split screen option.');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, '   These functions can be used together or');
	xprintf(textwindowx+5,50+32,VisiblePageOffs,9, ' in isolation, and in the lower resolutions');
	xprintf(textwindowx+5,50+40,VisiblePageOffs,9, ' double buffering can also be accomplished.');

	xrectfill(0, 0, ScrnPhysicalPixelWidth,60,SplitScrnOffs,5);
	xline(0,0,ScrnPhysicalPixelWidth,0,2,SplitScrnOffs);
	xsetfont(1);
	xprintf(10,10,SplitScrnOffs,2, ' This is a split screen, tops for scores.');
	xsetfont(0);
	for i:=ScrnPhysicalHeight downto ScrnPhysicalHeight-60 do
		xadjustsplitscreen(i);
	xprintf(10,25,SplitScrnOffs,2, ' Even better for scrolling games etc.');

	xcpvidpage(VisiblePageOffs,HiddenPageOffs);


	xshowmouse;
	waitforkeypress;
	pt := @bm2;
	initobject(60,90,4, 12, -1, 1, pt );
	pt := @bm;
	initobject(30,30,4, 12, 1, 1, pt );
	initobject(80,120,4, 12, 2, 1, pt );
	initobject(300,200,4, 12, 1, -2, pt );
	initobject(360,30,4, 12, -1, -1, pt );
	initobject(360,10,4, 12, -2, 2, pt );

	xhidemouse;

	while (not keypressed) and (MouseButtonStatus<>LeftPressed) do
	begin
		animate;
		if (objects[0].X>=currx+ScrnPhysicalPixelWidth-32) and
			(currx < MaxScrollX) then inc(currx)
		else if (objects[0].X < currx+16) and ( currx > 0) then dec(currx);
		if (objects[0].Y>=curry+ScrnPhysicalHeight-92) and
			(       curry < MaxScrollY) then inc(curry)
		else if (objects[0].Y < curry+16) and ( curry > 0) then dec(curry);
		xpageflip(currx, curry);
	end;
	while keypressed do readkey;
	while MouseButtonStatus=LeftPressed do;

	clearobjects;
	xpageflip(currx,curry);


	xsetstartaddr(0,0);


	for j:=0 to 3 do
	begin
		xhidesplitscreen;
		delay(100);
		xshowsplitscreen;
		delay(100);
	end;


	for i:= ScrnPhysicalHeight-60 to ScrnPhysicalHeight do
		xadjustsplitscreen(i);

	xhidemouse;
	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'Palette functions.');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'Palette functions.');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, '   A number of palette manipulation functions');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' are provided. You have already seen some of');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' them in action. Another common operation is');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, ' palette fading.                     ');

	i:=0;
	a:=255;
	while (xcpcontrastpalstruc(pal^, pal2^,a))>0 do
	begin
		a := a-2;
		xputpalstruc(pal2^);
		xrotpalstruc(pal^,palscrolldir);
		inc(i);
	end;
	for j:=0 to i-1 do
	begin
		xcpcontrastpalstruc(pal^, pal2^,a);
		a := a+2;
		xputpalstruc(pal2^);
		xrotpalstruc(pal^,palscrolldir);
	end;
	waitforkeypress;
	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'XLIBC Functions!');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'XLIBC Functions!');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, ' Functions include:');
	xprintf(textwindowx+5,50+10,VisiblePageOffs,9, '  - FAST VRAM-based masked bitmaps, including');
	xprintf(textwindowx+5,50+18,VisiblePageOffs,9, '      support for clipping regions');
	xprintf(textwindowx+5,50+28,VisiblePageOffs,9, '  - FAST compiled masked bitmaps');
	xprintf(textwindowx+5,50+38,VisiblePageOffs,9, '  - Planar bitmap and additional support');
	xprintf(textwindowx+5,50+48,VisiblePageOffs,9, '      for clipping');
	xprintf(textwindowx+5,50+58,VisiblePageOffs,9, '  - mouse module');
	xprintf(textwindowx+5,50+68,VisiblePageOffs,9, '  - *FAST* filled and clipped triangles ideal for');
	xprintf(textwindowx+5,50+78,VisiblePageOffs,9, '   3D work. Thanks to S. Dollins for the code.');
	xprintf(textwindowx+5,50+88,VisiblePageOffs,9, '  - Filled and clipped polygons');
	xprintf(textwindowx+5,50+98,VisiblePageOffs,9, '  - Virtual VSync Handler');
	waitforkeypress;

	xhidemouse;
	for i := 0 to 149 do
	begin
		xcircle(0, 0, i, 181 - i, VisiblePageOffs);
		xcircle(360 - i, 0, i, i + 30, VisiblePageOffs);
		xcircle(0, 200 - i, i, i + 30, VisiblePageOffs);
		xcircle(360 - i, 200 - i, i, 181 - i, VisiblePageOffs);
	end;
	for i := 0 to 99 do
		xfilledcircle(80 + i, i, 201 - (i shl 1), 30+i, VisiblePageOffs);
	xshowmouse;
	waitforkeypress;
	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'XLibPas Exclusive Functions!');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'XLibPas Exclusive Functions!');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, ' Functions include:');
	xprintf(textwindowx+5,50+10,VisiblePageOffs,9, '  - LZS encoding/decoding');
	xprintf(textwindowx+5,50+20,VisiblePageOffs,9, '  - Archives');
	xprintf(textwindowx+5,50+30,VisiblePageOffs,9, '  - Bitmap scaling');
	xprintf(textwindowx+5,50+40,VisiblePageOffs,9, '  - Mouse integrated in Virtual VSync code');
	xprintf(textwindowx+5,50+50,VisiblePageOffs,9, '  - GIF/BMP encoding/decoding');
	xprintf(textwindowx+5,50+60,VisiblePageOffs,9, '  - XLARC, an XLA compression program');
	xprintf(textwindowx+5,50+70,VisiblePageOffs,9, '  - XCONVERT, for format conversion');
	xprintf(textwindowx+5,50+80,VisiblePageOffs,9, '  - Protected mode (experimental)');

	waitforkeypress;

	randomize;
	xhidemouse;
	while keypressed do readkey;
	while MouseButtonStatus=LeftPressed do;
	palscrolldir:=1-palscrolldir;
	repeat

		i:=random(256);
		x0:=random(ScrnLogicalPixelWidth);
		x1:=random(ScrnLogicalPixelWidth);
		x2:=random(ScrnLogicalPixelWidth);
		y0:=random(ScrnPhysicalHeight);
		y1:=random(ScrnPhysicalHeight);
		y2:=random(ScrnPhysicalHeight);
		xtriangle(x0,y0,x1,y1,x2,y2,i,VisiblePageOffs);
	until (keypressed) or (MouseButtonStatus=LeftPressed);
	while keypressed do readkey;
	while (MouseButtonStatus=LeftPressed) do;

	subsequentpage;
	xpos := xcentre(180,textwindowy+18,VisiblePageOffs,6,'PLEASE...');
	xprintf(xpos-1,textwindowy+17,VisiblePageOffs,3,'PLEASE...');
	xsetfont(2);
	xprintf(textwindowx+5,50   ,VisiblePageOffs,9, '   Please mention my name in programs that use XLIB');
	xprintf(textwindowx+5,50+8 ,VisiblePageOffs,9, ' just to make me feel it was worth the effort.');
	xprintf(textwindowx+5,50+16,VisiblePageOffs,9, ' If you have any bug to report please feel free to');
	xprintf(textwindowx+5,50+24,VisiblePageOffs,9, ' mail me a message. Any hints, suggestions and');
	xprintf(textwindowx+5,50+32,VisiblePageOffs,9, ' contributions are welcome and encouraged.');
	xprintf(textwindowx+5,50+52,VisiblePageOffs,9, ' I have contributed this code to the public domain.');
	xprintf(textwindowx+5,50+60,VisiblePageOffs,9, '    Please respect my wishes and leave it there.');

	xprintf(textwindowx+5,50+80,VisiblePageOffs,9, '   Finally, I hope you all find this stuff useful,');
	xcentre(180,50+106,VisiblePageOffs,9, ' Tristan Tarrant - tristant@cogs.susx.ac.uk');

	waitforkeypress;

	xhidemouse;

	xshiftrect (27, 27, 360-27, 177, 27, 23, VisiblePageOffs);
	xrectfill(25, 173, 335, 176, VisiblePageOffs, 1);
	for i := 0 to 49 do
		xshiftrect (27, 26, 360-27, 177 - (i * 3), 27, 23, VisiblePageOffs);
end;

begin
	SaveExitProc := ExitProc;
	ExitProc := @quit;
	main;
end.


