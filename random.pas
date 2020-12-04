unit Random;

interface

procedure SeedRandomNum(ASeed : word);
procedure InitRandom;
function  RandomNum : word;
function  RandomRange(ARange : word): word;

implementation

var
   Fib   : array[1..17] of word;
   i, j  : word;

procedure SeedRandomNum(ASeed : word);
var x : word;
begin
   Fib[1] := ASeed;
   Fib[2] := ASeed;
   for x := 3 to 17 do
      Fib[x] := Fib[x-2] + Fib[x-1];
   i := 17;
   j := ASeed mod 17;
end;

procedure InitRandom;
begin
   SeedRandomNum(MemW[$40:$6C]);
end;

procedure SeedRandom(ASeed : word);
var x : word;
begin
   Fib[1] := ASeed;
   Fib[2] := ASeed;
   for x := 3 to 17 do
      Fib[x] := Fib[x-2] + Fib[x-1];
   i := 17;
   j := ASeed mod 17;
end;

function RandomNum : word;
var k : word;
begin
   k := Fib[i] + Fib[j];
   Fib[i] := k;
   dec(i);
   dec(j);
   if i = 0 then i := 17;
   if j = 0 then j := 17;
   RandomNum := k;
end;

function RandomRange(ARange : word): word;
begin
   RandomRange := RandomNum mod ARange;
end;

end.