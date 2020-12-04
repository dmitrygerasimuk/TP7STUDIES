unit func;
interface
 procedure fix(var s:string;h:string);
 function Str2int(h:string):longint;
 function int2str(h:longint):string;
 function exist(f:string):boolean;
 procedure wait;
 function ups(s:string):string;
 Procedure CapsLock(ONorOFF:boolean);
 Procedure NumLock(ONorOFF:Boolean);
 Procedure Delay(ms : Word);
 Function ReadKey : char;
implementation

Function ReadKey : char; assembler;
Asm
  mov ah,08h
  int 21h
End;
procedure wait;
var ch:char;
begin
 repeat
  ch:=readkey;
 until ch = chr(13);
end;
Procedure Delay(ms : Word); Assembler;
Asm {machine independent Delay Function}
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  int $15;
end;
function exist(f:string):boolean;
var
  fil : file;
begin
  if f=''
    then
      begin
        exist := false;
        exit;
      end;
  assign(fil,f);
 {$i- }
  reset(fil);
  close(fil);
 {$i+ }
  exist := (ioresult=0);
end;
function int2str(h:longint):string;
var
  s : string;
begin
  str(h,s);
  int2str := s;
end;
procedure fix(var s:string;h:string);
begin
  if pos('.',s)=0
    then s := s+h;
end;
function Str2int(h:string):longint;
var
  d : longint;
  e : integer;
begin
  val(h,d,e);
  str2int := d;
end;

function ups(s:string):string;
var
  d : integer;
begin
  for d := 1 to length(s) do
    s[d] := upcase(s[d]);
  ups := s;
end;
Procedure CapsLock(ONorOFF:boolean);Assembler;

    asm
    cmp ONorOFF,1
    je @BeLight
    jmp @BeDarkness
    @BeLight:
     MOV SI,40h
     MOV ES,SI
     MOV AL,ES:[0017h]
     OR  AL,40h
     MOV ES,SI
     MOV ES:[0017h],AL
     jmp @FINISH
    @BeDarkness:
     MOV SI,40h
     MOV ES,SI
     MOV AL,ES:[0017h]
     AND AL,0BFh
     MOV ES,SI
     MOV ES:[0017h],AL
    @FINISH:
    end;

  Procedure NumLock(ONorOFF:Boolean);Assembler;
    asm
    cmp ONorOFF,1
    je @BeLight
    jmp @BeDarkness
    @BeLight:
     MOV SI,40h
     MOV ES,SI
     MOV AL,ES:[0017h]
     OR  AL,20h
     MOV ES,SI
     MOV ES:[0017h],AL
     jmp @FINISH
    @BeDarkness:
     MOV SI,40h
     MOV ES,SI
     MOV AL,ES:[0017h]
     AND AL,0DFh
     MOV ES,SI
     MOV ES:[0017h],AL
    @FINISH:
    end;

end.