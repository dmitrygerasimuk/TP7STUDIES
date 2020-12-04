{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}


Program fontdemo;

{$R-}
uses
	Xlib2, XMisc2, Dos, Crt;

const
	swidth : array[0..9] of char =('0','1','2','3','4','5','6','7','8','9');
var
	fonts : array[0..127] of pointer;
	names : array[0..127] of string[16];
	i, fcount : integer;
	c : char;

Type
	Header = record
		dummy : integer;
		height, width : byte;
	end;

procedure loaduserfonts;
var
	f : file;
	len : word;
	ASearchRec : SearchRec;
begin
	fcount := 0;
	i := 0;
	writeln('XLibPas FontDemo');
{$IFDEF DPMI}
	writeln('DPMI version');
{$ENDIF}
	findfirst('fonts\*.fnt',AnyFile, ASearchRec);
	if doserror<>0 then
	begin
		writeln('No Fonts found in current directory!');
		halt(0);
	end;
	writeln('Loading fonts...');
	repeat
		write(ASearchRec.name,',');
		names[fcount] := ASearchRec.name;
		assign( f, 'fonts\'+names[fcount] );
		reset(f,1);
		len := filesize(f);
		getmem(fonts[fcount],len);
		if fonts[fcount] = nil then
		begin
			writeln('Out of memory');
			halt(0);
		end;
		blockread(f,fonts[fcount]^,len);
		close(f);
		inc(fcount);
		findnext(ASearchRec)
	until doserror<>0;
	writeln;
	writeln('Press ''v'' to view, any other key to quit');
	c:=readkey;
	if (c<>'V') and (c<>'v') then
	begin
		xtextmode;
		halt(0);
	end;
	xtextinit;
	xsetmode(XMODE320x240,320);
	xregisteruserfont(fonts[0]^);
	xsetfont(2);
end;

const
	extract : array[0..15] of string =
		('EXTRACT: Stephen King''s ''SALEM''S LOT'' ',
			'',
			'The memory rose up in almost total    ',
			'sensory reference, and for the moment ',
			'of its totality he was paralyzed. He  ',
			'could even smell the plaster and the  ',
			'wild odour of nesting animals. It     ',
			'seemed to him that the plain varnished',
			'door of Matt Burke''s guest room stood ',
			'between him and all the secrets of    ',
			'Hell. Then he twisted the knob and    ',
			'pushed the door handle inwards...     ',
			'',
			'ABCDEFGHIJKLMNOPQRSTUVWXYZ            ',
			'abcdefghijklmnopqrstuvwxyz 0123456789 ',
			'~!@#$%^&*()_+|`-=\\{}[]:\'';''<>?,./    ');




var
	textline, strindex, height : integer;
	s : string;

begin
	loaduserfonts;
	for i:=0 to fcount-1 do
	begin
		xsetfont(FONT8x8);
		xrectfill(0, 0, 319, 240, 0, 0);
			xline(0,9,319,9,14,0);
			xline(0,ScrnPhysicalHeight-10,319,ScrnPhysicalHeight-10,14,0);
			if Header(fonts[i]^).width = 0 then s := ' W=Variable'
			else s := ' W='+xinttostr(Header(fonts[i]^).width,0);
			xprintf(0,0,0,14,'Font '+names[i]+
								' H='+xinttostr(Header(fonts[i]^).height,0)+s);
			xprintf(0,ScrnPhysicalHeight-8,0,14,'Press a key for next font...');
			xregisteruserfont(fonts[i]^);
			xsetfont(2);
			height:=Header(fonts[i]^).height+1;
			textline:=12;
			strindex:=0;
			while strindex<16 do
			begin
			 xprintf(0,textline,0,14,extract[strindex]);
			 inc(strindex);
			 textline:=textline+height;
			end;

			readkey;
	end;
	xtextmode;
end.


