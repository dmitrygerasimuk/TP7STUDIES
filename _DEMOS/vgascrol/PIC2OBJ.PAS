{ PIC to OBJ converter by Paradise / Fate }
{ paradise@bachus.umcs.lublin.pl          }
{$I-,M 4000,0,0}

uses dos;
var
 scanlines         : array [0..49,0..639] of byte;
 pfile,bfile       : file;
 palette           : array [0..767] of byte;
 t                 : text;
 name,inn,
 n1,n2,n3,n4       : string;

procedure Save_scanlines(fname: String; once: Boolean);
begin
 if once then
 begin
   assign(bfile,fname);
   rewrite(bfile,1);
 end;
 blockwrite(bfile,scanlines,50*640);
 if not(once) then close(bfile);
end;

procedure Save_palette;
begin
 assign(bfile,name+'.ooo');
 rewrite(bfile,1);
 blockwrite(bfile,palette,768);
 close(bfile);
end;

procedure Convert;
begin
 assign(pfile,inn);
 reset(pfile,1);
 blockread(pfile,palette,768);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n1+'.ooo',True);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n1+'.ooo',False);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n2+'.ooo',True);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n2+'.ooo',False);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n3+'.ooo',True);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n3+'.ooo',False);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n4+'.ooo',True);
 blockread(pfile,scanlines,50*640);
 Save_scanlines(n4+'.ooo',False);
 Save_palette;
 close(pfile);
end;

procedure ObjMake(srcname, dataname: String);
begin
 swapvectors;
 exec('BINOBJ.EXE',srcname+'.ooo '+srcname+' '+dataname);
 swapvectors;
end;

procedure MakeObjs;
begin
 ObjMake(name,'_Pal');
 ObjMake(n1,'_Scr1');
 ObjMake(n2,'_Scr2');
 ObjMake(n3,'_Scr3');
 ObjMake(n4,'_Scr4');
end;

procedure Del(fname: string);
begin
 assign(pfile,fname+'.ooo');
 erase(pfile);
end;

procedure DeleteOOOs;
begin
 Del(name);
 Del(n1);
 Del(n2);
 Del(n3);
 Del(n4);
end;

procedure MakeTpu(uname,oname: String);
begin
 assign(t,uname+'.pas');
 rewrite(t);
 writeln(t,'{ PIC2OBJ data file                                      (C) by Paradise / Fate } ');
 writeln(t,'{ data from : '+oname+'.obj } ');
 writeln(t,'unit '+uname+';');
 writeln(t,'interface');
 writeln(t,' procedure _'+uname+';');
 writeln(t,'implementation');
 writeln(t,'{$l '+oname+'.obj}');
 writeln(t,'procedure _'+uname+'; external;');
 writeln(t,'end.');
 close(t);
end;

procedure MakeTpus;
begin
 MakeTpu('Pal',name);
 MakeTpu('Scr1',n1);
 MakeTpu('Scr2',n2);
 MakeTpu('Scr3',n3);
 MakeTpu('Scr4',n4);
end;



begin
 writeln;
 writeln('PIC2OBJ converter (C) 1995 by Paradise / Fate ');
 if paramcount<>1 then
 begin
   writeln('Usage: PIC2OBJ.EXE <file.pic>');
   halt;
 end;
 inn:=paramstr(1);
 name:=copy(inn,1,pos('.',inn)-1);
 if length(name)>=8 then delete(name,8,length(name)-7);
 n1:=name+'1'; n2:=name+'2'; n3:=name+'3'; n4:=name+'4'; name:=name+'0';
 Convert;
 MakeObjs;
 DeleteOOOs;
 MakeTpus;
 writeln('That''s all folks!');
end.
