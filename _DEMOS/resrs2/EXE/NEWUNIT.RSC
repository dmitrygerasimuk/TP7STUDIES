//$TITLE New unit...
begin
  R:=InputBox('Введите имя модуля:','NewUnit1',8);
  if [R]<>'' then
  begin
    OpenWindow([R]+'.pas');
    InsertText('unit '+[R]+';');
    LiteralChar(13);
    InsertText('interface');
    LiteralChar(13);
    InsertText('uses ');
    SetTempPos; 
    InsertText(';');
    LiteralChar(13);
    LiteralChar(13);
    InsertText('implementation');
    LiteralChar(13);
    LiteralChar(13);
    InsertText('end.');
    LiteralChar(13);
    MoveToTempPos;
  end;
end.
