Unit Xbm2;
{#F}
{ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
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

ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ XBM2 : EXPORTED PROCEDURES AND FUNCTIONS                                  บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

	This unit implements a set of functions to operate on bitmaps. XLIB2 uses
	three different kinds of bitmaps :
		Planar Bitmaps (PBMs),
		Video Bitmaps   (VBMs),
		Compiled Bitmaps (CBMs).

ษออออออป
บ PBMs บ
ศออออออผ

	PBMs as used by these functions have the following structure:

		byte 0                 The bitmap width in bytes (4 pixel groups) range 1..255
		byte 1                 The bitmap height in rows range 1..255
		byte 2..n1             The plane 0 pixels width*height bytes
		byte n1..n2            The plane 1 pixels width*height bytes
		byte n2..n3            The plane 2 pixels width*height bytes
		byte n3..n4            The plane 3 pixels width*height bytes

	These functions provide the fastest possible bitmap blts from system ram
	to video and further, the single bitmap is applicable to all pixel
	alignments. The masked functions do not need separate masks since all non
	zero pixels are considered to be masking pixels, hence if a pixel is 0 the
	corresponding screen destination pixel is left unchanged.

ษออออออป
บ VBMs บ
ศออออออผ

Yet another type of bitmap to complement planar and compiled bitmaps are
Video Bitmaps, VRAM based bitmaps. If a 4 cylinder car is analagous to planar
bitmaps, that is thrifty on memory consumption but low performance and and a
V8 is analagous to Compiled bitmaps, memory guzzlers that really fly, then
VRAM based bitmaps are the 6 cylinder modest performers with acceptable memory
consumption. They are faster, though, only on VLB/PCI video boards.

To summarise their selling points, VBM's are moderately fast with fair memory
consumption, and unlike compiled bitmaps, can be clipped. The disadvantages
are that they are limited by the amount of free video ram and have a complex
structure.

The VRAM bitmap format is rather complex consisting of components stored in
video ram and components in system ram working together. This complexity
necessitates the existence of a creation function xmakevbm which takes
an input linear bitmap and generates the equivalent VBM (VRAM Bit Map).

VBM structure:

	word  0   Size          Total size of this VBM structure in bytes
	word  1   ImageWidth    Width in bytes of the image (for all alignments)
	word  2   ImageHeight   Height in scan lines of the image

	word  3 Alignment 0  ImagePtr   Offset in VidRAM of this aligned image
	+--word  4              MaskPtr    Offset (within this structure's DS) of
	|   .                               alignment masks
	|   .
	|   .
	|  word  9 Alignment 3  ImagePtr   Offset in VidRAM of this aligned image
	+|--word 10              MaskPtr    Offset (within this structure's DS) of
	||                                   alignment masks
	||
	|+->byte 21 (word 11)                -------+-- Image masks for alignment 0
	|   .                                       |
	|   .                                       |
	|   byte  21 + ImageWidth*ImageHeight  -----+
	|
	|   .
	|   . (similaly for alignments 1 - 2 )
	|   .
	|
	+-->byte  21 + 3*ImageWidth*ImageHeight + 1-+-- Image masks for alignment 3
	.                                       |
	.                                       |
	byte  21 + 4*(ImageWidth*ImageHeight) --+
	.
	.
	<< Similarly for alignments 2 and 3 >>
	.
	.
	byte 21 + 4*(ImageWidth*ImageHeight)
	-------------
	(And dont forget the corresponding data in video ram)

You can see for yourself the complexity of this bitmap format. The image
is stored in video ram in its 4 different alignments with pointers to these
alignments in the VBM. Similarly there are 4 alignments of the corresponding
masks within the VBM itself (towards the end). The mask bytes contain the
plane settings for the corresponding video bytes so that one memory move can
move up to 4 pixels at a time (depending on the mask settings) using the
VGA's latches, theoretically giving you a 4x speed improvement over
conventional blits like the ones implemented in XPBITMAP. In actual fact
its anywhere between 2 and 3 due to incurred overheads.

These bitmaps are more difficult to store in files than PBM'S and CBM's but
still posible with a bit of work, so do not dismiss these as too difficult
to use. Consider all the bitmap formats carefully before deciding on which
to use. There may even be situations that a careful application of all three
types would be most effective ie. compiled bitmaps for Background tiles and
the main game character (which never need clipping), VRAM based bitmaps for
the most frequently occuring (oponent, alien etc) characters which get
clipped as they come into and leave your current location and planar bitmaps
for smaller or less frequently encountered characters.}
{$A+,B-,E-,G+,I+,N-,O-,P-,Q-,S-,T-,X+}

{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}

Interface

Uses Xlib2;

Procedure XPbmToBm( var source, dest );
{ This function converts a bitmap in the planar format to the linear format
	as used by xcompilebitmap.

	WARNING: the source and destination bitmaps must be pre - allocated

	NOTE: This function can only convert planar bitmaps that are suitable.
	If the source planar bitmap's width (per plane) is >= 256/4
	it cannot be converted. In this situation an error code
	BMWIDTHERROR. On successful conversion 0 is returned.}
Procedure XBmToPbm( var source, dest );
{ This function converts a bitmap in the linear format as used by
	xcompilebitmap to the planar formap.

	WARNING: the source and destination bitmaps must be pre - allocated

	NOTE: This function can only convert linear bitmaps that are suitable.
	If the source linear bitmap's width is not a multiple of 4
	it cannot be converted. In this situation an error code
	BMWIDTHERROR. On successful conversion 0 is returned.}
Procedure XPutMaskedPbm( X, Y,ScrnOffs : word; var Bitmap );
{	Mask write a planar bitmap from system ram to video ram. All zero source
	bitmap bytes indicate destination byte to be left unchanged.

	Source Bitmap structure:

	Width:byte, Height:byte, Bitmap data (plane 0)...Bitmap data (plane 1)..,
	Bitmap data (plane 2)..,Bitmap data (plane 3)..

	NOTE: width is in bytes ie lots of 4 pixels

	LIMITATIONS: No clipping is supported
				 Only supports bitmaps with widths which are a multiple of
				 4 pixels}
Procedure XPutPbm( X,Y,ScrnOffs:word; var Bitmap );
{  Write a planar bitmap from system ram to video ram.

	Source Bitmap structure:

	Width:byte, Height:byte, Bitmap data (plane 0)...Bitmap data (plane 1)..,
	Bitmap data (plane 2)..,Bitmap data (plane 3)..

	NOTE: width is in bytes ie lots of 4 pixels

	LIMITATIONS: No clipping is supported
				 Only supports bitmaps with widths which are a multiple of
				 4 pixels}
Procedure XGetPbm( X,Y: word;SrcWidth,SrcHeight:byte;
									 ScrnOffs:word; var Bitmap );
{ Read a planar bitmap to system ram from video ram.

	Source Bitmap structure:

	Width:byte, Height:byte, Bitmap data (plane 0)...Bitmap data (plane 1)..,
	Bitmap data (plane 2)..,Bitmap data (plane 3)..

	NOTE: width is in bytes ie lots of 4 pixels

	LIMITATIONS: No clipping is supported
				 Only supports bitmaps with widths which are a multiple of
				 4 pixels}
Procedure XFlipMaskedPbm( X,Y,ScrnOffs:word; var Bitmap; Orientation:word );
Procedure XFlipPbm( X,Y,ScrnOffs:word; var Bitmap; Orientation:word );
Procedure XCompilePbm( LogicalWidth : word; var bitmap, output );
Function  XSizeOfCPbm( logicalwidth : word; var bitmap ) : word;
Procedure XCompileBitmap( logicalwidth:word; var bitmap, output );
Function  XSizeOfCBitmap( logicalwidth:word; var bitmap ):word;
Procedure XPutCBitmap( XPos,YPos,PageOffset:word; var Sprite );
Procedure XPutMaskedPBMClipX( X, Y, ScrnOffs:word; var Bitmap );
procedure XPutMaskedPBMClipY( X, Y, ScrnOffs:word; var Bitmap );
Procedure XPutMaskedPBMClipXY( X, Y, ScrnOffs:word; var Bitmap );
Procedure XPutPBMClipX( X, Y, ScrnOffs:word; var Bitmap );
Procedure XPutPBMClipY( X, Y, ScrnOffs : word; var Bitmap );
Procedure XPutPBMClipXY( X, Y, ScrnOffs:word; var Bitmap );
Procedure XStoreVBMImage( VramOffs,Align:word; var LBitmap );
Procedure XPutMaskedVBM( X, Y, ScrnOffs:word; var SrcVBM );
Procedure XPutMaskedVBMClipX( X, Y, ScrnOffs:word; var SrcVBM );
Procedure XPutMaskedVBMClipY( X, Y, ScrnOffs : word; var SrcVBM );
Procedure XPutMaskedVBMClipXY( X, Y, ScrnOffs:word; var SrcVBM );
Function  XMakeVBM( var lbm; var VramStart : word ) : PAlignmentHeader;
Function  Xsizeofcbitmap32(logicalscreenwidth : word; var bitmapin ) : word;
Function  Xcompilebitmap32(logicalscreenwidth : word; var bitmapin, bitmapout ) : word;
Procedure XScale( DestX, DestY, DestWidth, DestHeight, ScrnOffs : word; var Bitmap );
Procedure XMaskedScale( DestX, DestY, DestWidth, DestHeight, ScrnOffs : word; var Bitmap );

Implementation
{$IFDEF DPMI}
{$L XBM2.OBP}
{$ELSE}
{$L XBM2.OBJ}
{$ENDIF}
Procedure XPbmToBm( var source, dest ); external;
Procedure XBmToPbm( var source, dest ); external;
Procedure XPutMaskedPbm( X, Y,ScrnOffs : word; var Bitmap ); external;
Procedure XPutPbm( X,Y,ScrnOffs:word; var Bitmap ); external;
Procedure XGetPbm( X,Y: word;SrcWidth,SrcHeight:byte;
									 ScrnOffs:word; var Bitmap ); external;
Procedure XFlipMaskedPbm( X,Y,ScrnOffs:word; var Bitmap; Orientation:word ); external;
Procedure XFlipPbm( X,Y,ScrnOffs:word; var Bitmap; Orientation:word ); external;
Procedure XCompilePbm( LogicalWidth : word; var bitmap, output ); external;
Function  XSizeOfCPbm( logicalwidth : word; var bitmap ) : word; external;
Procedure XCompileBitmap( logicalwidth:word; var bitmap, output ); external;
Function  XSizeOfCBitmap( logicalwidth:word; var bitmap ):word; external;
Procedure XPutCBitmap( XPos,YPos,PageOffset:word; var Sprite ); external;
Procedure XPutMaskedPBMClipX( X, Y, ScrnOffs:word; var Bitmap ); external;
procedure XPutMaskedPBMClipY( X, Y, ScrnOffs:word; var Bitmap ); external;
Procedure XPutMaskedPBMClipXY( X, Y, ScrnOffs:word; var Bitmap ); external;
Procedure XPutPBMClipX( X, Y, ScrnOffs:word; var Bitmap ); external;
Procedure XPutPBMClipY( X, Y, ScrnOffs : word; var Bitmap ); external;
Procedure XPutPBMClipXY( X, Y, ScrnOffs:word; var Bitmap ); external;
Procedure XStoreVBMImage( VramOffs,Align:word; var LBitmap ); external;
Procedure XPutMaskedVBM( X, Y, ScrnOffs:word; var SrcVBM ); external;
Procedure XPutMaskedVBMClipX( X, Y, ScrnOffs:word; var SrcVBM ); external;
Procedure XPutMaskedVBMClipY( X, Y, ScrnOffs : word; var SrcVBM ); external;
Procedure XPutMaskedVBMClipXY( X, Y, ScrnOffs:word; var SrcVBM ); external;
Procedure XScale( DestX, DestY, DestWidth, DestHeight, ScrnOffs : word; var Bitmap ); external;
Procedure XMaskedScale( DestX, DestY, DestWidth, DestHeight, ScrnOffs : word; var Bitmap ); external;

function XMakeVBM( var lbm; var VramStart : word ) : PAlignmentHeader;
var
	LBMHeadr : ^LBMheader;
	VBMHeadr : PAlignmentHeader;
	VBMMaskPtr, p, LBMPixelPtr : ^byte;
	align,BitNum,TempImageWidth, scanline : integer;
	TempWidth,TempHeight,TempSize,MaskSize,VramOffs,MaskSpace : word;
	MaskTemp : byte;
begin
	VramOffs := VramStart;
	LBMHeadr := @lbm;
	TempWidth  := (LBMHeadr^.width+3) div 4+1;
	TempHeight := LBMHeadr^.height;
	TempSize   := TempWidth*TempHeight;
	getmem( VBMHeadr,22+TempSize*4);
	MaskSpace:=22;
	VBMHeadr^.ImageWidth  := TempWidth;
	VBMHeadr^.ImageHeight := TempHeight;
	VBMHeadr^.size := 22+TempSize*4;
	for align := 0 to 3 do
	begin
		VBMHeadr^.alignments[align].ImagePtr := VramOffs;
		XStoreVBMImage(VramOffs,align,lbm);
		MaskSpace := MaskSpace+TempSize;
		VramOffs := VramOffs+TempSize;
	end;
	VBMMaskPtr := ptr(Seg(VBMHeadr^),Ofs(VBMHeadr^)+22);
	for align:=0 to 3 do
	begin
		LBMPixelPtr := ptr(Seg(lbm),Ofs(lbm)+ 2);
		VBMHeadr^.alignments[align].MaskPtr := Ofs(VBMMaskPtr^);
		for scanline := 0 to TempHeight-1 do
		begin
			BitNum := align;
			MaskTemp := 0;
			TempImageWidth := LBMHeadr^.width;
			repeat
				MaskTemp := MaskTemp or (Ord(LBMPixelPtr^<>0) shl BitNum);
				LBMPixelPtr := Ptr(Seg(LBMPixelPtr^),Ofs(LBMPixelPtr^)+1);
				inc(BitNum);
				if BitNum > 3 then
				begin
					VBMMaskPtr^ := MaskTemp;
					VBMMaskPtr := Ptr(Seg(VBMMaskPtr^),Ofs(VBMMaskPtr^)+1);
					MaskTemp := 0;
					BitNum := 0;
				end;
				dec(TempImageWidth);
			until TempImageWidth=0;
			if BitNum<>0 then VBMMaskPtr^ := MaskTemp else VBMMaskPtr^ := 0;
			VBMMaskPtr := Ptr(Seg(VBMMaskPtr^),Ofs(VBMMaskPtr^)+1);
		end;
	end;
	VramStart :=VramOffs;
	XMakeVBM := VBMHeadr;
end;

Const
	ROLAL = $c0d0;
	SHORTSTORE8  = $44c6;
	STORE8       = $84c6;
	SHORTSTORE16 = $44c7;
	STORE16      = $84c7;
	ADCSIIMMED   = $d683;
	OUTAL        = $ee;
	RETURN       = $cb;
	DWORDPREFIX  = $66;

Function xcompilebitmap32(logicalscreenwidth : word; var bitmapin, bitmapout ) : word;
type
	ByteArray = array[0..1] of byte;
var
	height, column, setcolumn, scanx, scany, outputused, width, margin,
	margin2, margin4, pix0, pix1, pix2, pix3, numpix : integer;
	pos : integer;
	bitmap : ByteArray absolute bitmapin;
	output : ByteArray absolute bitmapout;

begin
	column := 0;
	setcolumn := 0;
	scanx := 0;
	scany := 0;
	outputused := 0;
	width := bitmap[0];
	height := bitmap[1];

	margin := width - 1;
	margin2 := margin - 4;
	margin4 := margin - 12;

	while (column < 4) do
	begin
		numpix := 1;
		pix0 := bitmap[scany*width+scanx+2];
		if pix0 <> 0 then
		begin
			if setcolumn <> column then
			begin
				repeat
					output[outputused]:=ROLAL and 255;
					output[outputused+1]:=ROLAL shr 8;
					inc(outputused,2);
					output[outputused]:=ADCSIIMMED and 255;
					output[outputused+1]:=ADCSIIMMED shr 8;
					inc(outputused,2);
					output[outputused] := 0;
					inc(outputused);
					inc(setcolumn);
				until setcolumn = column;
				output[outputused] := OUTAL;
				inc(outputused);
			end;
			if scanx <= margin2 then
			begin
				pix1 := bitmap[scany*width+scanx+2 +4];
				if (pix1 <> 0) and (scanx <= margin4) then
				begin
					numpix := 2;
					pix2 := bitmap[scany*width+scanx+2 +8];
					pix3 := bitmap[scany*width+scanx+2 +12];
					if (pix2 <> 0) and (pix3 <> 0) then
					begin
						numpix := 4;
						output[outputused] := DWORDPREFIX;
						inc(outputused);
					end;
				end;
			end;
			pos := (scany * logicalscreenwidth) + (scanx shr 2) - 128;
			if (pos >= -128) and (pos <= 127) then
			begin
				if numpix = 1 then
				begin
					output[outputused]:=SHORTSTORE8 and 255;
					output[outputused+1]:=SHORTSTORE8 shr 8;
					inc(outputused,2);
					output[outputused] := pos;
					inc(outputused);
					output[outputused] := pix0;
					inc(outputused);
				end else
				begin
					output[outputused]:=SHORTSTORE16 and 255;
					output[outputused+1]:=SHORTSTORE16 shr 8;
					inc(outputused,2);
					output[outputused] := pos;
					inc(outputused);
					output[outputused] := pix0;
					inc(outputused);
					output[outputused] := pix1;
					inc(outputused);
					if numpix = 4 then
					begin
						output[outputused] := pix2;
						inc(outputused);
						output[outputused] := pix3;
						inc(outputused);
					end;
				end;
			end else
			begin
				if numpix = 1 then
				begin
					output[outputused]:=STORE8 and 255;
					output[outputused+1]:=STORE8 shr 8;
					inc(outputused,2);
					output[outputused]:=pos and 255;
					output[outputused+1]:=pos shr 8;
					inc(outputused,2);
					output[outputused] := pix0;
					inc(outputused);
				end else
				begin
					output[outputused]:=STORE16 and 255;
					output[outputused+1]:=STORE16 shr 8;
					inc(outputused,2);
					output[outputused]:=pos and 255;
					output[outputused+1]:=pos shr 8;
					inc(outputused,2);
					output[outputused] := pix0;
					inc(outputused);
					output[outputused] := pix1;
					inc(outputused);
					if numpix = 4 then
					begin
						output[outputused] := pix2;
						inc(outputused);
						output[outputused] := pix3;
						inc(outputused);
					end;
				end;
			end;
		end;
		scanx := scanx + (numpix shl 2);
		if scanx > margin then
		begin
			scanx := column;
			inc(scany);
			if scany = height then
			begin
				scany := 0;
				inc(column);
			end;
		end;
	end;
	output[outputused] := return;
	inc(outputused);
	xcompilebitmap32 := outputused;
end;

Function xsizeofcbitmap32(logicalscreenwidth : word; var bitmapin ) : word;
type
	ByteArray = array[0..1] of byte;
var
	height, column, setcolumn, scanx, scany, outputused, width, margin,
	margin2, margin4, pix0, pix1, pix2, pix3, numpix : integer;
	pos : integer;
	bitmap : ByteArray absolute bitmapin;

begin
	column := 0;
	setcolumn := 0;
	scanx := 0;
	scany := 0;
	outputused := 0;
	width := bitmap[0];
	height := bitmap[1];

	margin := width - 1;
	margin2 := margin - 4;
	margin4 := margin - 12;

	while (column < 4) do
	begin
		numpix := 1;
		pix0 := bitmap[scany*width+scanx+2];
		if pix0 <> 0 then
		begin
			if setcolumn <> column then
			begin
				repeat
					outputused := outputused + 5;
					inc(setcolumn);
				until setcolumn = column;
				inc(outputused);
			end;
			if scanx <= margin2 then
			begin
				pix1 := bitmap[scany*width+scanx+2 +4];
				if (pix1 <> 0) and (scanx <= margin4) then
				begin
					numpix := 2;
					pix2 := bitmap[scany*width+scanx+2 +8];
					pix3 := bitmap[scany*width+scanx+2 +12];
					if (pix2 <> 0) and (pix3 <> 0) then
					begin
						numpix := 4;
						inc(outputused);
					end;
				end;
			end;
			pos := (scany * logicalscreenwidth) + (scanx shr 2) - 128;
			if (pos >= -128) and (pos <= 127) then
			begin
				if numpix = 1 then
					outputused := outputused + 4
				else
				begin
					outputused := outputused + 5;
					if numpix = 4 then
						outputused := outputused + 2;
				end;
			end else
			begin
				if numpix = 1 then
					outputused := outputused + 5
				else
				begin
					outputused := outputused + 6;
					if numpix = 4 then
						outputused := outputused + 2;
				end;
			end;
		end;
		scanx := scanx + (numpix shl 2);
		if scanx > margin then
		begin
			scanx := column;
			inc(scany);
			if scany = height then
			begin
				scany := 0;
				inc(column);
			end;
		end;
	end;
	inc(outputused);
	xsizeofcbitmap32 := outputused;
end;

end.
