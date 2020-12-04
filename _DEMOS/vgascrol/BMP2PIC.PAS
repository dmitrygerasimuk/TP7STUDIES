{ BMP to PIC cnv. by Paradise / Fate  }
{ paradise@bachus.umcs.lublin.pl      }
{$i-}

type
 scanline   = array [0..639] of byte;

var
 bmppalette : array [0..255,1..4] of byte;
 picpalette : array [0..255,1..3] of byte;
 pfile      : file;
 screen     : array [0..399] of ^scanline;
 y,ystart   : integer;
 inn,outn   : string;

procedure allocate_scanlines;
begin
 if memavail<640*400 then
 begin
   writeln('No enought memory! (needed 256kb free)');
   halt;
 end;
 for y:=0 to 399 do getmem(screen[y],640);
end;

procedure deallocate_scanlines;
begin
 for y:=0 to 399 do freemem(screen[y],640);
end;

procedure load_bmp;
begin
 assign(pfile,inn);
 reset(pfile,1);
 if ioresult<>0 then
 begin
   deallocate_scanlines;
   writeln('Disk or file error while loading input file!');
   halt;
 end;
 seek(pfile,54);
 blockread(pfile,bmppalette,1024);
 for y:=399 downto 0 do blockread(pfile,screen[y]^,640);
 for y:=0 to 255 do
 begin
  picpalette[y,1]:=bmppalette[y,3] shr 2;
  picpalette[y,2]:=bmppalette[y,2] shr 2;
  picpalette[y,3]:=bmppalette[y,1] shr 2;
 end;
 close(pfile);
end;

procedure write_pic;
begin
 assign(pfile,outn);
 rewrite(pfile,1);
 blockwrite(pfile,picpalette,768);
 for y:=0 to 399 do blockwrite(pfile,screen[y]^,640);
 close(pfile);
end;

begin
 writeln;
 writeln('BMP(640x480) to PIC(640x400) Converter (C) 1995 by Paradise / Fate ');
 if paramcount<>1 then
 begin
   writeln('Usage: BMP2PIC.EXE <file.bmp>');
   halt;
 end;
 inn:=paramstr(1);                     { name.bmp }
 outn:=copy(inn,1,pos('.',inn))+'pic'; { name.pic }
 ystart:=0; { you can change it from 0 to 80 }
 writeln('Make sure that ',inn,' is correct 640x480x256 bmp file!');
 writeln('Converting ',inn,' to ',outn,', wait... ');
 allocate_scanlines;
 load_bmp;
 write_pic;
 deallocate_scanlines;
 writeln('That''s all folks!');
end.