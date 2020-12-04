Unit Xlib2;

{#F
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ				 XLIB v2.0 - Graphics Library for Borland/Turbo Pascal 7.0          บ
บ                                                                           บ
บ               Tristan Tarrant - tristant@cogs.susx.ac.uk                  บ
บ                                                                           บ
ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บ                                                                           บ
บ                                 Credits                                   บ
บ                                                                           บ
บ                             Themie Gouthas                                บ
บ                                                                           บ
บ                            Matthew MacKenzie                              บ
บ                                                                           บ
บ                             Tore Bastiansen                               บ
บ                                                                           บ
บ                                 Andy Tam                                  บ
บ                                                                           บ
บ                               Douglas Webb                                บ
บ                                                                           บ
บ                              John  Schlagel                               บ
บ                                                                           บ
ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
บ                                                                           บ
บ           I informally reserve all rights to the code in XLIB             บ
บ       Rights to contributed code is also assumed to be reserved by        บ
บ                          the original authors.                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

	XLibPas v2.0 is a set of libraries and utilities that allow you to use some
	extended features of the standard VGA adapter which are not exploited in
	mode 13h. The most important features are :
		- Use of all of the 256k of standard VGA memory
		- Several tweaked resolutions, all in 256 colours
		- Multiple pages, double- and triple-buffering, page flipping
				and panning
		- Split screen
		- Planar, Video and Compiled bitmaps
		- Drawing procedures (line,circle,pixel,boxes,filling,polygons)
		- Text handling supporting user fonts
		- Archiving and compression
		- GIF/BMP encoding and decoding
		- Bitmap scaling
		- Virtual VSync handler
		- Mouse routines
		- Palette handling
		- ...and (at long last) Protected Mode (experimental)}
{#F}

{$A+,B-,E-,G+,N-,O-,P-,Q-,S-,T-,X+}

{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}

Interface

Type
	Vertex = record
		x, y : word;
	end;
	AlignmentHeader = record
		size, ImageWidth, ImageHeight : word;
		alignments : array[0..3] of
		record
			 ImagePtr, MaskPtr : word;
		end;
	end; { Data structure for VBMs. See #XBm2# }
	LBMHeader = record
		width, height : byte;
	end;
	PAlignmentHeader = ^AlignmentHeader;
Const
	XMode320x200  = 0;       {320x200x256 colors - 4.0+ pages}
	XMode320x240  = 1;       {320x240x256 colors - 3.4+ pages - Square Pixels}
	XMode360x200  = 2;       {360x200x256 colors - 3.6+ pages}
	XMode360x240  = 3;       {360x240x256 colors - 3.0+ pages}
	XMode376x282  = 4;       {376x282x256 colors - 2.4+ pages - Square Pixels}
	XMode320x400  = 5;       {320x400x256 colors - 2.0+ pages}
	XMode320x480  = 6;       {320x480x256 colors - 1.7+ pages}
	XMode360x400  = 7;       {360x400x256 colors - 1.8+ pages}
	XMode360x480  = 8;       {360x480x256 colors - 1.5+ pages}
	XMode360x360  = 9;       {360x360x256 colors - 2.0+ pages}
	XMode376x308  = 10;      {376x308x256 colors - 2.2+ pages}
	XMode376x564  = 11;      {376x564x256 colors - 1.2+ pages}
	XMode256x200  = 12;      {256x200x256 colors - 5.1+ pages}
	XMode256x240  = 13;      {256x240x256 colors - 4.2+ pages}
	XMode256x224  = 14;      {256x224x256 colors - 4.5+ pages}
	XMode256x256  = 15;      {256x256x256 colors - 4.0  pages}
	XMode360x270  = 16;      {360x270x256 colors - 2.6+ pages - Square Pixels}
	XMode400x300  = 17;      {400x300x256 colors - 2.1+ pages - Square Pixels}

	LastMode      = 17;      {Number of modes available}

	RBackward     = 0;       {Rotate palette bacwards}
	RForward      = 1;       {Rotate palette forwards}
	InvalidXMode  = -1;      {Selected mode is invalid i.e. it does not exist}
	Error         = 1;
{ An error has occured while executing an XLib procedure or function }
	LeftPressed   = 1;       {Left Mouse button is pressed}
	RightPressed  = 2;       {Right Mouse button is pressed}
	{#Z+}
	AlignData     = 6;
	ColumnMask : array[0..3] of byte =
		( $11, $22, $44, $88 );
	InitMouseDef : array[0..13] of byte =
		(1,3,7,15,31,63,127,255,31,27,48,48,96,96);
	{#Z-}

Var
	InGraphics, {1 if in a graphics mode, 0 otherwise}
	ErrorValue, {Set by every routine to indicate success or failure}
	FontDriverActive, {Set after a call to xtextinit}
	CharHeight, {Height of the current character set}
	CharWidth, {Width of the current character set}
	FirstChar, {First character in character set}
	UserChHeight, {Height of the User Font}
	UserChWidth, {Width of the User Font}
	UserFirstCh, {First character in User's font}
	DoubleScanFlag : Byte; {1 if mode is double-scanned, 0 otherwise}
	CurrXMode, {Contains value of current graphics mode}
	ScrnPhysicalByteWidth, {Physical width of the screen in bytes ( ie : group of 4 pixels )}
	ScrnPhysicalPixelWidth, {Physical width of the screen in pixels}
	ScrnPhysicalHeight, {Physical height of the screen in pixels}
	SplitScrnOffs, {Offset in VRAM of Split Screen}
	SplitScrnScanLine, {Screen Line where Split Screen is displayed}
	SplitScrnVisibleHeight, {Height of the visible part of the split screen}
	SplitScrnActive, {Contains 1 if SplitScreen is visible,0 otherwise}
	Page0Offs, {Offset in VRAM of 1st page}
	Page1Offs, {Offset in VRAM of 2nd page ( #XSetDoubleBuffer# )}
	Page2Offs, {Offset in VRAM of 3rd page ( #XSetTripleBuffer# )}
	ScrnLogicalByteWidth, {Width in bytes ( groups of 4 pixels ) of a page}
	ScrnLogicalPixelWidth, {Width in pixels of a page}
	ScrnLogicalHeight, {Height in pixels of a page}
	MaxScrollX, {Maximum value for left edge of screen}
	MaxScrollY, {Maximum value for top edge of screen}
	DoubleBufferActive, {Set by #XSetDoubleBuffer#}
	TripleBufferActive, {Set by #XSetTripleBuffer#}
	VisiblePageIdx, {Number of the Visible Page}
	HiddenPageOffs, {Offset of the Hidden page}
	VisiblePageOffs, {Offset of the Visible page}
	WaitingPageOffs, {Offset of the Waiting page}
	NonVisualOffs, {Offset of start of unused VRAM}
	TopClip, {Top clipping edge}
	BottomClip,{Bottom clipping edge}
	LeftClip, {Left clipping edge}
	RightClip, {Right clipping edge}
	PhysicalStartPixelX, {X coordinate of top left pixel}
	PhysicalStartByteX, {X coordinate of top left pixel /4}
	PhysicalStartY, {Y coordinate of top left pixel}
	VsyncHandlerActive, {set to 1 if the VSync handler has been installed}
	MouseRefreshFlag, {set to 1 if the mouse pointer needs refreshing}
	StartAddressFlag, {if set to 0 then it's possible to #xpageflip#}
	MouseInstalled, {set to 1 if the Mouse handler has been installed}
	MouseHidden, {set to 1 if after a call to #XHideMouse#}
	MouseButtonStatus, {information on the button presses}
	MouseButtonCount, {the number of buttons on the mouse}
	MouseX, {X coordinate of mouse pointer}
	MouseY, {Y coordinate of mouse pointer}
	ScreenSeg : word; {Segment/Selector of VRAM}
	MouseFrozen, {set to 1 if you want to update the mouse manually}
	MouseColor : byte;  {color of the mouse pointer}

Function  XSetMode( Mode, WidthInPixels : Word ) : Word;
{ Mode            - The required mode
	WidthInPixels   - The width of the logical screen

	This function initialises the graphics system, setting the apropriate
	screen resolution and allocating a virtual screen. The virtual screen
	allocated may not necessarily be of the same size as specified in the
	WidthInPixels parameter as it is rounded down to the nearest
	multiple of 4.

	The function returns the actual width of the allocated virtual screen
	in pixels if a valid mode was selected otherwise returns
	XMODEINVALID.}
Procedure XSelectDefaultPlane( Plane : Byte );
{ Enables default Read/Write access to a specified plane}
Procedure XSetSplitscreen( Line : Word );
{   line - The starting scan line of the required split screen.

	This function activates Mode X split screen and sets starting scan line
	The split screen resides on the bottom half of the screen and has a
	starting address of A000:0000 in video RAM.

	It also Updates Page0Offs to reflect the existence of the split screen
	region ie MainScrnOffset is set to the offset of the first pixel
	beyond the split screen region. Other variables set are #Page1Offs# which
	is set to the same value as #Page0Offs# (see graphics call sequence below),
	#ScrnLogicalHeight#,#ScrnPhysicalHeight#, #SplitScrnScanLine# and
	#MaxScrollY#.

	This function cannot be called after double buffering has been activated,
	it will return an error. To configure your graphics environment the
	sequence of graphics calls is as follows although either or both steps b
	and c may be omitted:
		a) #XSetMode#
		b) #XSetSplitScreen#
		c) #XSetDoubleBuffer#
	Thus when you call this function successfully, double buffering is not
	active so #Page1Offs# is set to the same address as #Page0Offs#.

	WARNING: If you use one of the high resolution modes (376x564 as an
	extreme example) you may not have enough video ram for split screen
	and double buffering options since VGA video RAM is restricted to 64K.}
Procedure XSetStartAddr( X, Y : Word );
{ X,Y - coordinates of top left corner of physical screen within current
	virtual screen.

	Set Mode X non split screen physical start address within current virtual
	page.

	X must not exceed (Logical screen width - Physical screen width)
	ie #MaxScrollX# and Y must not exceed (Logical screen height -
	Physical screen height) ie #MaxScrollY#}
Procedure XHideSplitscreen;
{ This function hides an existing split screen by setting its starting
	scan line to the last physical screen scan line.
	ScreenPhysicalHeight is adjusted but the SplitScreenScanLine is not
	altered as it is required for restoring the split screen at a later stage.

	WARNING: Only to be used if #XSetSplitScreen# has been previously called
		 The memory for  the initial split screen is reserved and the size
		 limitations of certain modes means any change in the split screen scan
		 line will encroach on the split screen ram.}
Procedure XShowSplitscreen;
{ Restores split screen start scan line to the initial split screen
	starting scan line as set by #XSetSplitScreen#.
	#ScreenPhysicalHeight# is adjusted.

	WARNING: Only to be used if #XSetSplitScrnLine# has been previously called
		 The memory for the initial split screen is reserved and the size
		 limitations of certain modes means any change in the split screen scan
		 line will encroach on the split screen ram.}
Procedure XAdjustSplitscreen( Line : Word );
{ line - The scan line at which the split screen is to start.

	Sets the split screen start scan line to a new scan line. Valid scan lines
	are between the initial split screen starting scan line and the last
	physical screen scan line. ScreenPhysicalHeight is also adjusted.

	WARNING: Only to be used if #XSetSplitScreen# has been previously called
		 The memory for the initial split screen is reserved and the size
		 limitations of certain modes means any change in the split screen scan
		 line will encroach on the split screen ram.}
Procedure XSetDoubleBuffer( PageHeight : Word );
{   PageHeight    - The height of the two double buffering virtual screens.
		Returns       - The closest possible height to the specified.

	This function sets up two double buffering virtual pages. ErrorValue
	is set according to the success or failure of this command.

	Other variables set are:

		#Page1Offs#            -  Offset of second virtual page
		#NonVisualOffs#        -  Offset of first non visible video ram byte
		#DoubleBufferActive#   -  Flag
		#ScrnLogicalHeight#    -  Logical height of the double buffering pages
		#MaxScrollY#           -  Max vertical start address of physical screen
														within the virtual screen

	WARNING: If you use one of the high resolution modes (376x564 as an
		 extreme example) you may not have enough video ram for split screen
		 and double buffering options since VGA video RAM for is restricted to
		 256K.}
Procedure XSetTripleBuffer( PageHeight : word );
{ This procedure behaves like #XDoubleBuffer#, but when used with
	#XInstallVSyncHandler# you can draw immediately after a page flip.
	When #XPageFlip# is called, #VisiblePageOffs# is set to the page that
	will be display next vsync. Until then, #WaitingPageOffs# will be displayed.
	You can draw to #HiddenPageOffs#.}
Procedure XPageFlip( X, Y : Word );
{ X,Y - coordinates of top left corner of physical screen within the
	the hidden virtual screen if double buffering is active, or
	the current virtual screen otherwise.

	Sets the physical screen start address within currently hidden virtual
	page and then flips pages. If double buffering is not active then this
	function is functionally equivalent to #XSetStartAddr#.

	X must not exceed (Logical screen width - Physical screen width)
	ie #MaxScrollX# and Y must not exceed (Logical screen height -
	Physical screen height) ie #MaxScrollY#}
Procedure XSetClipRect( Left, Top, Right, Bottom : Word );
{  Defines the clipping rectangle for clipping versions of planar and video
	bitmap puts.

	NOTE: Compiled bitmaps cannot be clipped.}
Procedure XTextMode;
{ Disables graphics mode.}
Procedure XWaitVsync;
{ Waits for a vsync to occur : i.e. when the electron beam that's refreshing
	the video image has reached the bottom of the screen.}
Procedure XLine( x1, y1, x2, y2, Color, PgOffs : word );
{ Draw a line with the specified end points in the page starting at
	offset PgOffs.

	No Clipping is performed.}
Procedure XPutPix( X,Y,PgOfs,Color:word );
{ Draw a point of specified colour at coordinates X,Y within the virtual page
	starting at offset PgOfs.}
Function  XGetPix( x,y,PageBase:word ) : word;
{ Read a point of at coordinates X,Y within the virtual page starting
	at offset PageBase.}
Procedure XRectFill( StartX,StartY,EndX,EndY,PageBase,Color:word );
{   StartX,StartY - Coordinates of upper left hand corner of rectangle
		EndX,EndY     - Coordinates of lower right hand corner of rectangle
		PageBase      - Offset of virtual screen
		Color         - Color of the box.


	Mode X rectangle fill routine. This procedure draw a rectangle with
	upper left coordinates (StartX,StartY) and lower right coordinates
	(EndX, Endy) at offset PageBase in color Color}
Procedure XRectPattern( StartX,StartY,EndX,EndY,PageBase:word; var Pattern);
{   StartX,StartY - Coordinates of upper left hand corner of rectangle
		EndX,EndY     - Coordinates of lower right hand corner of rectangle
		PageBase      - Offset of virtual screen
		Pattern       - Untyped variable for the user defined pattern (16 bytes)


	Mode X rectangle 4x4 pattern fill routine.

	Upper left corner of pattern is always aligned to a multiple-of-4
	row and column. Works on all VGAs. Uses approach of copying the
	pattern to off-screen display memory, then loading the latches with
	the pattern for each scan line and filling each scan line four
	pixels at a time. Fills up to but not including the column at EndX
	and the row at EndY. No clipping is performed.

	Warning the VGA memory locations PATTERNBUFFER (A000:FFFc) to
	A000:FFFF are reserved for the pattern buffer}
Procedure XCpVidPage( SourceOffs, DestOffs : word );
{   SourceOffs    - Offset of source video page
		DestOffs      - Offset of destination page

	Copies the contents of page SourceOffs to DestOffs. Twice as fast as a
	#XCpVidRect# would be (because it uses less parameters, so less stack work is
	required).}
Procedure XCpVidRect( SrcStartX,SrcStartY,SrcEndX,SrcEndY,DestStartX,
					DestStartY,SrcPageBase,DestPageBase,SrcBitmapW,
					DestBitmapW:word );
{   StartX,StartY - Coordinates of upper left hand corner of source rectangle
		EndX,EndY     - Coordinates of lower right hand corner of source rectangle
		DestStartX,DestStartY - Coordinates of rectangle destination
		SourcePageBase        - source rectangle page offset
		DestPageBase          - destination rectangles page offset
		SourceBitmapWidth     - width of bitmap within the source virtual screen
					containing the source rectangle
		DestBitmapWidth       - width of bitmap within the dest. virtual screen
					containing the destination rectangle

	Mode X display memory to display memory copy
	routine. Left edge of source rectangle modulo 4 must equal left edge
	of destination rectangle modulo 4. Works on all VGAs. Uses approach
	of reading 4 pixels at a time from the source into the latches, then
	writing the latches to the destination. Copies up to but not
	including the column at SrcEndX and the row at SrcEndY. No
	clipping is performed. Results are not guaranteed if the source and
	destination overlap.
	If you want to copy an entire page to another use #XCpVidPage# instead}
Procedure XShiftRect( SrcLeft,SrcTop,SrcRight,SrcBottom,DestLeft,DestTop,
					ScreenOffs:word );
{   SrcLeft, SrcTop - Coordinates of upper left hand corner of rectangle
		SrcRight, SrcBottom - Coordinates of lower right hand corner of rectangle
		DestLeft, DestTop - Coordinates of upper left corner of destination
		ScreenOffs    - Offset of virtual screen

	This function copies a rectangle of VRAM onto another area of VRAM,
	even if the destination overlaps with the source.  It is designed
	for scrolling text up and down, and for moving large areas of screens
	around in tiling systems.  It rounds all horizontal coordinates to
	the nearest byte (4-column chunk) for the sake of speed.  This means
	that it can NOT perform smooth horizontal scrolling.  For that,
	either scroll the whole screen (minus the split screen), or copy
	smaller areas through system memory using the functions in the
	#XBM2# module.

	SrcRight is rounded up, and the left edges are rounded down, to
	ensure that the pixels pointed to by the arguments are inside the
	the rectangle.  That is, SrcRight is treated as (SrcRight+3) >> 2,
	and SrcLeft as SrcLeft >> 2.

	The width of the rectangle in bytes (width in pixels / 4)
	cannot exceed 255.}
Procedure XCircle( Left, Top, Diameter, Color, ScreenOffs:word );
{ Draws a circle with the given upper-left-hand corner and diameter,
	which are given in pixels.}
Procedure XFilledCircle( Left, Top, Diameter, Color, ScreenOffs:word );
{ Draws a filled circle with the given upper-left-hand corner and
	diameter.}
Procedure XGetPalStruc( var PalBuff; NumColors,StartColor:word );
{	Read DAC palette into annotated type buffer with interrupts disabled
	ie byte colours to skip, byte colours to set, r1,g1,b1,r1,g2,b2...rn,gn,bn

	WARNING: memory for the palette buffers must all be pre-allocated}
Procedure XGetPalRaw( Var PalBuff; NumColors,StartColor:word );
{	Read DAC palette into raw buffer with interrupts disabled
	ie byte r1,g1,b1,r1,g2,b2...rn,gn,bn

	WARNING: Memory for the palette buffers must all be pre-allocated.}
Procedure XPutPalStruc( Var CompPalBuff );
{	Write DAC palette from annotated type buffer with interrupts disabled
	ie byte colours to skip, byte colours to set, r1,g1,b1,r1,g2,b2...rn,gn,bn}
Procedure XTransposePalStruc( Var CompPalBuff; StartColor:word );
{	Write DAC palette from annotated type buffer with interrupts disabled
	starting at a new palette index.}
Procedure XPutPalRaw( Var PalBuff; NumColors,StartColor:word );
{	Write DAC palette from raw buffer with interrupts disabled
	ie byte r1,g1,b1,r1,g2,b2...rn,gn,bn}
Procedure XSetRGB( ColorIndex,R,G,B:byte );
{	Set the RGB components of a vga color}
Procedure XRotPalStruc( Var PalBuff; Direction:word );
{	Rotate annotated palette buffer entries. Direction 0 = backward,
	1 = forward.}
Procedure XRotPalRaw( Var PalBuff; Direction, NumColors:word );
{	Rotate a raw palette buffer. Direction 0 = backward,
	1 = forward.}
Function  XCpContrastPalStruc( Var PalSrcBuff,PalDestBuff; Intensity:byte ) : word;
{	Copy one annotated palette buffer to another making the intensity
	adjustment. Used in fading in and out fast and smoothly.}
Procedure XPutContrastPalStruc( Var CompPalBuff; Intensity:byte );
{	Write DAC palette from annotated type buffer with specified intensity
	adjustment (ie palette entries are decremented where possible by
	intensity units).

	Designed for fading in or out a palette without using an intermediate
	working palette buffer ! (Slow but memory efficient ... OK for small
	pal strucs)}
Function  XCharPut( Chr:char; X, Y, ScrnOffs, Color:word ) : byte;
{	Draw a text character at the specified location with the specified
	color.

		ch       -  char to draw
		x,y      -  screen coords at which to draw ch
		ScrnOffs -  Starting offset of page on whih to draw
		Color    -  Color of the text

	WARNING: xtextinit must be called before using this function}
Procedure XSetFont( FontID : word );
{	Procedure xsetfont(FontId : word);

	Select the working font where 0 = VGA ROM 8x8, 1 = VGA ROM 8x14
	2 = User defined bitmapped font.

	WARNING: A user font must be registered before setting FontID 2 by
					 using procedure #XRegisterUserFont#}
Procedure XTextInit;
{	Initializes the Mode X text driver and sets the default font (VGA ROM 8x8)}
Procedure XRegisterUserFont( var FontToRegister );
{	Register a user font for later selection. Only one user font can be
	registered at any given time. Registering a user font deregisters the
	previous user font. User fonts may be at most 8 pixels wide.

	USER FONT STRUCTURE

	Word:  ascii code of first char in font
	Byte:  Height of chars in font
	Byte:  Width of chars in font
	n*h*Byte: the font data where n = number of chars and h = height
		of chars

	WARNING: The onus is on the program to ensure that all characters
		 drawn whilst this font is active, are within the range of
		 characters defined.}
Function  XGetCharWidth( ch : char ) : byte;
{	Returns the width in pixels of character ch in the currently selected font.}
Function  XPrintf( x, y, ScrnOffs, Color : word; s : string ) : integer;
{		x,y      -  screen coords at which to draw s
		ScrnOffs -  Starting offset of page on whih to draw
		Color    -  Color of the text
		s        -  The string to be displayed

	Displays the string s at coordinates x,y on page ScrnOffs in Color.
	Returns the width of the string in pixels.}
Function  XBgPrintf( x, y, ScrnOffs, fgcolor, bgcolor : word; s : string ) : integer;
{		x,y      -  screen coords at which to draw s
		ScrnOffs -  Starting offset of page on whih to draw
		fgcolor  -  Color of the text foreground
		bgcolor  -  Color of the text background
		s        -  The string to be displayed

	Same as #XPrintf# but erases the background of the string with color bgcolor.}
Function  XCentre( x, y, ScrnOffs, color : word; s : string ) : integer;
{		x,y      -  screen coords at which to draw s
		ScrnOffs -  Starting offset of page on whih to draw
		color    -  Color of the text foreground
		s        -  The string to be displayed

	Same as #XPrintf# but centres the string with respect to x}
Function  XBgCentre( x, y, ScrnOffs, fgcolor, bgcolor : word; s : string ) : integer;
{		x,y      -  screen coords at which to draw s
		ScrnOffs -  Starting offset of page on whih to draw
		fgcolor  -  Color of the text foreground
		bgcolor  -  Color of the text background
		s        -  The string to be displayed

	Same as #XCentre# but erases the background of the string with color bgcolor}

function  XStrWidth( s : string ) : integer;
{ Returns the width in pixels of the string s}
Procedure XTriangle( X0, Y0, X1, Y1, X2, Y2, Color, PageOffset:word );
{ This function draws a filled triangle which is clipped to the current
	clipping window defined by #TopClip#,#BottomClip#,#LeftClip#,#RightClip#.
	Remember: the X clipping variable are in byteS not PIXELS so you can only
	clip to 4 pixel byte boundaries.}
Procedure XPolygon( var vertices; numvertices, Color, PageOffset:word );
{ This function is similar to the triangle function but draws
	convex polygons. The vertices are supplied as an array of vertices.

	NOTE: a convex polygon is one such that if you draw a line from
	any two vertices, every point on that line will be within the
	polygon.

	This function works by splitting up a polygon into its component
	triangles and calling the triangle routine above to draw each one.
	Performance is respectable but a custom polygon routine might be
	faster.}
Procedure XPutCursor( X, Y, TopClip, BottomClip, ScrnOffs : word );
{ Display the mouse pointer at coordinated X,Y on page ScrnOffs}
Procedure XDefineMouseCursor( var MouseDef; MouseColor:byte );
{	  MouseDef - a buffer of 14 characters containing a bitmask for all the
			 cursor's rows.
		MouseColor - The colour to use when drawing the mouse cursor.

	Define a mouse cursor shape for use in subsequent cursor redraws. XLib
	has a hardwired mouse cursor size of 8 pixels across by 14 pixels down.

	WARNING: This function assumes MouseDef points to 14 bytes.

	Note: Bit order is in reverse. ie bit 7 represents pixel 0 ..
		bit 0 represents pixel 7 in each MouseDef byte.}
function XMouseInit:integer;
{	Initialize the mouse driver functions and install the mouse event handler
	function. This is the first function you must call before using any of the
	mouse functions. This mouse code uses the fastest possible techniques to
	save and restore mouse backgrounds and to draw the mouse cursor.

	WARNING: This function uses and updates NonVisualOffset to allocate
		 video ram for the saved mouse background.

	LIMITATIONS: No clipping is supported horizontally for the mouse cursor
				 No validity checking is performed for NonVisualOffs

	**WARNING** You must Hide or at least Freeze the mouse cursor while drawing
	using any of the other XLIB procedures since the mouse handler may
	modify vga register settings at any time. VGA register settings
	are not preserved which will result in unpredictable drawing behavior.
	If you know the drawing will occur away from the mouse cursor set
	#MouseFrozen# to 1, do your drawing  then set it to 0.
	Alternatively call #XHideMouse#, perform your drawing and then call
	#XShowMouse#. Another alternative is to disable interrupts while drawing
	but usually drawing takes up alot of time and having interrupts
	disabled for too long is not a good idea.
	If you are using the Virtual VSync Handler and just updating the palette
	you don't need to freeze the mouse.}
Procedure XMouseWindow( x0, y0, x1, y1:word );
{	Defines a mouse window. The mouse can't move outside the boundaries
	specified.}
procedure XShowMouse;
{	Makes the cursor visible if it was previously hidden.
	See also : #XHideMouse#}
Procedure XHideMouse;
{	Makes the cursor hidden if it was previously visible.
	See also : #XShowMouse#}
Procedure XMouseRemove;
{ Stop mouse event handling and remove the mouse handler.

	NOTE: This function MUST be called before quitting the program if
	a mouse handler has been installed}
Procedure XPositionMouse( X, Y : word );
{	Positions the mouse at a specified location}
Procedure XUpdateMouse;
{	Forces the mouse position to be updated and cursor to be redrawn.
	Note: this function is useful when you have set #MouseFrozen# to true.
	Allows the cursor position to be updated manually rather than
	automatically by the installed handler.}
Function  XFloodFill( X, Y, PgOfs, Color:word ) : word;
{	This function performs the familiar flood filling used by many
	paint programs and of course the Borland BGI's flood fill function.
	The pixel at x,y and all adjacent pixels of the same color are filled
	to the new color. Filling stops when there are no more adjacent pixels
	of the original pixel's color. The function returns the number of
	pixels that have been filled.}
Function  XBoundaryFill( X, Y, PgOfs, BoundaryColor, Color : word ) : word;
{	This function is a variant of the flood fill described above. This
	function, unlike the above function, can fill across color boundaries.
	Filling stops when the area being filled is fully enclosed by pixels
	of the color boundary. Again, this function returns the number of
	pixels filled.}
Procedure XInstallVSyncHandler( VrtsToSkip : word );
{	This function installs the vsync handler using timer 0. It's called
	about 100 microseconds before every vertical retrace.

	The VrtsToSkip value (>=1) defines the delay in VRT's between consecutive
	physical screen start address changes, thus allowing you to limit the
	maximum frame rate for page flips in animation systems. The frame rate
	is calculated as Vertical refresh rate / VrtsToSkip, eg for
	320x240 mode which refreshes at 60Hz a VrtsToSkip value of 3 will result
	in a maximum page flipping rate of 20Hz (frames per second)

	WARNING:  Be sure to remove it before exiting.
	When used with a debugger, the system clock may speed up.
}
Procedure XRemoveVSyncHandler;
{	This routine MUST be called before exiting (or aborting) the program,
	or your system will crash.}
Procedure XSetUserVSyncHandler( handler : pointer );
{	Installs a user routine to be called once each vertical retrace. The user
	handler has its own stack of 256 bytes.
	WARNING: This installs an interrupt driven handler, beware of the following:
		 Only 8086 registers are preserved. If you're using 386 code, save
		 all the 386 regs.
		 Don't do any drawing.
		 Don't call any DOS functions.

	So why use it?
	Well, you can update global variables if you're careful. And it's nice for
	palette animation. You can even do fades while loading from disk. You
	should use this instead of installing your own int08h routine and chain
	to the original.}

Implementation

type
	VBMInfoStruc = record
		 Size, ImageWidth, ImageHeight : word;
	end;
	VBMAlignmentStruc = record
		 ImagePtr, MaskPtr : word;
	end;

const
	X320Y200 : array[0..4] of word =
		( $0200, $0014, $E317, 320, 200 );
  X320Y240 : array[0..12] of word =
    ( $0AE3, $0D06, $3E07, $4109, $EA10, $AC11, $DF12, $0014, $E715, $0616,
      $E317, 320, 240 );
  X360Y200 : array[0..10] of word =
    ( $08E7, $6B00, $5901, $5A02, $8E03, $5E04, $8A05, $0014, $E317, 360,
      200 );
	X360Y240 : array[0..19] of word =
    ( $11E7, $6b00, $5901, $5A02, $8E03, $5E04, $8A05, $0D06, $3E07, $4109,
      $EA10, $AC11, $DF12, $2D13, $0014, $E715, $0616, $E317, 360, 240 );
  X376Y282 : array[0..20] of word =
    ( $12E7, $6e00, $5d01, $5e02, $9103, $6204, $8f05, $6206, $f007, $6109,
      $310f, $3710, $8911, $3312, $2f13, $0014, $3C15, $5C16, $e317, 376,
      282 );
  X256Y400 : array[0..11] of word  =
    ( $08E3, $5f00, $3f01, $4202, $9f03, $4c04, $0005, $4009, $0014, $E317,
			256, 400 );
  X256Y480 : array[0..18] of word =
    ( $10e3, $5f00, $3f01, $4202, $9f03, $4c04, $0005, $0d06, $3e07, $4009,
      $ea10, $ac11, $df12, $0014, $e715, $0616, $e317, 256, 480 );
  X320Y400 : array[0..5] of word =
    ( $03e3, $4009, $0014, $e317, 320, 400 );
  X320Y480 : array[0..12] of word =
    ( $0AE3, $0D06, $3E07, $4009, $EA10, $AC11, $DF12, $0014, $E715, $0616,
      $E317, 320, 480 );
  X360Y400 : array[0..11] of word =
    ( $09E7, $6B00, $5901, $5A02, $8E03, $5E04, $8A05, $4009, $0014, $E317,
      360, 400 );
	X360Y480 : array[0..19] of word =
    ( $11E7, $6B00, $5901, $5A02, $8E03, $5E04, $8A05, $0D06, $3E07, $4009,
      $EA10, $AC11, $DF12, $2D13, $0014, $E715, $0616, $E317, 360, 480 );
  X360Y360 : array[0..17] of word =
    ( $0FE7, $6b00, $5901, $5A02, $8E03, $5E04, $8A05, $4009, $8810, $8511,
      $6712, $2D13, $0014, $6D15, $BA16, $E317, 360, 360 );
  X376Y308 : array[0..20] of word =
    ( $12E7, $6E00, $5D01, $5E02, $9103, $6204, $8F05, $6206, $0F07, $4009,
      $310F, $3710, $8911, $3312, $2F13, $0014, $3C15, $5C16, $E317, 376,
			308 );
  X376Y564 : array[0..20] of word =
    ( $12E7, $6E00, $5D01, $5E02, $9103, $06204, $8F05, $6206, $F007, $6109,
      $310F, $3710, $8911, $3312, $2F13, $0014, $3C15, $5C16, $E317, 376,
      564 );
  X256Y200 : array[0..10] of word =
    ( $08e3, $5f00, $3f01, $4202, $9f03, $4c04, $0005, $0014, $e317, 256,
      200 );
  X256Y240 : array[0..18] of word =
    ( $10e3, $5f00, $3f01, $4202, $9f03, $4c04, $0005, $0d06, $3e07, $4109,
      $ea10, $ac11, $df12, $0014, $e715, $0616, $e317, 256, 240 );
  X256Y224 : array[0..20] of word =
    ( $12e3, $5f00, $3f01, $4202, $8203, $4a04, $9a05, $0b06, $3e07, $0008,
      $4109, $da10, $9c11, $bf12, $2013, $0014, $c715, $0416, $e317, 256,
      224 );
  X256Y256 : array[0..20] of word =
    ( $12e3, $5f00, $3f01, $4002, $8203, $4a04, $9a05, $2306, $b207, $0008,
      $6109, $0a10, $ac11, $ff12, $2013, $0014, $0715, $1a16, $e317, 256,
      256 );
  X360Y270 : array[0..20] of word =
    ( $12e7, $6b00, $5901, $5a02, $8e03, $5e04, $8a05, $3006, $f007, $0008,
			$6109, $2010, $a911, $1b12, $2d13, $0014, $1f15, $2f16, $e317, 360,
      270 );
  X400Y300 : array[0..20] of word =
    ( $12a7, $7100, $6301, $6402, $9203, $6504, $8205, $4606, $1f07, $0008,
      $4009, $3110, $8011, $2b12, $3213, $0014, $2f15, $4416, $e317, 400,
      300 );
  ModeTable : array[0..17] of word =
    ( Ofs(X320Y200[0]), Ofs(X320Y240[0]), Ofs(X360Y200[0]), Ofs(X360Y240[0]),
      Ofs(X376Y282[0]), Ofs(X320Y400[0]), Ofs(X320Y480[0]), Ofs(X360Y400[0]),
      Ofs(X360Y480[0]), Ofs(X360Y360[0]), Ofs(X376Y308[0]), Ofs(X376Y564[0]),
      Ofs(X256Y200[0]), Ofs(X256Y240[0]), Ofs(X256Y224[0]), Ofs(X256Y256[0]),
      Ofs(X360Y270[0]), Ofs(X400Y300[0]) );

  MirrorTable : array[0..255] of byte =
		( 0,128, 64,192, 32,160, 96,224, 16,144, 80,208, 48,176,112,240,
			8,136, 72,200, 40,168,104,232, 24,152, 88,216, 56,184,120,248,
			4,132, 68,196, 36,164,100,228, 20,148, 84,212, 52,180,116,244,
		 12,140, 76,204, 44,172,108,236, 28,156, 92,220, 60,188,124,252,
			2,130, 66,194, 34,162, 98,226, 18,146, 82,210, 50,178,114,242,
		 10,138, 74,202, 42,170,106,234, 26,154, 90,218, 58,186,122,250,
			6,134, 70,198, 38,166,102,230, 22,150, 86,214, 54,182,118,246,
		 14,142, 78,206, 46,174,110,238, 30,158, 94,222, 62,190,126,254,
			1,129, 65,193, 33,161, 97,225, 17,145, 81,209, 49,177,113,241,
			9,137, 73,201, 41,169,105,233, 25,153, 89,217, 57,185,121,249,
			5,133, 69,197, 37,165,101,229, 21,149, 85,213, 53,181,117,245,
		 13,141, 77,205, 45,173,109,237, 29,157, 93,221, 61,189,125,253,
			3,131, 67,195, 35,163, 99,227, 19,147, 83,211, 51,179,115,243,
		 11,139, 75,203, 43,171,107,235, 27,155, 91,219, 59,187,123,251,
			7,135, 71,199, 39,167,103,231, 23,151, 87,215, 55,183,119,247,
		 15,143, 79,207, 47,175,111,239, 31,159, 95,223, 63,191,127,255 );
	PelPanMask : array[0..3] of byte =
		( 0, 2, 4, 6 );
	LeftClipPlaneMask  : array[0..3] of byte =
		( $0F, $0E, $0C, $08 );
	RightClipPlaneMask : array[0..3] of byte =
		( $0F, $01, $03, $07 );
	LeftMaskTable : array[0..8] of byte =
		( 0, $ff, $ee, 0, $cc, 0, 0, 0, $88 );
	RightMaskTable: array[0..8] of byte =
		( 0, $11, $33, 0, $77, 0, 0, 0, $ff );
	LeftDelay : array[0..3] of byte =
		( 0, 1, 2, 4 );
	RightDelay : array[0..3] of byte =
		( 0, 4, 2, 1 );
	PS2Cards : array[0..12] of byte = ( 0,1,2,2,4,3,2,5,6,2,8,7,8 );

	WhenToDraw : array[0..31] of byte = ( 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3,
			2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5 );

var
	FontPtr,
	UserFontPtr,
	F8x8Ptr,
	F8x14Ptr, 
	OldTimerIntVar : pointer;
	MouseMask : array[0..167] of byte;
	VSyncPaletteBuffer : array[0..767] of byte;
	WaitingStartLow,
	WaitingStartHigh,
	WaitingPelPan,
	VsyncPaletteStart,
	VsyncPaletteCount,
	MirrorTableOffs,
	BGSaveOffs,
	TopBound,
	BottomBound,
	LeftBound,
	RightBound,
	MouseVersion,
	Seg0000,
	SelectorInc : word;
	MouseType,
	MouseIRQ,
	inhandler : byte;


{$IFDEF DPMI}
{$L XLIB2.OBP}
procedure __a000h; far; external 'KERNEL' index $00AE;
procedure __c000h; far; external 'KERNEL' index $00C3;
procedure __AHIncr; far;        external 'KERNEL' index $0072;
procedure __0000h; far; external 'KERNEL' index $00B7;
{$ELSE}
{$L XLIB2.OBJ}
{$ENDIF}

Function  XSetMode( Mode, WidthInPixels : Word ) : Word; external;
Procedure XSelectDefaultPlane( Plane : Byte ); external;
Procedure XSetSplitscreen( Line : Word ); external;
Procedure XSetStartAddr( X, Y : Word ); external;
Procedure XHideSplitscreen; external;
Procedure XShowSplitscreen; external;
Procedure XAdjustSplitscreen( Line : Word ); external;
Procedure XSetDoubleBuffer( PageHeight : Word ); external;
Procedure XSetTripleBuffer( PageHeight : word ); external;
Procedure XPageFlip( X, Y : Word ); external;
Procedure XSetClipRect( Left, Top, Right, Bottom : Word ); external;
Procedure XTextMode; external;
Procedure XWaitVsync; external;
Procedure XLine( x1, y1, x2, y2, Color, PgOffs : word ); external;
Procedure XPutPix( X,Y,PgOfs,Color:word ); external;
Function  XGetPix( x,y,PageBase:word ) : word; external;
Procedure XRectFill( StartX,StartY,EndX,EndY,PageBase,Color:word ); external;
Procedure XRectPattern( StartX,StartY,EndX,EndY,PageBase:word; var Pattern); external;
Procedure XCpVidPage( SourceOffs, DestOffs : word ); external;
Procedure XCpVidRect( SrcStartX,SrcStartY,SrcEndX,SrcEndY,DestStartX,
											DestStartY,SrcPageBase,DestPageBase,SrcBitmapW,
											DestBitmapW:word ); external;
Procedure XShiftRect( SrcLeft,SrcTop,SrcRight,SrcBottom,DestLeft,DestTop,
											ScreenOffs:word ); external;
Procedure XCircle( Left, Top, Diameter, Color, ScreenOffs:word ); external;
Procedure XFilledCircle( Left, Top, Diameter, Color, ScreenOffs:word ); external;
Procedure XGetPalStruc( var PalBuff; NumColors,StartColor:word ); external;
Procedure XGetPalRaw( Var PalBuff; NumColors,StartColor:word ); external;
Procedure XPutPalStruc( Var CompPalBuff ); external;
Procedure XTransposePalStruc( Var CompPalBuff; StartColor:word ); external;
Procedure XPutPalRaw( Var PalBuff; NumColors,StartColor:word ); external;
Procedure XSetRGB( ColorIndex,R,G,B:byte ); external;
Procedure XRotPalStruc( Var PalBuff; Direction:word ); external;
Procedure XRotPalRaw( Var PalBuff; Direction, NumColors:word ); external;
Function  XCpContrastPalStruc( Var PalSrcBuff,PalDestBuff; Intensity:byte ) : word; external;
Procedure XPutContrastPalStruc( Var CompPalBuff; Intensity:byte ); external;
Function  XCharPut( Chr:char; X, Y, ScrnOffs, Color:word ) : byte; external;
Procedure XSetFont( FontID : word ); external;
Procedure XTextInit; external;
Procedure XRegisterUserFont( var FontToRegister ); external;
Function  XGetCharWidth( ch : char ) : byte; external;
Procedure XTriangle( X0, Y0, X1, Y1, X2, Y2, Color, PageOffset:word ); external;
Procedure XPolygon( var vertices; numvertices, Color, PageOffset:word ); external;
Procedure XPutCursor( X, Y, TopClip, BottomClip, ScrnOffs : word ); external;
Procedure XDefineMouseCursor( var MouseDef; MouseColor:byte ); external;
function XMouseInit:integer; external;
Procedure XMouseWindow( x0, y0, x1, y1:word ); external;
procedure XShowMouse; external;
Procedure XHideMouse; external;
Procedure XMouseRemove; external;
Procedure XPositionMouse( X, Y : word ); external;
Procedure XUpdateMouse; external;
Function  XFloodFill( X, Y, PgOfs, Color:word ) : word; external;
Function  XBoundaryFill( X, Y, PgOfs, BoundaryColor, Color : word ) : word; external;
Procedure XInstallVSyncHandler( VrtsToSkip:word ); external;
Procedure XRemoveVSyncHandler; external;
Procedure XSetUserVSyncHandler; external;

function XPrintf( x, y, ScrnOffs, Color : word; s : string ) : integer;
var
	w, i : integer;
begin
	w := x;
	for i := 1 to length(s) do
		x:=x+XCharPut( s[i], x, y, ScrnOffs, color );
	XPrintf := x-w+1;
end;

function XStrWidth( s : string ) : integer;
var
	w, i : integer;
begin
	w := 0;
	for i := 1 to length(s) do
		w:=w+XGetCharWidth( s[i] );
	XStrWidth := w;
end;

function XBgPrintf( x, y, ScrnOffs, fgcolor, bgcolor : word; s : string ) : integer;
var
	i : integer;
begin
	for i := 1 to length(s) do
	begin
		XRectFill( x, y, x+XGetCharWidth(s[i]),y+CharHeight,ScrnOffs,bgcolor);
		x := x + XCharPut( s[i], x, y, ScrnOffs, fgcolor);
	end;
	XBgPrintf := x;
end;

Function XCentre( x, y, ScrnOffs, color : word; s : string ) : integer;
var
	w, i : integer;
begin
	w := 0;
	for i := 1 to length(s) do
		w:=w+XGetCharWidth( s[i] );
	x := x-w div 2;
	xprintf( x, y, ScrnOffs, color, s );
	xcentre := x;
end;

Function XBgCentre( x, y, ScrnOffs, fgcolor, bgcolor : word; s : string ) : integer;
var
	w, i : integer;
begin
	w := 0;
	for i := 1 to length(s) do
		w:=w+XGetCharWidth( s[i] );
	x := x-w div 2;
	xbgprintf( x, y, ScrnOffs, fgcolor, bgcolor, s );
	xbgcentre := x;
end;

End.

