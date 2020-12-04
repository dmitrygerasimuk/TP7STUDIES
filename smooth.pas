Program SmoothTextScroll;
uses crt;
var i : integer;
begin
  for i:=0 to 70 do write('That''s what you are asking for? ');
  port[$3D4]:=8;
  port[$3D5]:=0;
  i:=0;
  repeat
    port[$3D4]:=8;
    port[$3D5]:=9;
    
    inc(i);
  until keypressed
end.