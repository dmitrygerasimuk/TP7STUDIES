
{---------------------------------------------------------------}
{								}
{	Pascal Mouse						}
{	Mouse Interface for Turbo/Borland Pascal 6.0/7.0	}
{	Version 1.5						}
{       June 17 1997						}
{								}
{	Copyright (c) 1996-1997 Horatiu A. Tanescu		}
{								}
{---------------------------------------------------------------}
{	Changing the mouse cursor shape in graphic modes 	}
{---------------------------------------------------------------}

program Cursor;

uses Graph, Mouse;

(* Define a new cursor shape (hour glass) *)

const
  HourGlass : TGraphicCursor = (
    HotSpotX : 7;       (* hot spot X coordinate *)
    HotSpotY : 7;       (* hot spot Y coordinate *)
    (* screen mask (determines what part of the cursor pixel is to be the *)
    (* shape, and what part is to be the background)                      *)
    Masks : (($0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $8001,    (* 1000000000000001 *)
              $C003,    (* 1100000000000011 *)
              $E007,    (* 1110000000000111 *)
              $F00F,    (* 1111000000001111 *)
              $E007,    (* 1110000000000111 *)
              $C003,    (* 1100000000000011 *)
              $8001,    (* 1000000000000001 *)
              $0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $0000,    (* 0000000000000000 *)
              $FFFF),   (* 1111111111111111 *)
    (* cursor mask (determines which pixels contribute to the color of    *)
    (* the cursor)                                                        *)
             ($0000,    (* 0000000000000000 *)
              $7FFE,    (* 0111111111111110 *)
              $6006,    (* 0110000000000110 *)
              $300C,    (* 0011000000001100 *)
              $1818,    (* 0001100000011000 *)
              $0C30,    (* 0000110000110000 *)
              $0660,    (* 0000011001100000 *)
              $03C0,    (* 0000001111000000 *)
              $0660,    (* 0000011001100000 *)
              $0C30,    (* 0000110000110000 *)
              $1998,    (* 0001100110011000 *)
              $33CC,    (* 0011001111001100 *)
              $67E6,    (* 0110011111100110 *)
              $7FFE,    (* 0111111111111110 *)
              $0000,    (* 0000000000000000 *)
              $0000)    (* 0000000000000000 *)
            )
  );

(*
    To create the cursor, the driver uses data from the computer's screen
    memory which defines the color of each pixel on-screen. Operations are
    performed that affect individual screen bits. Software ANDs the screen
    mask defining the pixels under the cursor and XORs the cursor mask with
    the result of the AND operation.

    Screen Mask Bit      Cursor Mask Bit      Resulting Screen Bit
    ---------------      ---------------      --------------------
          0                      0                       0
          0                      1                       1
          1                      0                   unchanged
          1                      1                    inverted
*)

var
  grDriver  : Integer;
  grMode    : Integer;
  ErrorCode : Integer;
  Color     : Integer;

begin
  if not MouseInstalled then  { if a mouse driver is not installed }
  begin                       { then halt program }
    WriteLn('Sorry, mouse is not available');
    Halt(1)
  end;

  { Initialize graphics }
  grDriver := Detect;
  InitGraph(grDriver, grMode, '');
  ErrorCode := GraphResult;
  if ErrorCode <> grOk then   { if an error occurs then halt program }
  begin
    Writeln('Graphics error : ', GraphErrorMsg(ErrorCode));
    Halt(2)
  end;
  OutTextXY(1, 1, 'Left mouse button ends.');

  SetGraphicCursor(HourGlass);{ change cursor shape }
  ShowMouse;                  { show mouse cursor }
  repeat
    ReadMouse;                { read mouse state }
  until LeftButtonPressed;    { repeat until user clicks the left button }
  HideMouse;                  { hide mouse cursor }
  CloseGraph                  { close graphics }
end.