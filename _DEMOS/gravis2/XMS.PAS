{************************************************}
{   Xms.pas                                      }
{   Graph Vision unit                            }
{   XMS support                                  }
{   Sergey E. Levov, Moscow,1992-1994            }
{************************************************}

unit Xms;

{$F+,S-,D-}

interface

const
   XMS_Initialized : boolean = false;

var
   Xms_Addr : pointer;
   Xms_Status : byte;

const
   Xms_BlockSize = 1024;

{ basic XMS - related procedures }

function Xms_Init : boolean;
function Xms_MemAvail : word;
function Xms_MaxAvail : word;
function Xms_GetMem(Size : word) : word;
procedure Xms_FreeMem(Handle : word);
procedure Xms_MoveMem(Source : pointer; SHandle : word;
                      Dest  : pointer; DHandle : word;
                      Count : LongInt);
procedure Xms_ResizeMem(Handle,Size : word);

implementation

function Xms_Init : boolean; assembler;
asm
        mov     ax,$4300        {Get Install State function}
        int     $2F             {call to XMS driver}
        cmp     al,$80          {XMS driver installed?}
        je      @@1             {no}
        xor     bx,bx
        mov     es,bx
        mov     ax,bx
        mov     byte ptr Xms_Status,$80
        jmp     @@2
@@1:    mov     ax,$4310        {Get XMM Dispatch Addr func}
        int     $2F
        xor     ax,ax
        mov     byte ptr Xms_Status,al
        inc     ax
@@2:    mov     Xms_Addr.word[0],bx
        mov     Xms_Addr.word[2],es
end;

function Xms_MemAvail : word; assembler;
asm
        mov     ah,8
        call    [Xms_Addr]
        mov     byte ptr Xms_Status,bl   { save status code }
        mov     ax,dx            { dx - total free ext mem (in K bytes!) }
end;

function Xms_MaxAvail : word; assembler;
asm
        mov     ah,8
        call    [Xms_Addr]
        mov     byte ptr Xms_Status,bl
@@1:
end;

function Xms_GetMem(Size : word) : word; assembler;
asm
        mov     ah,9
        mov     dx,Size         { in K bytes! }
        call    [Xms_Addr]
        or      ax,ax           { error? }
        je      @@1             { yes }
        xor     bl,bl           { clear error code for any case }
        mov     ax,dx
@@1:    mov     byte ptr Xms_Status,bl
end;

procedure Xms_FreeMem(Handle : word); assembler;
asm
       mov      ah,$A
       mov      dx,Handle
       call     [Xms_Addr]
       or       ax,ax
       je       @@1
       xor      bx,bx
@@1:   mov      byte ptr Xms_Status,bl
end;

procedure Xms_MoveMem(Source : pointer; SHandle : word;
                      Dest  : pointer; DHandle : word;
                      Count : LongInt); assembler;
asm
        mov     ax,Source.word[0]
        xchg    ax,Dest.word[0]
        mov     Source.word[0],ax
        mov     ax,Source.word[2]
        xchg    ax,Dest.word[2]
        mov     Source.word[2],ax
        mov     ax,SHandle
        xchg    ax,DHandle
        mov     SHandle,ax
        lea     si,Count
        push    ds
        pop     es
        push    ss
        pop     ds
        mov     ah,$B
        call    es:[Xms_Addr]
        push    es
        pop     ds
        or      ax,ax
        je      @@1
        xor     bx,bx
@@1:    mov     byte ptr Xms_Status,bl
end;

procedure Xms_ResizeMem(Handle,Size : word); assembler;
asm
        mov     ah,$F
        mov     dx,Handle
        mov     bx,Size
        call    [Xms_Addr]
        or      ax,ax
        je      @@1
        xor     bx,bx
@@1:    mov     byte ptr Xms_Status,bl
end;

begin
   Xms_Initialized := Xms_Init;
end.



