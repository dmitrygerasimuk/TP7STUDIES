{$F+}
unit fwrite;

interface

type ScrType=array [1..25,1..80] of record
       Character: byte;
       Attribute: byte;
     end;
var RenderScreen:ScrType;

 procedure writechar(x,y : byte; c :byte; b:byte);
procedure WaitRetrace(i:byte);
procedure turn_off_cursor;
procedure turn_on_cursor;
procedure TopLine(var ThisScreen:ScrType; Y:byte;Str:String);  { better not to write to absolute screen}
procedure FastWrite (var Screen:ScrType;X,Y:byte;Str:string);
 

implementation

   procedure WaitRetrace(i:byte);
  begin
  if i>0 then begin
    for i:=0 to i do begin

 while (port[$3da] and 8) <> 0 do;   
 while (port[$3da] and 8) = 0 do;
 end;
 end;
 
 end;

 procedure writechar(x,y : byte; c :byte; b:byte);
begin
   
  mem[$b800: (y-1)*80*2 + (x-1)*2] := c;
  mem[$b800: (y-1)*80*2 + (x-1)*2 + 1] := b;
end;

procedure turn_off_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num or 32;
  end;
  {}
  procedure turn_on_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num xor 32;
  end;
 
 procedure TopLine(var ThisScreen:ScrType; Y:byte;Str:String);
  var c,i,j:byte;
  begin
  if not ord(Str[0])>80 then begin
   c:=(80-ord(Str[0])) div 2;
   for i:=1 to c do begin
         ThisScreen[Y,i].Character:=00;
         ThisScreen[Y,i].Attribute:=23;
         end;

  for i:=c+1 to c+ord(Str[0]) do begin
  	   ThisScreen[Y,i].Character:=ord(Str[i-c]);
         ThisScreen[Y,i].Attribute:=23;
         end;
    for i:=ord(Str[0])+c+1 to 80 do begin
         ThisScreen[Y,i].Character:=00;
         ThisScreen[Y,i].Attribute:=23;
         
  end;
  end;
end;
procedure FastWrite (var Screen:ScrType;X,Y:byte;Str:string);
  var i,j:byte;
  begin
    for i:=1 to ord(Str[0]) do begin
          Screen[Y,X+i-1].Character:=ord(Str[i]);
          Screen[Y,X+i-1].Attribute:=15;
         
  end;
end;



end.
