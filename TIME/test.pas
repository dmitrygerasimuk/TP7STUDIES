uses crt;
var
  i,j: ^integer;
  r: ^real;
begin
  new(i);       {i := HeapOrg; HeapPtr := HeapOrg + 2}
  j := i;       {j := HeapOrg}
  j^ := 2;
  dispose(i);   {HeapPtr := HeapOrg}
  new(r);       {r := HeapOrg; HeapPtr := HeapOrg + 2}
  r^ := pi;
  Writeln(j^)   { ?? }
end.
