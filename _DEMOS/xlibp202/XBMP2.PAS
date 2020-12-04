unit XBmp2;
{ ************************************************
  **    BMP Decoding and Encoding procedures    **
  **        for Borland/Turbo Pascal 7.0        **
  **                                            **
  **     Written by Tristan Tarrant, 1994       **
  **                                            **
	************************************************ }

interface

uses
	Dos, XMisc2;

type
	BMPLineProcType = procedure( Var pixels; line, width : integer );
	BMPPixelProcType = function( x, y : integer) : integer;

Var
	{ Pointers to custom procedures to deal with lines. BMPOutLineProc
		is called with three parameters : an untyped var, containing
		the uncompressed data, and two integer values, containing the
		line number and the width of the line.
		BMPInPixelProc should instead return a pixels value, -1 if at the
		end of the data. }

	BMPOutLineProc : BMPLineProcType;
{ BMPOutLineProc is called with an untyped variable containing a row's
	worth of pixels. The current line is given in line and the number of
	pixels in a line is given in width}
	BMPInPixelProc : BMPPixelProcType;
{ BMPInPixelProc should return a pixel value, -1 if at the end of the data.
	Data should be returned width first (i.e. all pixels in row 0, then all
	pixels in row 1, etc.}
	BMPPalette : array[0..767] of byte;
{ BMPPalette is an array which contains the palette of the last loaded
	BMP file}


function SaveBMP( f : string; width, depth : integer; var palette ) : boolean;
{ This function saves a BMP file f with using screen size width*depth
	and with a color resolution of 8 bits which translates to a 256 colour
	image.
	Palette contains the palette of the picture that is being saved.
	SaveBMP uses #BMPInPixelProc# to get the picture data from the application.
	It returns TRUE if successful, FALSE otherwise}
function LoadBMP( f : string ) : boolean;
{ This function loads a BMP file f and returns TRUE if successful, FALSE
	otherwise.
	It uses the #BMPLineProc# procedure to send the decoded picture
	to the application. The palette of the picture is stored in the
	global variable #BMPPalette#}

implementation

type
	BMPHeader = record
		id : array[1..2] of char;
		filesize,
		reserved,
		headersize,
		infoSize,
		wid,
		hgt : longint;
		biPlanes, bits : integer;
		biCompression,
		biSizeImage,
		biXPelsPerMeter,
		biYPelsPerMeter,
		biClrUsed,
		biClrImportant : longint;
	end;

	BMPRGB = record
		b, g, r, f : byte;
	end;

function DecodeBMP( var f : file ) : boolean;
var
	BMPHead : BMPHeader;
	hgt, wid, index : integer;
	r, g, b : byte;
	ScreenLine : pointer;
	col : BMPRGB;

begin
	blockread( f, BMPHead, SizeOf( BMPHead ) );
	for index:=0 to 255 do
	begin
		blockread( f, col, SizeOf( BMPRGB ) );
		BMPPalette[index*3] := col.r shr 2;
		BMPPalette[index*3+1] := col.g shr 2;
		BMPPalette[index*3+2] := col.b shr 2;
	end;
	wid := BMPHead.wid;
	if wid mod 4<>0 then wid := wid + 4 - wid mod 4;
	GetMem( ScreenLine, wid );
	hgt := BMPHead.hgt-1;
	for index:=hgt downto 0 do
	begin
		blockread( f, ScreenLine^, wid );
		BMPOutLineProc( ScreenLine^, index, wid );
	end;
	DecodeBMP := true;
end;

function LoadBMP( F : string ) : boolean;
var
	D: DirStr;
	N: NameStr;
	E: ExtStr;
	FileHandle : File;
begin
	FSplit( F, D, N, E );
	if E='' then E:='.BMP';
	F := D+N+E;
	{$I-}
		assign( FileHandle, F );
		reset( FileHandle, 1 );
	{$I+}
	if ioresult = 0 then
		LoadBMP := DecodeBMP( FileHandle )
	else
		LoadBMP := false;
	{$I-}
		close( FileHandle );
	{$I+}
end; { LoadBMP }

function EncodeBMP( var f : file; width, depth : integer; var palette ) : boolean;
var
	BMPHead : BMPHeader;
	hgt, wid, index, index2 : integer;
	r, g, b : byte;
	ScreenLine : pointer;
	col : BMPRGB;
	ThePalette : TByteArray absolute palette;

begin
	fillchar( BMPHead, sizeof(BMPHeader),0 );
	with BMPHead do
	begin
		id := 'BP';
		headersize := 1078;
		filesize := headersize + width*depth;
		wid := width;
		hgt := depth;
		infosize := $28;
		bits := 8;
		biplanes := 1;
		biCompression := 0;
	end;

	blockwrite( f, BMPHead, SizeOf( BMPHead ) );
	for index:=0 to 255 do
	begin
		col.r := ThePalette[index*3] shl 2;
		col.g := ThePalette[index*3+1] shl 2;
		col.b := ThePalette[index*3+2] shl 2;
		blockwrite( f, col, SizeOf( BMPRGB ) );
	end;
	wid := width;
	if wid mod 4<>0 then wid := wid + 4 - wid mod 4;
	GetMem( ScreenLine, wid );
	hgt := BMPHead.hgt-1;
	for index:=hgt downto 0 do
	begin
		fillchar( ScreenLine^,wid,0);
		for index2 := 0 to width-1 do
			TByteArray(ScreenLine^)[index2] := BMPInPixelProc(index2,index);
		blockwrite( f, ScreenLine^, wid );
	end;
	EncodeBMP := true;
end;

function SaveBMP( f : string; width, depth : integer; var palette ) : boolean;
var
	D: DirStr;
	N: NameStr;
	E: ExtStr;
	FileHandle : File;
begin
	FSplit( F, D, N, E );
	if E='' then E:='.BMP';
	F := D+N+E;
	{$I-}
		assign( FileHandle, F );
		rewrite( FileHandle, 1 );
	{$I+}
	if ioresult = 0 then
		SaveBMP := EncodeBMP( FileHandle, width, depth, palette )
	else
		SaveBMP := false;
	{$I-}
		close( FileHandle );
	{$I+}
end;

end.
