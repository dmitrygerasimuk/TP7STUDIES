{$O+}
{$I Define.inc}
unit PrgMng;
interface
uses Views, Dialogs, ResTools, Drivers, Objects;
type
   PProjectListView = ^TProjectListView;
   TProjectListView = object(TListViewer)
     function GetText(Item: Integer; MaxLen: Integer): String; virtual;
   end;
type
   PProjectManager = ^TProjectManager;
   TProjectManager = object(TDialog)
     List:PProjectListView;
     constructor Init;
     destructor Done;virtual;
     procedure HandleEvent(var Event:TEvent);virtual;
     procedure Update;
   end;

const
   ProjectManager:PProjectManager = nil;
implementation
uses GL_Proc, RsCllt, Dos, Ext_Dos, CmdConst, Cursors, Menus, ResStrs, App,
     Register;

   { TProjectListView }
function TProjectListView.GetText(Item: Integer; MaxLen: Integer): String;
var
  F:PFormMain;
  D:string;
  Path: PathStr;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
begin
  F:=ProjectCollection^.At(Item);
  FSplit(F^.ResName, Dir, Name, Ext);
  if Dir=CurrentDir(CurrentDrive) then Path:=Name+Ext else Path:=F^.ResName;
  if F^.FormPtr<>nil then Dir:='(+) ' else Dir:='(-) ';
  GetText:=Dir+F^.FormName^+' in '+FNameReduce(Path,MaxLen-Length(Dir+F^.FormName^)-6)
end;

   { TProjectManager }
constructor TProjectManager.Init;
var
  R:TRect;
  ScrollBar:PScrollBar;
begin
  Desktop^.GetExtent(R);
  R.A.X:=(R.B.X div 3) * 2 - 4;
  R.B.Y:=R.B.Y div 2 + (R.B.Y div 4);
  TWindow.Init(R,GetString(sProjectManager),GetWindowNumber);
  ProjectManager:=@Self;
  GetExtent(R);
    R.Grow(0,-1);
    R.A.X:=R.B.X-1;
    R.A.Y:=R.A.Y+1;
    ScrollBar:=New(PScrollBar, Init( R));
    Insert(ScrollBar);
  GetExtent(R);
  R.Grow(-1,-1);
  Inc(R.A.Y);
    List:=New(PProjectListView, Init(R, 1, nil, ScrollBar));
    List^.GrowMode := gfGrowHiX + gfGrowHiY;
    Insert(List);
    Insert(PView(ResourseFile.Get(sPrgMngMenu)));
  Update;
end;

destructor TProjectManager.Done;
begin
  inherited Done;
  ProjectManager:=nil;
end;

procedure TProjectManager.HandleEvent(var Event:TEvent);
procedure AddToProject;
var Form:PFormMain;
    P:PDialog;
    FileName:FNameStr;
    S:PDosStream;
begin
  FileName:=sExtFrm;
  if ExecDialog(sFormOpenDialog,@FileName)<>cmCancel then
  begin
    S:=New(PDosStream, Init(FileName, stOpenRead));
    P:=PDialog(S^.Get);
    S^.Free;
    if P<>nil then
    begin
      Form:=ProjectCollection^.NewForm(P);
      Application^.InsertWindow(Form^.FormPtr);
      Form^.ResName:=FileName;
      Form^.UnitName:=ReplaceExt(FileName,'.pas',true);
      Message(Application, evBroadcast, cmCurentChang, nil);
    end;
  end
end;

procedure DelFromProject;
var D:PDialog;
    F:PFormMain;
begin
  if ProjectCollection^.Count=0 then exit;
  F:=PFormMain(ProjectCollection^.At(List^.Focused));
  if ExecDialog(sConfirmDelete,@F^.FormName)<>cmCancel then
  begin
    F^.Modified:=false;
    ProjectCollection^.AtDelete(List^.Focused);
    if F^.FormPtr<>nil then F^.FormPtr^.Free;
    Dispose(F);
  end;
  Update;
  Message(Application, evBroadcast, cmCurentChang, nil);
end;

procedure SelectCur;
var Form:PFormMain;
begin
  Form:=ProjectCollection^.At(List^.Focused);
  if Form^.FormPtr<>nil then Form^.FormPtr^.Select
  else LoadForm(Form);
  Update;
  Message(Application, evBroadcast, cmCurentChang, nil);
end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evBroadcast:
    begin
      case Event.Command of
        cmCurSelect,
        cmUpdateDir:Update;
        cmListItemSelected:if Event.InfoPtr=List then SelectCur;
      end;
      exit;
    end;
    evCommand:
    case Event.Command of
      cmAddToProject:AddToProject;
      cmDelFromProject:DelFromProject;
    else
      exit;
    end;
  else
    exit;
  end;
  ClearEvent(Event);
end;

procedure TProjectManager.Update;
begin
   List^.SetRange(ProjectCollection^.Count);
   ReDraw;
end;

end.
