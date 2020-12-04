//$TITLE New console application...
begin
  R:=InputBox('Введите имя приложения:','New_App',8);
  if [R]<>'' then
  begin
    OpenWindow([R]+'.pas');
    InsertText('program '+[R]+';');
    InsertChars('uses ');
    SetTempPos;
    InsertText(';');
    LiteralChar(13);
    InsertText('begin');
    LiteralChar(13);
    InsertText('end.');
    LiteralChar(13);
    MoveToTempPos;
  end;
end.
