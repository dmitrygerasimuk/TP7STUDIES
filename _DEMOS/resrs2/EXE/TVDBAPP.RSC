//$TITLE Turbo Vision GUI Application with DB...
begin
  R:=InputBox('Введите имя приложения:','NewDBApp',8);
  if R<>'' then
  begin
    OpenWindow(R+'.pas');
    InsertText('program '+R+';');
    InsertText('uses DAE, DBFTable, Objects, Views, App, Menus, Drivers;');
    LiteralChar(13);
    InsertText('type');
    InsertText('  T'+R+' = object(TApplication)');
    InsertText('    constructor Init;');
    InsertText('    destructor Done;virtual;');
    InsertText('    procedure HandleEvent(var Event:TEvent);virtual;');
    InsertText('    procedure InitMenuBar;virtual;');
    InsertText('    procedure InitStatusLine;virtual;');
    InsertText('    procedure Idle;virtual;');
    InsertText('  end;');
    LiteralChar(13);
    InsertText('constructor '+R+'.Init;');
    InsertText('begin');
    InsertText('  inherited Init;');
    InsertText('  InitDataSets;');
    InsertText('end;');
    LiteralChar(13);
    InsertText('destructor '+R+'.Done;');
    InsertText('begin');
    InsertText('  inherited Done;');
    InsertText('  DoneDataSets;');
    InsertText('end;');
    LiteralChar(13);
    InsertText('procedure '+R+'.HandleEvent(var Event:TEvent);');
    InsertText('begin');
    InsertText('  inherited HandleEvent(Event)');
    InsertText('  case Event.What of');
    InsertText('    evCommand:');
    InsertText('    case Event.Command of');
    LiteralChar(13);
    SetTempPos;
    InsertText('    else');
    InsertText('      exit;');
    InsertText('    end;');
    InsertText('  else');
    InsertText('    exit;');
    InsertText('  end;');
    InsertText('  ClearEvent');
    InsertText('end;');
    LiteralChar(13);
    InsertText('var '+R+'App:T'+R+';');
    InsertText('begin');
    InsertText('  '+R+'App.Init;');
    InsertText('  '+R+'App.Run;');
    InsertText('  '+R+'App.Done;');
    InsertText('end.');
    LiteralChar(13);
    MoveToTempPos;
  end;
end.
