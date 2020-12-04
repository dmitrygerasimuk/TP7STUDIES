Unit XLA2;
{#F}
{ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ        XLIB v2.0 - Graphics Library for Borland/Turbo Pascal 7.0          บ
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
บ XLA2 UNIT - Compression and archiving                                     บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

The XLA2 unit implements a set of procedures and functions to handle XLA files.
XLA stands for XLib Archive and is a very useful and powerful tool.
Suppose you just have written a game with XLib that uses many sprites, fonts
and bitmaps and you are loading all these resources from disk. This means the
program's directory is cluttered with lots of files which may take up a lot
of space. With XLA you can pack all of these files into one and extract them
from within your program at runtime. XLA files are created with the XLARC
program distributed with XLibPas2. Files inside an XLA file can be stored in
two ways (for now) : uncompressed and compressed using a variation of the LZS
algorithm. When extracting them, though, you don't have to worry about their
format : the XLA2 routines will handle all the uncompression/unpacking for you.

The structure of an XLA file is as follows :

	Header
		signature: array[0..3] of char= 'XLAS'
		posdir   : longint            = The position of the archive's directory
						which is at the end of the file.
		sizedir  : longint            = The number of files stored in the archive

		Files      : lots of bytes      = The files, stored sequentially
				 :
				 :
				 :

		Directory : array[1..sizedir] of name : array[0..11] of char= The name
			of the file
		posfile  : position of the file in the archive
		sizefile : the original size of the file
		sizecomp : the compressed size of the file
		algorithm: 0 ( No compression ) 1 ( LZS compression )}
{$G+,N-,E-}



Interface

Uses
	XMisc2, Dos;

Const
	None = 0; {No compression : store only}
	LZS  = 1; {LZS77 compression algorithm}
	Best = 8; {Not Used}
Type
	XLAOutProcType = procedure( var Data; size : word );
	XLAInProcType  = procedure( var Data; size : word; var actual : longint );
Var
	ModeUsed : word;
	XLAOutProc : XLAOutProcType;
{ This procedure is called by the XLA decoding routines everytime a new
	packet of data has been uncompressed. The data is stored in data and the
	amount of data is stored in size. The procedure that is pointed at by
	this variable must be declared far.}
	XLAInProc  : XLAInProcType;
{ This procedure is called by the XLA encoding routines everytime a new
	packet of data is requested. The data has to be stored in data and the
	amount of data that has to be passed back is stored in size.
	If size bytes can't be provided then the actual amount of data
	transferred is put in actual. If there is no more data, then actual must
	be set to 0. The procedure that is pointed at by this variable must be
	declared far.}
	ratio : integer;
{ This variable contains the compression ratio in % of the last file that
	was added to the archive with XLAPut. The value is invalid if no files
	have been added. }
Function  XLZSSave( FName : string ) : boolean;
{  Creates a standalone file with name FName. Calls XLAInProc. Returns true
	if successful, false otherwise.}
Function  XLZSLoad( FName : string ) : boolean;
{ Loads a standalone file with name FName. Calls XLAOutProc. Returns true if
	successful, false otherwise.}
procedure XPrintDir;
{ Used by XLArc. Displays the directory of the currently open archive}
function  XCloseArchive : boolean;
{ This function has to be called when the program doesn't need to access the
	XLA file any more. If the archive was opened with XCreateArchive or
	XUpdateArchive the the XEndArchive function must be called instead,
	otherwise the XLA file will be corrupt. Frees all the memory allocated to
	the uncompression routines. Returns true if successful.}
function  XUpdateArchive( filename : string ) : boolean;
{ Opens an already existing XLA file for writing/reading. Reads in the archive's
	directory. Returns true if successful.}
function  XOpenArchive( filename : string ) : boolean;
{ Opens an already existing XLA file for reading. Reads in the archive's
	directory. Returns true if successful.}
function  XLAGet( fname : string ) : boolean;
{ Extracts a file from the currently open archive. Calls XLAOutProc.
	Returns true if successful.}
function  XLAPut( fname : string; mode : word ) : boolean;
{ Adds a file to the currently open archive. Calls XLAInProc. Returns true
	if successful. Mode can be either None or LZS.}
function  XEndArchive : boolean;
{ This function has to be called when the program has finished creating or
	updating an archive. It writes the archive's directory at the end of the
	file and updates the header to reflect any changes. Frees all memory
	allocated to the compression routines. Returns true if successful.}
function  XCreateArchive( filename : string ) : boolean;
{ Creates an XLA file for writing. Writes a template header to disk.
	Returns true if successful.}
function  XLAGetFileInfo( fname : string; var origsize, compsize : longint; mode : word ) : boolean;
{ Collects information about a particular file in the archive. Origsize
	contains the length of the uncompressed file. Compsize contains the size of
	the compressed file. Mode contains the algorithm used to store the file.
	Returns true if successful.}
function  XLAFindFirst( pattern : string; var match : string ) : boolean;
{ Searches through the archive's directory for the first file matching pattern.
	and returns it in match. pattern can contain * wildcards in the standard DOS
	notation. It doesn't support ? wildcards. Returns true if successful.}
function  XLAFindNext( var match : string ) : boolean;
{ Finds the next file matching the pattern given in a previous call to
	XLAFindFirst and returns it in match. Returns true if successful.}
Implementation

const
	TableSize = 5003;
	LargestCode = 4095;
	NoCode = -1;
	N           = 4096;
	F           = 18;
	THRESHOLD   = 2;
	NUL         = N * 2;

	BUFSIZE = 1024;
	InBufPtr  : WORD = BUFSIZE;
	InBufSize : WORD = BUFSIZE;
	OutBufPtr : WORD = 0;

Type
	PWorkspace = ^TWorkspace;
	TWorkspace = record
		TextBuf : Array[0.. N + F - 2] OF byte;
		Left,Mom:  Array [0..N] OF word;
		Right: Array [0..N + 256] OF word;
	end;

	THeader = record
		sig : array[0..3] of char;
		posdir, sizedir : longint;
	end;

	TFile = record
		name : array[0..11] of char;
		posfile, sizefile, sizecomp : longint;
		algorithm : word;
	end;

	PXLADir = ^TXLADir;
	TXLADir = record
		item : TFile;
		next : PXLADir;
	end;

Var
	XLAFile : File;
	Header : THeader;
	XLADir, CurrentDir : PXLADir;
	TotalSize, BytesWritten : longint;

	printcount, height,
	matchPos, matchLen,
	lastLen, printPeriod : WORD;
	opt : BYTE;
	SearchPattern : string;

	Workspace : PWorkspace;

	codeBuf: Array [0..16] of BYTE;

	Inbuf,OutBuf : Array[0..PRED(BUFSIZE)] of BYTE;

	ArchiveOpen : boolean;

Procedure InitBuffers;
var
	tmp : ^byte;
begin
	while true do
	begin
		new( Workspace );
		if ofs(Workspace^)<>0 then
		begin
			dispose( Workspace );
			new( tmp );
		end else break;
	end;
end;

Procedure CleanUp;
begin
	Dispose( Workspace );
end;

procedure CleanUpAll;
var
	tmp : PXLADir;
begin
	while XLADir<>nil do
	begin
		tmp := XLADir^.next;
		dispose( XLADir );
		XLADir := tmp;
	end;
	CleanUp;
end;


Function MemoryReadChunk: word;

var
	Actual : longint;

begin
	XLAInProc( InBuf, BufSize, Actual );
	TotalSize := TotalSize + Actual;
	MemoryReadChunk := Actual;
end;

Procedure MemoryGetc; Assembler;
asm
	push    bx
	mov     bx, inBufPtr
	cmp     bx, inBufSize
	jb      @getc1
	push    cx
	push    dx
	push    di
	push    si
	call    MemoryReadChunk
	pop     si
	pop     di
	pop     dx
	pop     cx
	mov     inBufSize, ax
	or      ax, ax
	jz      @getc2
	xor     bx, bx
@getc1:
	mov     al, [Offset InBuf + bx]
	inc     bx
	mov     inBufPtr, bx
	pop     bx
	clc
	jmp     @end
@getc2:
	pop     bx
	stc
@end:
end;

Function DiskReadChunk: word;

var
	Actual : WORD;

begin
	if Bufsize > TotalSize then
		Actual := TotalSize
	else
		Actual := BufSize;
	if Actual > 0 then BlockRead(XLAFile,InBuf,Actual);
	TotalSize := TotalSize - Actual;
	DiskReadChunk := Actual;
end;

Procedure DiskGetc; Assembler;
asm
	push    bx
	mov     bx, inBufPtr
	cmp     bx, inBufSize
	jb      @getc1
	push    cx
	push    dx
	push    di
	push    si
	call    DiskReadChunk
	pop     si
	pop     di
	pop     dx
	pop     cx
	mov     inBufSize, ax
	or      ax, ax
	jz      @getc2
	xor     bx, bx
@getc1:
	mov     al, [Offset InBuf + bx]
	inc     bx
	mov     inBufPtr, bx
	pop     bx
	clc
	jmp     @end
@getc2:
	pop     bx
	stc
@end:
end;

Procedure MemoryWriteout;
begin
	XLAOutProc( OutBuf, OutBufPtr );
	BytesWritten := BytesWritten + OutBufPtr;
end;

Procedure MemoryPutc; Assembler;
asm
	push    bx
	mov     bx, outBufPtr
	mov     [OFFSet OutBuf + bx], al
	inc     bx
	cmp     bx, BUFSIZE
	jb      @putc1
	mov     OutBufPtr,BUFSIZE
	push    cx
	push    dx
	push    di
	push    si
	call    MemoryWriteOut
	pop     si
	pop     di
	pop     dx
	pop     cx
	xor     bx, bx
@putc1:
	mov     outBufPtr, bx
	pop     bx
end;

Procedure DiskWriteout;
var
	Actual : WORD;

begin
	BlockWrite(XLAFile,OutBuf,OutBufPtr,Actual);
	BytesWritten := BytesWritten + OutBufPtr;
end;

Procedure DiskPutc; Assembler;
asm
	push    bx
	mov     bx, outBufPtr
	mov     [OFFSet OutBuf + bx], al
	inc     bx
	cmp     bx, BUFSIZE
	jb      @putc1
	mov     OutBufPtr,BUFSIZE
	push    cx
	push    dx
	push    di
	push    si
	call    DiskWriteOut
	pop     si
	pop     di
	pop     dx
	pop     cx
	xor     bx, bx
@putc1:
	mov     outBufPtr, bx
	pop     bx
end;


PROCEDURE LZSInitTree; Assembler;
ASM
	cld
	les     ax, Workspace
	mov     di, offset TWorkspace.Right
	add     di, (N + 1) * 2
	mov     cx, 256
	mov     ax, NUL
	rep     stosw
	mov     di, offset TWorkspace.mom
	mov     cx, N
	rep     stosw
END;


PROCEDURE LZSSplay; Assembler;
ASM
	les     si, Workspace
@Splay1:
	mov     si, es:[Offset TWorkspace.Mom + di]
	cmp     si, NUL
	ja      @Splay4
	mov     bx, es:[Offset TWorkspace.Mom + si]
	cmp     bx, NUL
	jbe     @Splay5
	cmp     di, es:[Offset TWorkspace.Left + si]
	jne     @Splay2
	mov     dx, es:[Offset TWorkspace.Right + di]
	mov     es:[Offset TWorkspace.Left + si], dx
	mov     es:[Offset TWorkspace.Right + di], si
	jmp     @Splay3
@Splay2:
	mov     dx, es:[Offset TWorkspace.Left + di]
	mov     es:[Offset TWorkspace.Right + si], dx
	mov     es:[Offset TWorkspace.Left + di], si
@Splay3:
	mov     es:[Offset TWorkspace.Right + bx], di
	xchg    bx, dx
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     es:[Offset TWorkspace.Mom + si], di
	mov     es:[Offset TWorkspace.Mom + di], dx
@Splay4:
	jmp     @end
@Splay5:
	mov     cx, es:[Offset TWorkspace.Mom + bx]
	cmp     di, es:[Offset TWorkspace.Left + si]
	jne     @Splay7
	cmp     si, es:[Offset TWorkspace.Left + bx]
	jne     @Splay6
	mov     dx, es:[Offset TWorkspace.Right + si]
	mov     es:[Offset TWorkspace.Left + bx], dx
	xchg    bx, dx
	mov     es:[Offset TWorkspace.Mom + bx], dx
	mov     bx, es:[Offset TWorkspace.Right + di]
	mov     es:[Offset TWorkspace.Left +si], bx
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     bx, dx
	mov     es:[Offset TWorkspace.Right + si], bx
	mov     es:[Offset TWorkspace.Right + di], si
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     es:[Offset TWorkspace.Mom + si], di
	jmp     @Splay9
@Splay6:
	mov     dx, es:[Offset TWorkspace.Left + di]
	mov     es:[Offset TWorkspace.Right + bx], dx
	xchg    bx, dx
	mov     es:[Offset TWorkspace.Mom + bx], dx
	mov     bx, es:[Offset TWorkspace.Right + di]
	mov     es:[Offset TWorkspace.Left + si], bx
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     bx, dx
	mov     es:[Offset TWorkspace.Left + di], bx
	mov     es:[Offset TWorkspace.Right + di], si
	mov     es:[Offset TWorkspace.Mom + si], di
	mov     es:[Offset TWorkspace.Mom + bx], di
	jmp     @Splay9
@Splay7:
	cmp     si, es:[Offset TWorkspace.Right + bx]
	jne     @Splay8
	mov     dx, es:[Offset TWorkspace.Left + si]
	mov     es:[Offset TWorkspace.Right + bx], dx
	xchg    bx, dx
	mov     es:[Offset TWorkspace.Mom + bx], dx
	mov     bx, es:[Offset TWorkspace.Left + di]
	mov     es:[Offset TWorkspace.Right + si], bx
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     bx, dx
	mov     es:[Offset TWorkspace.Left + si], bx
	mov     es:[Offset TWorkspace.Left + di], si
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     es:[Offset TWorkspace.Mom + si], di
	jmp     @Splay9
@Splay8:
	mov     dx, es:[Offset TWorkspace.Right + di]
	mov     es:[Offset TWorkspace.Left + bx], dx
	xchg    bx, dx
	mov     es:[Offset TWorkspace.Mom + bx], dx
	mov     bx, es:[Offset TWorkspace.Left + di]
	mov     es:[Offset TWorkspace.Right + si], bx
	mov     es:[Offset TWorkspace.Mom + bx], si
	mov     bx, dx
	mov     es:[Offset TWorkspace.Right + di], bx
	mov     es:[Offset TWorkspace.Left + di], si
	mov     es:[Offset TWorkspace.Mom + si], di
	mov     es:[Offset TWorkspace.Mom + bx], di
@Splay9:
	mov     si, cx
	cmp     si, NUL
	ja      @Splay10
	cmp     bx, es:[Offset TWorkspace.Left + si]
	jne     @Splay10
	mov     es:[Offset TWorkspace.Left + si], di
	jmp     @Splay11
@Splay10:
	mov     es:[Offset TWorkspace.Right + si], di
@Splay11:
	mov     es:[Offset TWorkspace.Mom + di], si
	jmp     @Splay1
@end:
END;


PROCEDURE LZSInsertNode; Assembler;
ASM
	les     ax, Workspace
	push    si
	push    dx
	push    cx
	push    bx
	mov     dx, 1
	xor     ax, ax
	mov     matchLen, ax
	mov     height, ax
	mov     al, byte ptr es:[Offset TWorkspace.TextBuf + di]
	shl     di, 1
	add     ax, N + 1
	shl     ax, 1
	mov     si, ax
	mov     ax, NUL
	mov     word ptr es:[Offset TWorkspace.Right + di], ax
	mov     word ptr es:[Offset TWorkspace.Left + di], ax
@Ins1:
	inc     height
	cmp     dx, 0
	jl      @Ins3
	mov     ax, word ptr es:[Offset TWorkspace.Right + si]
	cmp     ax, NUL
	je      @Ins2
	mov     si, ax
	jmp     @Ins5
@Ins2:
	mov     word ptr es:[Offset TWorkspace.Right + si], di
	mov     word ptr es:[Offset TWorkspace.Mom + di], si
	jmp     @Ins11
@Ins3:
	mov     ax, word ptr es:[Offset TWorkspace.Left + si]
	cmp     ax, NUL
	je      @Ins4
	mov     si, ax
	jmp     @Ins5
@Ins4:
	mov     word ptr es:[Offset TWorkspace.Left + si], di
	mov     word ptr es:[Offset TWorkspace.Mom + di], si
	jmp     @Ins11
@Ins5:
	mov     bx, 1
	shr     si, 1
	shr     di, 1
	xor     ch, ch
	xor     dh, dh
@Ins6:
	mov     dl, byte ptr es:[Offset TWorkspace.TextBuf + di + bx]
	mov     cl, byte ptr es:[Offset TWorkspace.TextBuf + si + bx]
	sub     dx, cx
	jnz     @Ins7
	inc     bx
	cmp     bx, F
	jb      @Ins6
@Ins7:
	shl     si, 1
	shl     di, 1
	cmp     bx, matchLen
	jbe     @Ins1
	mov     ax, si
	shr     ax, 1
	mov     matchPos, ax
	mov     matchLen, bx
	cmp     bx, F
	jb      @Ins1
@Ins8:
	mov     ax, word ptr es:[Offset TWorkspace.Mom + si]
	mov     word ptr es:[Offset TWorkspace.Mom + di], ax
	mov     bx, word ptr es:[Offset TWorkspace.Left + si]
	mov     word ptr es:[Offset TWorkspace.Left + di], bx
	mov     word ptr es:[Offset TWorkspace.Mom + bx], di
	mov     bx, word ptr es:[Offset TWorkspace.Right + si]
	mov     word ptr es:[Offset TWorkspace.Right + di], bx
	mov     word ptr es:[Offset TWorkspace.Mom + bx], di
	mov     bx, word ptr es:[Offset TWorkspace.Mom + si]
	cmp     si, word ptr es:[Offset TWorkspace.Right + bx]
	jne     @Ins9
	mov     word ptr es:[Offset TWorkspace.Right + bx], di
	jmp     @Ins10
@Ins9:
	mov     word ptr es:[Offset TWorkspace.Left + bx], di
@Ins10:
	mov     word ptr es:[Offset TWorkspace.Mom + si], NUL
@Ins11:
	cmp     height, 30
	jb      @Ins12
	call    LZSSplay
@Ins12:
	pop     bx
	pop     cx
	pop     dx
	pop     si
	shr     di, 1
END;


Procedure LZSDeleteNode; Assembler;
asm
	les     ax, Workspace
	push    di
	push    bx
	shl     si, 1
	cmp     word ptr es:[Offset TWorkspace.Mom + si], NUL
	je      @del7
	cmp     word ptr es:[Offset TWorkspace.Right + si], NUL
	je      @del8
	mov     di, word ptr es:[Offset TWorkspace.Left + si]
	cmp     di, NUL
	je      @del9
	mov     ax, word ptr es:[Offset TWorkspace.Right + di]
	cmp     ax, NUL
	je      @del2
@del1:
	mov     di, ax
	mov     ax, word ptr es:[Offset TWorkspace.Right + di]
	cmp     ax, NUL
	jne     @del1
	mov     bx, word ptr es:[Offset TWorkspace.Mom + di]
	mov     ax, word ptr es:[Offset TWorkspace.Left + di]
	mov     word ptr es:[Offset TWorkspace.Right + bx], ax
	xchg    ax, bx
	mov     word ptr es:[Offset TWorkspace.Mom + bx], ax
	mov     bx, word ptr es:[Offset TWorkspace.Left + si]
	mov     word ptr es:[Offset TWorkspace.Left + di], bx
	mov     word ptr es:[Offset TWorkspace.Mom + bx], di
@del2:
	mov     bx, word ptr es:[Offset TWorkspace.Right + si]
	mov     word ptr es:[Offset TWorkspace.Right + di], bx
	mov     word ptr es:[Offset TWorkspace.Mom + bx], di
@del3:
	mov     bx, word ptr es:[Offset TWorkspace.Mom + si]
	mov     word ptr es:[Offset TWorkspace.Mom + di], bx
	cmp     si, word ptr es:[Offset TWorkspace.Right + bx]
	jne     @del4
	mov     word ptr es:[Offset TWorkspace.Right + bx], di
	jmp     @del5
@del4:
	mov     word ptr es:[Offset TWorkspace.Left + bx], di
@del5:
	mov     word ptr es:[Offset TWorkspace.Mom + si], NUL
@del7:
	pop     bx
	pop     di
	shr     si, 1
	jmp     @end;
@del8:
	mov     di, word ptr es:[Offset TWorkspace.Left + si]
	jmp     @del3
@del9:
	mov     di, word ptr es:[Offset TWorkspace.Right + si]
	jmp     @del3
@end:
END;


PROCEDURE LZSEncode; Assembler;
ASM
	call    LZSinitTree
	les     bx, Workspace
	xor     bx, bx
	mov     [Offset CodeBuf + bx], bl
	mov     dx, 1
	mov     ch, dl
	xor     si, si
	mov     di, N - F
@Encode2:
	push    es
	call    MemoryGetC
	pop     es
	jc      @Encode3
	mov     byte ptr es:[Offset TWorkspace.TextBuf +di + bx], al
	inc     bx
	cmp     bx, F
	jb      @Encode2
@Encode3:
	or      bx, bx
	jne     @Encode4
	jmp     @Encode19
@Encode4:
	mov     cl, bl
	mov     bx, 1
	push    di
	sub     di, 1
@Encode5:
	push    es
	call    LZSInsertNode
	pop     es
	inc     bx
	dec     di
	cmp     bx, F
	jbe     @Encode5
	pop     di
	push    es
	call    LZSinsertNode
	pop     es
@Encode6:
	mov     ax, matchLen
	cmp     al, cl
	jbe     @Encode7
	mov     al, cl
	mov     matchLen, ax
@Encode7:
	cmp     al, THRESHOLD
	ja      @Encode8
	mov     matchLen, 1
	or      byte ptr codeBuf, ch
	mov     bx, dx
	mov     al, byte ptr es:[Offset TWorkspace.TextBuf + di]
	mov     byte ptr [Offset CodeBuf + bx], al
	inc     dx
	jmp     @Encode9
@Encode8:
	mov     bx, dx
	mov     al, byte ptr matchPos
	mov     byte ptr [Offset Codebuf + bx], al
	inc     bx
	mov     al, byte ptr (matchPos + 1)
	push    cx
	mov     cl, 4
	shl     al, cl
	pop     cx
	mov     ah, byte ptr matchLen
	sub     ah, THRESHOLD + 1
	add     al, ah
	mov     byte ptr [Offset Codebuf + bx], al
	inc     bx
	mov     dx, bx
@Encode9:
	shl     ch, 1
	jnz     @Encode11
	xor     bx, bx
@Encode10:
	mov     al, byte ptr [Offset CodeBuf + bx]
	push    es
	call    DiskPutC
	pop     es
	inc     bx
	cmp     bx, dx
	jb      @Encode10
	mov     dx, 1
	mov     ch, dl
	mov     byte ptr codeBuf, dh
@Encode11:
	mov     bx, matchLen
	mov     lastLen, bx
	xor     bx, bx
@Encode12:
	push    es
	call    MemoryGetC
	pop     es
	jc      @Encode14
	push    ax
	push    es
	call    LZSdeleteNode
	pop     es
	pop     ax
	mov     byte ptr es:[Offset TWorkspace.TextBuf + si], al
	cmp     si, F - 1
	jae     @Encode13
	mov     byte ptr es:[Offset TWorkspace.TextBuf + si + N], al
@Encode13:
	inc     si
	and     si, N - 1
	inc     di
	and     di, N - 1
	push    es
	call    LZSinsertNode
	pop     es
	inc     bx
	cmp     bx, lastLen
	jb      @Encode12
@Encode14:
	sub     printCount, bx
	jnc     @Encode15
	mov     ax, printPeriod
	mov     printCount, ax
@Encode15:
	cmp     bx, lastLen
	jae     @Encode16
	inc     bx
	push    es
	call    LZSdeleteNode
	pop     es
	inc     si
	and     si, N - 1
	inc     di
	and     di, N - 1
	dec     cl
	jz      @Encode15
	push    es
	call    LZSinsertNode
	pop     es
	jmp     @Encode15
@Encode16:
	cmp     cl, 0
	jbe     @Encode17
	jmp     @Encode6
@Encode17:
	cmp     dx, 1
	jb      @Encode19
	xor     bx, bx
@Encode18:
	mov     al, byte ptr [Offset Codebuf + bx]
	push    es
	call    DiskPutC
	pop     es
	inc     bx
	cmp     bx, dx
	jb      @Encode18
@Encode19:
end;



Procedure LZSDecode; Assembler;
asm
	les     dx, Workspace
	xor     dx, dx
	mov     di, N - F
@Decode2:
	shr     dx, 1
	or      dh, dh
	jnz     @Decode3
	push    es
	call    DiskGetC
	pop     es
	jc      @Decode9
	mov     dh, 0ffh
	mov     dl, al
@Decode3:
	test    dx, 1
	jz      @Decode4
	push    es
	call    DiskGetC
	pop     es
	jc      @Decode9
	mov     byte ptr es:[Offset TWorkspace.TextBuf + di], al
	inc     di
	and     di, N - 1
	push    es
	call    MemoryPutC
	pop     es
	jmp     @Decode2
@Decode4:
	push    es
	call    DiskGetC
	pop     es
	jc      @Decode9
	mov     ch, al
	push    es
	call    DiskGetC
	pop     es
	jc      @Decode9
	mov     bh, al
	mov     cl, 4
	shr     bh, cl
	mov     bl, ch
	mov     cl, al
	and     cl, 0fh
	add     cl, THRESHOLD
	inc     cl
@Decode5:
	and     bx, N - 1
	mov     al, byte ptr es:[Offset TWorkspace.TextBuf + bx]
	mov     byte ptr es:[Offset TWorkspace.TextBuf + di], al
	inc     di
	and     di, N - 1
	push    es
	call    MemoryPutC
	pop     es
	inc     bx
	dec     cl
	jnz     @Decode5
	jmp     @Decode2
@Decode9:
END;

Function XLZSSave( FName : string ) : boolean;
begin
	if ArchiveOpen then
	begin
		XLZSSave := false;
		exit;
	end;
	{$I-}
	Assign( XLAFile, FName );
	Rewrite( XLAFile, 1 );
	{$I+}
	if ioresult <> 0 then
	begin
		XLZSSave := false;
		exit;
	end;
	InitBuffers;
	InBufPtr    := BUFSIZE;
	InBufSize   := BUFSIZE;
	OutBufPtr   := 0;
	printcount  := 0;
	height      := 0;
	matchPos    := 0;
	matchLen    := 0;
	lastLen     := 0;
	printPeriod := 0;
	opt         := 0;
	TotalSize   := 0;
	BytesWritten := 0;

	FillChar(Workspace^.TextBuf,N+F-1,0);
	FillChar(Workspace^.Left,(N+1)*2,0);
	FillChar(Workspace^.Mom,(N+1)*2,0);
	FillChar(Workspace^.Right,(N+256)*2,0);
	FillChar(codeBuf,Sizeof(codebuf),0);

	LZSencode;
	DiskWriteOut;
	Close( XLAFile );
	CleanUp;
	XLZSSave := true;
END;

function XLZSLoad( FName : string ) : boolean;
begin
	if ArchiveOpen then
	begin
		XLZSLoad := false;
		exit;
	end;
	{$I-}
	assign( XLAFile, Fname );
	reset( XLAFile, 1 );
	{$I+}
	if ioresult <> 0 then
	begin
		XLZSLoad := false;
		exit;
	end;
	TotalSize := filesize( XLAFile );
	InitBuffers;
	InBufPtr  := BUFSIZE;
	InBufSize := BUFSIZE;
	OutBufPtr := 0;
	FillChar(Workspace^.TextBuf,N+F-1,0);
	BytesWritten := 0;
	LZSdecode;
	MemoryWriteOut;
	close(XLAFile);
	CleanUp;
	XLZSLoad := true;
end;

procedure AddName( var P, Q : PXLADir );
begin
	if P<>nil then
		AddName( P^.next, Q )
	else
		P := Q;
end;

function XCreateArchive( filename : string ) : boolean;
var
	sig : string[4];
begin
	{$I-}
	assign( XLAFile, filename );
	rewrite( XLAFile, 1 );
	{$I+}
	if ioresult <> 0 then
	begin
		XCreateArchive := false;
		exit;
	end;
	sig := 'XLAS';
	move( sig[1], Header.sig, 4 );
	Header.posdir := sizeof(THeader);
	Header.sizedir := 0;
	blockwrite( XLAFile, Header, SizeOf(THeader) );
	XLADir := nil;
	XCreateArchive := true;
	InitBuffers;
	ArchiveOpen := true;
end;

function XEndArchive : boolean;
var
	tmp : PXLADir;
begin
	if not ArchiveOpen then
	begin
		XEndArchive := false;
		exit;
	end;
	seek(XLAFile, header.posdir);
	tmp := XLADir;
	while tmp<>nil do
	begin
		blockwrite( XLAFile, tmp^.item, sizeof(TFile) );
		tmp := tmp^.next;
	end;
	seek( XLAFile, 0 );
	blockwrite( XLAFile, Header, SizeOf(THeader) );
	close( XLAFile );
	CleanUpAll;
	ArchiveOpen := false;
	XEndArchive := true;
end;

function XLAGetFileInfo( fname : string; var origsize, compsize : longint; mode : word ) : boolean;
var
	tmp : PXLADir;
	name : array[0..11] of char;
	i : integer;
begin
	if not ArchiveOpen then
	begin
		XLAGetFileInfo := false;
		exit;
	end;
	for i := 1 to 12 do
		if i<=length( fname ) then
			name[i-1] := fname[i]
		else
			name[i-1] := ' ';
	tmp :=XLADir;
	if tmp = nil then
	begin
		XLAGetFileInfo := false;
		exit;
	end;
	while not xcompare( name, tmp^.item.name, 12 ) do
	begin
		if tmp^.next = nil then
		begin
			XLAGetFileInfo := false;
			exit;
		end;
		tmp := tmp^.next;
	end;
	origsize := tmp^.item.sizefile;
	compsize := tmp^.item.sizecomp;
	mode := tmp^.item.algorithm;
	XLAGetFileInfo := true;
end;

function XLAPut( fname : string; mode : word ) : boolean;
var
	tmp : PXLADir;
	i : integer;
begin
	if not ArchiveOpen then
	begin
		XLAPut := false;
		exit;
	end;
	inc( Header.sizedir );              { Increment size of directory }
	new( tmp );
	tmp^.next := nil;
	tmp^.item.posfile := Header.posdir;
	for i := 1 to 12 do
		if i <= length( fname ) then
			tmp^.item.name[i-1] := fname[i]
		else
			tmp^.item.name[i-1] := ' ';

	InBufPtr    := bufsize;
	Inbufsize   := bufsize;
	OutBufPtr   := 0;
	printcount  := 0;
	height      := 0;
	matchPos    := 0;
	matchLen    := 0;
	lastLen     := 0;
	printPeriod := 0;
	opt         := 0;
	TotalSize   := 0;
	BytesWritten := 0;

	FillChar(Workspace^.TextBuf,N+F-2,0);
	FillChar(Workspace^.Left,(N+1)*2,0);
	FillChar(Workspace^.Mom,(N+1)*2,0);
	FillChar(Workspace^.Right,(N+256)*2,0);
	FillChar(codeBuf,Sizeof(codebuf),0);
	seek( XLAFile, Header.posdir );
	case mode of
		None :
			begin
				XLAInProc( OutBuf, BufSize, TotalSize );
				while TotalSize > 0 do
				begin
					blockwrite(XLAFile, OutBuf, TotalSize );
					BytesWritten := BytesWritten+TotalSize;
					XLAInProc( OutBuf, BufSize, TotalSize );
				end;
				TotalSize := BytesWritten;
				ModeUsed := None;
			end;
		LZS  :
			begin
				LZSencode;
				DiskWriteOut;
				ModeUsed := LZS;
			end;
	end;
	tmp^.item.sizefile := TotalSize;
	tmp^.item.sizecomp := BytesWritten;
	tmp^.item.algorithm := ModeUsed;
	ratio := 100-(100*BytesWritten div TotalSize);
	Header.posdir := Header.posdir + BytesWritten;
	tmp^.next := nil;
	AddName( XLADir, tmp );
	XLAPut := true;
end;

function XLAGet( fname : string ) : boolean;
var
	i : integer;
	name : array[0..11] of char;
	tmp : PXLADir;
begin
	if not ArchiveOpen then
	begin
		XLAGet := false;
		exit;
	end;
	for i := 1 to 12 do
		if i<=length( fname ) then
			name[i-1] := fname[i]
		else
			name[i-1] := ' ';

	tmp := XLADir;

	while not( xcompare( name, tmp^.item.name, 12 ) ) do
	begin
		if tmp = nil then
		begin
			XLAGet := false;
			exit;
		end;
		tmp := tmp^.next;
	end;
	seek( XLAFile, tmp^.item.posfile );
	TotalSize := tmp^.item.sizecomp;
	InBufPtr  := bufsize;
	Inbufsize := bufsize;
	OutBufPtr := 0;
	FillChar(Workspace^.TextBuf,N+F-2,0);
	case tmp^.item.algorithm of
		None :
			begin
				while TotalSize >0 do
				begin
					if TotalSize >= bufsize then
						InBufSize := bufsize
					else
						InBufSize := TotalSize;
					blockread( XLAFile, InBuf, InBufSize );
					XLAOutProc( InBuf, InBufSize );
					TotalSize := TotalSize - InBufSize;
				end;
				ModeUsed := None;
			end;
		LZS :
			begin
				LZSdecode;
				MemoryWriteOut;
				ModeUsed := LZS;
			end;
	end;
	XLAGet := true;
end;

function XOpenArchive( filename : string ) : boolean;
var
	i : integer;
	tmp : PXLADir;
	sig : string[4];
begin
	if ArchiveOpen then
	begin
		XOpenArchive := false;
		exit;
	end;
	{$I-}
	assign( XLAFile, filename );
	FileMode := 0;
	reset( XLAFile, 1 );
	{$I+}
	FileMode := 2;
	if ioresult<>0 then
	begin
		XOpenArchive := false;
		exit;
	end;
	blockread( XLAFile, Header, sizeof(THeader) );
	sig := 'XLAS';
	if not xcompare( Header.sig,sig[1],4 ) then
	begin
		XOpenArchive := false;
		exit;
	end;
	InitBuffers;
	XLADir := nil;
	seek( XLAFile, Header.posdir );
	for i := 1 to Header.sizedir do
	begin
		new(tmp);
		blockread( XLAFile, tmp^.item, sizeof(TFile) );
		tmp^.next := nil;
		AddName(XLADir, tmp);
	end;
	ArchiveOpen := true;
	XOpenArchive := true;
end;

function XUpdateArchive( filename : string ) : boolean;
var
	i : integer;
	tmp : PXLADir;
	sig : string[4];
begin
	if ArchiveOpen then
	begin
		XUpdateArchive := false;
		exit;
	end;
	{$I-}
	assign( XLAFile, filename );
	FileMode := 2;
	reset( XLAFile, 1 );
	{$I+}
	if ioresult<>0 then
	begin
		XUpdateArchive := false;
		exit;
	end;
	blockread( XLAFile, Header, sizeof(THeader) );
	sig := 'XLAS';
	if not xcompare( Header.sig,sig[1],4 ) then
	begin
		XUpdateArchive := false;
		exit;
	end;
	InitBuffers;
	XLADir := nil;
	seek( XLAFile, Header.posdir );
	for i := 1 to Header.sizedir do
	begin
		new(tmp);
		blockread( XLAFile, tmp^.item, sizeof(TFile) );
		tmp^.next := nil;
		AddName(XLADir, tmp);
	end;
	seek( XLAFile, Header.posdir );
	truncate( XLAFile );
	ArchiveOpen := true;
	XUpdateArchive := true;
end;

function XCloseArchive : boolean;
begin
	if not ArchiveOpen then
		XCloseArchive := false
	else
	begin
		close( XLAFile );
		CleanUpAll;
		ArchiveOpen := false;
		XCloseArchive := true;
	end;
end;

procedure XPrintDir;
var
	tmp : PXLADir;
	s : string;
	totsize, totcomp : longint;
begin
	if not ArchiveOpen then exit;
	writeln('Name                Size       CSize   Ratio    Position  Method');
	writeln('----------------------------------------------------------------');
	tmp := XLADir;
	totsize := 0;
	totcomp := 0;
	while tmp <> nil do
	begin
		s[0] := #12;
		move( tmp^.item.name,s[1],12 );
		with tmp^.item do
		begin
			write( s:12,sizefile:12, sizecomp:12, 100-sizecomp*100/sizefile:8:2,
				posfile:12);
			case algorithm of
				None : writeln('  Stored');
				LZS  : writeln('     LZS');
				else   writeln(' Unknown');
			end;
			totsize := totsize + sizefile;
			totcomp := totcomp + sizecomp;
		end;
		tmp := tmp^.next;
	end;
	s := '';
	writeln('----------------------------------------------------------------');
	writeln( s:12, totsize:12, totcomp:12, 100-totcomp*100/totsize:8:2);
end;

function XLAFindNext( var match : string ) : boolean;
var
	d1, d2 : DirStr;
	n1, n2 : NameStr;
	e1, e2 : ExtStr;
	filename : PathStr;
	i : integer;
	wildname, wildext : byte;
	prefixname, prefixext : string[12];
	matchname, matchext : boolean;
begin
	FSplit( SearchPattern, d1, n1, e1 );
	wildname := pos( '*',n1 );
	wildext  := pos( '*',e1 );
	prefixname := copy( n1, 1, wildname-1 );
	prefixext  := copy( e1, 1, wildext-1 );

	while CurrentDir<>nil do
	begin
		move( CurrentDir^.item.name[0], filename[1], 12 );
		i := 0;
		while (i<=11) and ( CurrentDir^.item.name[i]<>' ') do
			inc(i);
		filename[0] := chr(i);
		FSplit( filename, d2, n2, e2 );
		if e2 ='' then e2 :='.';
		matchname := ((wildname=0) and (n1=n2)) or
								 ((wildname>0) and (copy(n2,1,wildname-1)=prefixname));
		matchext  := ((wildext=0) and (e1=e2)) or
								 ((wildext>0) and (copy(e2,1,wildext-1)=prefixext));
		if matchname and matchext then
		begin
			match := filename;
			CurrentDir := CurrentDir^.next;
			XLAFindNext := true;
			exit;
		end else
			CurrentDir := CurrentDir^.next;
	end;
	XLAFindNext := false;
end;

function XLAFindFirst( pattern : string; var match : string ) : boolean;
begin
	CurrentDir := XLADir;
	SearchPattern := pattern;
	XLAFindFirst := XLAFindNext( match );
end;

begin
	ArchiveOpen := false;
	XLADir := nil;
end.
