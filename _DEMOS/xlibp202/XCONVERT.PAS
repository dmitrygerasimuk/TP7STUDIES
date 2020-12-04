Program XConvert;

Uses
	Crt, XBm2, XMisc2, XGif2, Dos;

var
	i : integer;
	dir, tmp : DirStr;
	name : NameStr;
	DestExt,ext : ExtStr;
	filenamein, filenameout, filenamewild : string;
	S : SearchRec;
	NextParam, TConv : string;
	gifheight, gifwidth, error, StartParam, ConvFrom, Conversion : integer;
	inbuff, outbuff : ^TByteArray;
	inbuffoff : longint;
	filein, fileout : file;

const
	CBitmapWidth : integer = 80;

procedure GetPicLine( Var pixels; line, width : integer ); far;
begin
	blockwrite( fileout, pixels, width );
end;

procedure DiscardPicLine( Var pixels; line, width : integer ); far;
begin
end;

procedure StoreLineBuff( Var pixels; line, width : integer ); far;
begin
	gifwidth := width;
	gifheight := line+1;
	if inbuffoff+width<65519 then
		move( pixels, inbuff^[inbuffoff], width );
	inbuffoff := inbuffoff + width;
end;

function convert( filenamein, filenameout : string; ctype, intype : integer ) : boolean;
var
	size : longint;
	actual : word;

	procedure Dealloc;
	begin
		freemem( inbuff, 65520 );
		freemem( outbuff, 65520 );
	end;

begin
	inbuffoff := 0;
	getmem( inbuff, 65520 );
	getmem( outbuff, 65520 );
	if Ctype=4 then
	if (inType<>2) then
		begin
			writeln(' Invalid format ');
			convert := false;
			Dealloc;
			exit;
		end else
		begin
			GIFOutLineProc := GetPicLine;
			{$I-}
			assign(fileout, filenameout);
			rewrite(fileout,1);
			{$I+}
			if IoResult>0 then
			begin
				write(' Rewrite ');
				convert := false;
				Dealloc;
				exit;
			end;
			if LoadGif( filenamein ) > 0 then
			begin
				write(' Invalid GIF file ');
				convert := false;
				Dealloc;
				close( fileout );
				exit;
			end;
			close( fileout );
			convert := true;
			Dealloc;
			exit;
		end;
	if Ctype=3 then
		if (inType<>2) then
		begin
			writeln(' No Pal Info ');
			convert := false;
			Dealloc;
			exit;
		end else
		begin
			GIFOutLineProc := DiscardPicLine;
			{$I-}
			assign(fileout, filenameout);
			rewrite(fileout,1);
			{$I+}
			if IoResult>0 then
			begin
				write(' Rewrite ');
				convert := false;
				Dealloc;
				exit;
			end;
			if LoadGif( filenamein ) > 0 then
			begin
				write(' Invalid GIF file ');
				convert := false;
				Dealloc;
				close( fileout );
				exit;
			end;
			blockwrite( fileout, GIFPalette, sizeof(GIFPalette) );
			close( fileout );
			convert := true;
			Dealloc;
			exit;
		end;
	if intype = 2 then
	begin
		GIFOutLineProc := StoreLineBuff;
		{$I-}
		assign(fileout, filenameout);
		rewrite(fileout,1);
		{$I+}
		if IoResult>0 then
		begin
			write(' Rewrite ');
			convert := false;
			Dealloc;
			exit;
		end;
		if LoadGIF( filenamein ) > 0 then
		begin
			write(' Invalid GIF file ');
			convert := false;
			Dealloc;
			close( fileout );
			exit;
		end;
		if inbuffoff > 65516 then
		begin
			write(' >64K ');
			convert := false;
			Dealloc;
			close( fileout );
			exit;
		end;
		if (ctype=1) and (gifwidth mod 4 <>0) then
		begin
			write(' Width is not a multiple of 4 ');
			convert := false;
			Dealloc;
			close( fileout );
			exit;
		end;
		if (gifwidth>255) or (gifheight>255) then
		begin
			write(' Image too big ');
			convert := false;
			Dealloc;
			close( fileout );
			exit;
		end;
		outbuff^[0] := gifwidth;
		error := 1;
		outbuff^[error] := gifheight;
		move( inbuff^, outbuff^[error+1], inbuffoff );
		size := inbuffoff+2;
		case CType of
			0 : ;
			1 : xbmtopbm(outbuff^,inbuff^);
			2 :
				begin
					if inbuffoff > 19000 then
					begin
						write(' Image too big ');
						convert := false;
						Dealloc;
						close( fileout );
						exit;
					end else
					begin
						size := xsizeofcbitmap(CBitmapWidth,outbuff^);
						xcompilebitmap(CBitmapWidth, inbuff^, outbuff^);
					end;
				end;
			else
				begin
					writeln(' Can''t handle ');
					convert := false;
					close( filein );
					close( fileout );
					Dealloc;
					exit;
				end;
		end;

		blockwrite( fileout, outbuff^, size, Actual );
		close( fileout );

		convert := true;
		Dealloc;
		exit
	end;
	if ( Ctype>=0 ) and ( Ctype<=2 ) and ( intype>=0 ) and (intype<=1) then
	begin
		if Ctype = InType then
		begin
			write(' Nothing to do ');
			Dealloc;
			convert := false;
			exit;
		end;
		{$I-}
		assign(filein, filenamein);
		reset(filein,1);
		{$I+}
		if IoResult>0 then
		begin
			write(' Reset ');
			convert := false;
			Dealloc;
			exit;
		end;
		{$I-}
		assign(fileout, filenameout);
		rewrite(fileout,1);
		{$I+}
		if IoResult>0 then
		begin
			write(' Rewrite ');
			convert := false;
			Dealloc;
			close( filein );
			exit;
		end;
		size := filesize(filein);
		if size>65528 then
		begin
			write(' >64K ');
			convert := false;
			Dealloc;
			close( filein );
			close( fileout );
			exit;
		end;
		blockread( filein, inbuff^, size, Actual );
		if actual<>size then
		begin
			write(' Read ');
			convert := false;
			close( filein );
			close( fileout );
			Dealloc;
			exit;
		end;
		case ctype of
			0 : if intype = 1 then xpbmtobm(inbuff^,outbuff^);
			1 : if intype = 0 then xbmtopbm(inbuff^,outbuff^);
			2 :
				begin
					if intype = 1 then
					begin
						size := xsizeofcpbm(CBitmapWidth,inbuff^);
						xcompilepbm(CBitmapWidth,inbuff^,outbuff^);
					end else
					begin
						size := xsizeofcbitmap(CBitmapWidth,inbuff^);
						xcompilebitmap(CBitmapWidth, inbuff^, outbuff^);
					end;
				end;
			else
				begin
					writeln(' Can''t handle ');
					convert := false;
					close( filein );
					close( fileout );
					Dealloc;
					exit;
				end;
		end;
		blockwrite( fileout, outbuff^, size, Actual );
		if actual<>size then
		begin
			write(' Write ');
			convert := false;
			close( filein );
			close( fileout );
			Dealloc;
			exit;
		end;
		close( filein );
		close( fileout );
	end;
	convert := true;
	Dealloc;
