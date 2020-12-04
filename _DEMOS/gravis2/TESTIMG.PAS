program testimg;
uses Crt,dos,graph,grdriver,eventman,images;
var
   Filter : PFilter;
   Image : TImage;
   Ch : Char;
   D : DirStr;
   N : NameStr;
   E : ExtStr;
begin
  if ParamStr(1) = '' then exit;
  Fsplit(ParamStr(1),D,N,E);
  if E = '.bmp' then Filter := New(PBmpFilter,Init)
  else if E = '.pcx' then Filter := New(PPcxFilter,Init)
  else Exit;
  InitVideo;
  Image.Import(ParamStr(1),Filter);
  Image.Draw(0,0,NormalPut);
  Ch := ReadKey;
  Image.Done;
  Dispose(Filter,Done);
end.

