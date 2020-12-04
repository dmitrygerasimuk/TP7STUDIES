UNIT Fade2;

INTERFACE

   PROCEDURE FadeOut;
   PROCEDURE ResetTextMode;
   PROCEDURE GrabPal;
   PROCEDURE BlackOut;
   PROCEDURE FadeIn;

IMPLEMENTATION

VAR Pall,Pall2 : Array[0..255,1..3] of Byte;

PROCEDURE wrt; assembler;
label
  l1, l2;
asm
    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2
end;

PROCEDURE gp(ColorNo : Byte; Var R,G,B : Byte);
Begin
   Port[$3c7] := ColorNo;
   R := Port[$3c9];
   G := Port[$3c9];
   B := Port[$3c9];
End;

PROCEDURE ResetTextMode;
BEGIN
  asm
     mov        ax,03h
     int        10h
  end;
END;

PROCEDURE sp(ColorNo : Byte; R,G,B : Byte);
BEGIN
   Port[$3c8] := ColorNo;
   Port[$3c9] := R;
   Port[$3c9] := G;
   Port[$3c9] := B;
END;

PROCEDURE FadeOut;
VAR lxpy1,lxpy2:integer;
    Tmp : Array [1..3] of byte;
BEGIN
  For lxpy1:=0 to 9 do BEGIN
    wrt;
    For lxpy2:=0 to 255 do BEGIN
      gp (lxpy2,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]>0 then dec (Tmp[1]);
      If Tmp[2]>0 then dec (Tmp[2]);
      If Tmp[3]>0 then dec (Tmp[3]);
      sp (lxpy2,Tmp[1],Tmp[2],Tmp[3]);
    END;
  END;
END;

{??????????????????????????????????????????????????????????????????????????}
Procedure GrabPal;
VAR loop1:integer;
BEGIN
  For loop1:=0 to 255 do
    Gp (loop1,pall2[loop1,1],pall2[loop1,2],pall2[loop1,3]);
END;
{??????????????????????????????????????????????????????????????????????????}
Procedure Blackout;
  { This procedure blackens the screen by setting the pallette values of
    all the colors to zero. }
VAR loop1:integer;
BEGIN
  WRt;
  For loop1:=0 to 255 do
    sP (loop1,0,0,0);
END;


Procedure FadeIn;
Var loop1,loop2:integer;
    Tmp : Array [1..3] of byte;
BEGIN
  For loop1:=1 to 3 do BEGIN
  WRt;
  For loop2:=0 to 255 do
   BEGIN
      Gp (loop2,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]<Pall2[loop2,1] then inc (Tmp[1]);
      If Tmp[2]<Pall2[loop2,2] then inc (Tmp[2]);
      If Tmp[3]<Pall2[loop2,3] then inc (Tmp[3]);
      sP (loop2,Tmp[1],Tmp[2],Tmp[3]);
    END;
  END;
END;

END.