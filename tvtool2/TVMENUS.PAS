{*
*
*   Copyright (c) 1992,93 by Richard W. Hansen
*
*
*}
UNIT TvMenus;
{$B+}
{$X+}
{$V-}

{$I TVDEFS.INC}

INTERFACE


USES
  TvConst,
  App,
  Drivers,
  Menus,
  Views,
  Objects;


CONST
  CheckMark     : String[10] = 'û';
  CheckMarkNull : String[10] = ' ';
  CheckMarkLen  : Byte       = 1;


TYPE
  PbxMenuBar = ^TbxMenuBar;
  TbxMenuBar = Object(TMenuBar)
    Procedure ClearMarker(Cmd : Word);
    Function  FindCmd(AMenu : PMenu;
                      Cmd   : Word): PMenuItem;
    Procedure HandleEvent(var E : TEvent);      Virtual;
    Function  MarkerIsSet(Cmd : Word): Boolean;
    Procedure ResetMarkers(FirstCmd : Word;
                           LastCmd  : Word;
                           NewCmd   : Word);
    Procedure SetMarker(Cmd : Word);
    Procedure ToggleMarker(Cmd : Word);
  end;


Function NewMarkedItem(Name, Param : TMenuStr;
                       KeyCode     : Word;
                       Command     : Word;
                       AHelpCtx    : Word;
                       Next        : PMenuItem): PMenuItem;

Function PopupMenu(PopMenu : PMenuBox): Word;

Function MousePopupMenu(PopMenu : PMenuBox): Word;



{ TvMenu registration procedure }

Procedure RegisterTVMenus;


{ Stream Registration Records }

CONST
  RbxMenuBar: TStreamRec = (
    ObjType : 5250;
    VmtLink : Ofs(TypeOf(TbxMenuBar)^);
    Load    : @TbxMenuBar.Load;
    Store   : @TbxMenuBar.Store
  );

implementation

function PopupMenu(PopMenu: PMenuBox): Word;
var
  Temp: Word;
  Event: TEvent;
  X: Integer;
  Y: Integer;
begin
  X := PopMenu^.Origin.X;
  if (X + PopMenu^.Size.X) > Desktop^.Size.X then
    X := Desktop^.Size.X - PopMenu^.Size.X;
  Y := PopMenu^.Origin.Y;
  if (Y + PopMenu^.Size.Y) > Desktop^.Size.Y then
    Y := Desktop^.Size.Y - PopMenu^.Size.Y;
  if (X < 0) then X := 0;
  if (Y < 0) then Y := 0;
  PopMenu^.MoveTo(X, Y);
  PopupMenu := Desktop^.ExecView(PopMenu);
end;

function MousePopupMenu(PopMenu: PMenuBox): Word;
var
  Temp: Word;
  Event: TEvent;
  Mouse: TPoint;
begin
  repeat
    Desktop^.GetEvent(Event);
  until (Event.What = evMouseUp);
  Desktop^.MakeLocal(MouseWhere, Mouse);
  if (Mouse.X + PopMenu^.Size.X) > Desktop^.Size.X then
    Mouse.X := Desktop^.Size.X - PopMenu^.Size.X;
  if (Mouse.Y + PopMenu^.Size.Y) > Desktop^.Size.Y then
    Mouse.Y := Desktop^.Size.Y - PopMenu^.Size.Y;
  if (Mouse.X < 0) then Mouse.X := 0;
  if (Mouse.Y < 0) then Mouse.Y := 0;
  PopMenu^.MoveTo(Mouse.X, Mouse.Y);
  MousePopupMenu := Desktop^.ExecView(PopMenu);
end;

function NewMarkedItem(Name, Param: TMenuStr; KeyCode: Word; Command: Word;
  AHelpCtx: Word; Next: PMenuItem): PMenuItem;
var
  I: Byte;
begin
  if (Copy(Name, 1, CheckMarkLen) <> CheckMark) then
    Insert(CheckMarkNull, Name, 1);
  if (Name[CheckMarkLen+1] <> ' ') then Insert(' ', Name, CheckMarkLen + 1);
  NewMarkedItem := NewItem(Name, Param, KeyCode, Command, AHelpCtx, Next);
end;

procedure TbxMenuBar.HandleEvent(var E: TEvent);
begin
  if (E.What = evCommand) then
    if (E.Command >= cmMarkStart) AND (E.Command <= cmMarkEnd) then
    begin
      ToggleMarker(E.Command);
    end;
  inherited HandleEvent(E);
end;

procedure TbxMenuBar.ToggleMarker(Cmd: Word);
begin
  if MarkerIsSet(Cmd) then ClearMarker(Cmd) else SetMarker(Cmd);
end;

procedure TbxMenuBar.SetMarker(Cmd:Word);
var
  P: PMenuItem;
  I: Byte;
begin
  P := FindCmd(Menu, Cmd);
  if (P <> nil) then
    for I := 1 to CheckMarkLen do P^.Name^[I] := CheckMark[I];
end;

procedure TbxMenuBar.ClearMarker(Cmd: Word);
var
  P: PMenuItem;
  I: Byte;
begin
  P := FindCmd(Menu, Cmd);
  if (P <> nil) then
    for I := 1 to CheckMarkLen do P^.Name^[I] := CheckMarkNull[I];
end;

function TbxMenuBar.MarkerIsSet(Cmd: Word): Boolean;
var
  P: PMenuItem;
begin
  MarkerIsSet := False;
  P := FindCmd(Menu, Cmd);
  if (P <> nil)
    then MarkerIsSet := (Copy(P^.Name^, 1, CheckMarkLen) = CheckMark);
end;

procedure TbxMenuBar.ResetMarkers(FirstCmd: Word; LastCmd: Word; NewCmd: Word);
var
  P: PMenuItem;
  I: Byte;
begin
  P := FindCmd(Menu, FirstCmd);
  while (P <> nil) do
  begin
    if (P^.Command = NewCmd) then
      for I := 1 to CheckMarkLen do P^.Name^[I] := CheckMark[I]
    else if (P^.Command >= FirstCmd) and (P^.Command <= LastCmd) then
      for I := 1 to CheckMarkLen do P^.Name^[I] := CheckMarkNull[I];
    P := P^.Next;
  end;
end;

function TbxMenuBar.FindCmd(AMenu: PMenu; Cmd: Word): PMenuItem;
var
  P: PMenuItem;
  Found: PMenuItem;
begin
  Found := nil;
  P := AMenu^.Items;
  while (P <> nil) and (Found = nil) do
  begin
    if (P^.Command = 0) and (P^.Name <> nil) then
      Found := FindCmd(P^.Submenu, Cmd)
    else if (P^.Command = Cmd) and not P^.Disabled then
      Found := P;
    P := P^.Next;
  end;
  FindCmd := Found;
end;

procedure RegisterTvMenus;
begin
  RegisterType(RbxMenuBar);
end;

end.