end;

procedure syntax;
begin
	writeln;
	writeln('XConvert is a conversion utility which will convert a number of files');
	writeln('to a format understandable by XLib routines.');
	writeln('XConvert can read the following formats : ');
	writeln('  LBM - XLib Linear bitmap');
	writeln('  PBM - XLib Planar bitmap');
	writeln('  GIF - Compuserve GIF');
	writeln;
	writeln('XConvert can write the following formats : ');
	writeln('  LBM - XLib Linear bitmap');
	writeln('  PBM - XLib Planar bitmap');
	writeln('  CBM - XLib Compiled bitmap');
	writeln('  PAL - XLib raw palette');
	writeln('  SCR - XLib raw screen format');
	writeln;
	writeln('The -W parameter is used to specify the logical screen width for CBM''s');
	writeln('The default value is 80 which is valid for a 320 pixel screen');
	writeln;
	writeln('  Usage :');
	writeln('    XConvert -<LBM|PBM|CBM|PAL> [-W xxx] <filespec> [ <filespec> ..]');
	halt(0);
end;

begin
	writeln('XConvert v1.01 - XLib Conversion utility - FREEWARE');
{$IFDEF DPMI}
	write('DPMI Version - ');
{$ENDIF}
	writeln('(C) 1994 - Tristan Tarrant');
	if paramcount < 2 then syntax;
	TConv := ParamStr(1);
	XStrUpCase( TConv );
	if TConv='-LBM' then
		Conversion := 0
	else
	if TConv='-PBM' then
		Conversion := 1
	else
	if TConv='-CBM' then
		Conversion := 2
	else
	if TConv='-PAL' then
		Conversion := 3
	else
	if TConv='-SCR' then
		Conversion := 4
	else syntax;
	StartParam := 2;
	NextParam := Paramstr(2);
	XStrUpCase( NextParam );
	if NextParam = '-W' then
	begin
		if ParamCount<4 then syntax;
		StartParam := 4;
		val(ParamStr(3), CBitmapWidth, error );
		if error >0 then syntax;
	end;
	DestExt := '.'+copy(TConv,2,3);
	for i := StartParam to Paramcount do
	begin
		filenamewild := ParamStr(i);
		XStrUpCase( filenamewild );
		fsplit(filenamewild,dir,name,ext);
		if ext = '' then ext := '.LBM';
		filenamewild := dir+name+ext;
		findfirst(filenamewild,Archive,S);
		while DosError = 0 do
		begin
			fsplit(S.name,tmp,name,ext);
			if (ext<>'.LBM') and
				 (ext<>'.PBM') and
				 (ext<>'.GIF') then
						writeln('Skipping  : ',S.name, ' -> unknown type.')
			else
			begin
				if ext='.LBM' then
					ConvFrom := 0
				else
				if ext='.PBM' then
					ConvFrom := 1
				else
				if ext='.GIF' then
					ConvFrom := 2;

				filenamein := dir+name+ext;
				filenameout := dir+name+DestExt;
				write('Converting: ',filenamein,' -> ',filenameout);
				if convert(filenamein,filenameout,Conversion,ConvFrom) then
					writeln(' OK')
				else
					writeln(' FAILED');
			end;
			findnext(S);
		end;
	end;
end.
