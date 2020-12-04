
uses crt;

type ScrType=Record
       Character: char;
       Attribute: byte;
     end;

var
   Screen: array [1..25, 1..80] of ScrType absolute $B800:0000;
   j,i: ShortInt;

begin
     for i:=1 to 80 do
      for j:=1 to 25 do 
        begin

           begin
          Screen[j, i].Character := '*';
          Screen[j, i].Attribute := 20;
     end;
     end;

     Readkey;
end.