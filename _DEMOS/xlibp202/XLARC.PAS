{$G+,N-,E-}

program XLArc;

uses
	XLA2, XMisc2, Dos;

var
	f : file;
	p1, p2, p3 : string;
	S : SearchRec;
	n : NameStr;
	d,d1 : DirStr;
	e : ExtStr;
	tmp : boolean;
	nlines, nfiles, i : integer;
	totratio, size,	compsize, origsize : longint;
	mode : word;
	filename : string;

procedure ReadFile( var data; s : word; var actual : longint ); far;
var
	amountread : word;
begin
	blockread( f, data, s, amountread );
	actual := amountread;
end;

procedure ViewFile( var data; blocksize : word ); far;
var
	i : integer;
begin
	for i := 0 to blocksize - 1 do
		write(TCharArray(data)[i]);
end;

procedure WriteFile( var data; blocksize : word ); far;
begin
	blockwrite( f, data, blocksize );
end;

procedure Usage;
begin
	writeln('XLArc v2.06 - XLib archiving utility - FREEWARE');
{$IFDEF DPMI}
	write('DPMI Version - ');
{$ENDIF}
	writeln('(C) 1994 Tristan Tarrant');
	writeln('Usage :');
	writeln('XLArc l|x|v|a0|a1 archive.XLA filenames');
	writeln('  Switches ');
	writeln('    l - list files in archive');
	writeln('    v - view files in archive');
	writeln('    x - extract files from archive');
	writeln('    a0 - add files to archive with no compression');
	writeln('    a1 - add files to archive with LZS compression');
	halt(0);
end;

begin
	totratio := 0;
	XLAOutProc := WriteFile;
	XLAInProc := ReadFile;
	if ParamCount < 2 then Usage;
	p1 := ParamStr(1);
	p2 := ParamStr(2);
	xstrupcase( p1 );
	xstrupcase( p2 );
	FSplit( p2, d, n, e );
	if e = '' then e := '.XLA';
	p2 := d+n+e;
	if p1 = 'L' then
	begin
		if not XOpenArchive( p2 ) then
		begin
			writeln('Error opening file : ',p2 );
			halt(1);
		end;
		writeln('Contents of archive ',p2 );
		XPrintDir;
		XCloseArchive;
	end else
	if (p1[1] = 'A') and ((p1[2]>='0') or (p1[2]<='1')) then
	begin
		if ParamCount < 3 then Usage;
		if xexists( p2 ) then
		begin
			tmp := XUpdateArchive( p2 );
			if tmp then writeln('Updating archive ',p2);
		end	else
		begin
			tmp := XCreateArchive( p2 );
			if tmp then writeln('Creating archive ',p2);
		end;
		if not tmp then
		begin
			writeln('Cannot create file : ',p2 );
			halt(1);
		end;
		for i := 3 to ParamCount do
		begin
			p3 := ParamStr( i );
			FSplit( p3, d1, n, e );
			FindFirst( p3, Archive, S );
			nfiles := 0;
			while DosError = 0 do
			begin
				if not xexists( d1+S.Name ) then
				begin
					writeln('Cannot open file : ',d1+S.Name );
					halt(1);
				end;
				inc(nfiles);
				FSplit( S.Name, d, n, e );
				if e <> '.XLA'  then
				begin
					if XLAGetFileInfo(S.Name, origsize, compsize, mode) then
						writeln('Skipping file ',S.Name,' : already in archive')
					else
					begin
						assign( f, d1+S.Name );
						reset( f, 1 );
						case p1[2] of
							'0' :
								begin
									write('Storing ', S.Name,'...' );
									XLAPut( S.Name, None );
								end;
							'1' :
								begin
									write('Compressing ', S.Name,'...' );
									XLAPut( S.Name, LZS );
								end;
						end;
						writeln( ratio,'%');
						totratio := totratio + ratio;
						close( f );
					end;
				end;
				FindNext(S);
			end;
		end;
		XEndArchive;
		if nfiles >0 then
			writeln('Total ratio = ',totratio div nfiles,'%');
		writeln('Done.');
	end else
	if (p1 = 'X') or (p1 = 'V') then
	begin
		if p1 = 'V' then XLAOutProc := ViewFile;
		if ParamCount <3 then Usage;
		p3 := ParamStr( 3 );
		xstrupcase( p3 );
		if not XOpenArchive( p2 ) then
		begin
			writeln('Could not open file ',p2 );
			halt(1);
		end;
		tmp := XLAFindFirst( p3, filename );
		if not tmp then
		begin
			Writeln('No matches for ',p3,' in archive ',p2 );
			halt(1);
		end;
		while tmp do
		begin
			if not XLAGetFileInfo(filename, origsize, compsize, mode) then
			begin
				writeln('File ',filename,' does not exist in archive ',p2 );
				halt(1);
			end;
			writeln('Extracting ',filename,'...');
			if p1 = 'X' then
			begin
				assign( f, filename);
				rewrite( f, 1 );
			end;
			if not XLAGet(filename) then
			begin
				writeln('Could not extract ',filename );
				halt(1);
			end;
			if p1 = 'X' then
				close( f );
			tmp := XLAFindNext( filename );
		end;
		XCloseArchive;
		writeln('Done.');
	end else Usage;
end.
