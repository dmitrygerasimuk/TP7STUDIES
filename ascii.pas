program ascii;
uses crt;
    procedure AsciiTable;
        var i : Byte;
        begin
             clrscr;
             for i:=1 to 255 do
             begin
                  write(i,'=',chr(i),' ');
             end;
             readkey;
        end;

Function RandomInteger: Integer; Assembler;
asm

 push BX
 mov AX, CS:9821
 mov BX, 9821
 imul BX
 inc AX
 ror AL, 1
 add AX, 8191
 rol AH, 1
 mov CS:9821, AX
 xor DX, DX
 div CX
 pop BX
 ret
end;

begin
 repeat
 	writeln(RandomInteger);
 	readln;
 until keypressed;
 end.
