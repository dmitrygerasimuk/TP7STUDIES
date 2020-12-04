//$TITLE New console application with DB engine...
begin
  R:=InputBox('Введите имя приложения:','New_App',8);
  if [R]<>'' then
  begin
    OpenWindow([R]+'.pas');
    InsertText('program '+[R]+';');
    InsertChars('uses DAE, DBFTable, Objects');
    SetTempPos;
    InsertText(';');
    LiteralChar(13);
    InsertText('var D:PDbfTable');
    InsertText('begin');
    InsertText('  InitDataSets');
    InsertChars('  D:=New(PDbfTable, Init(');
    LiteralChar(39);
    LiteralChar(39);
    InsertChars(',stOpen');
    InsertChars('));');
    LiteralChar(13);
    InsertText('  D^.Free;');
    InsertText('  DoneDataSets');
    InsertText('end.');
    LiteralChar(13);
    MoveToTempPos;
  end;
end.
