unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    DBLookupCombo1:PDBLookupCombo;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;
function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface

type
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
   end;

function NewForm2:PDialog;

implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

implementation
function NewForm2:PDialog;
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.
unit UNIT2;
interface
uses Dialogs, Objects, Views, Ext_Dos, Clases, Register, DBCtrls, Grids;

type
   Form2Record=record
      InputLine1:string[255];
   end;

function NewForm2:PDialog;

function NewForm2:PDialog;
implementation
var R:TRect;
    DBLookupCombo2:PDBLookupCombo;
    Label2:PLabel;
    Label1:PLabel;
    DBLookupCombo1:PDBLookupCombo;
    StringGrid1:PStringGrid;
    Button3:PButton;
    Button2:PButton;
    Button1:PButton;
    InputLine1:PInputLine;
    Form2:PDialog;
begin
   R.Assign(  7,  1, 75, 22);
   Form2:=New(PDialog,Init(R,'Данные о зарплате'));
   with Form2^ do
   begin
      R.Assign(  4,  1, 20,  2);
        InputLine1:=New(PInputLine, Init( R ,255));
        Insert(InputLine1);
      R.Assign( 52,  4, 63,  6);
        Button1:=New(PButton, Init( R , '~O~k', cmOK, bfDefault));
        Insert(Button1);
      R.Assign( 52,  6, 63,  8);
        Button2:=New(PButton, Init( R , 'Cancel', cmCancel, bfNormal));
        Insert(Button2);
      R.Assign( 53,  8, 64, 10);
        Button3:=New(PButton, Init( R , '~H~elp', cmHelp, bfNormal));
        Insert(Button3);
      R.Assign(  1,  4, 47, 18);
        StringGrid1:=New(PStringGrid, Init( R ,nil, nil, nil));
        Insert(StringGrid1);
      StringGrid1^.Options:=StringGrid1^.Options or ofFramed;
      R.Assign( 18,  2, 40,  3);
        DBLookupCombo1:=New(PDBLookupCombo, Init( R ,nil, nil, 'K', 'K', 'N1', 'Категория', false));
        Insert(DBLookupCombo1);
      R.Assign( 49,  2, 67,  3);
        DBLookupCombo2:=New(PDBLookupCombo, Init( R ,nil, nil, 'VALUT', 'K', 'N1', 'Вид валюты', false));
        Insert(DBLookupCombo2);
      R.Assign(  1,  2, 18,  3);
        Label1:=New(PLabel, Init( R ,'~К~атегория плат.', nil));
        Insert(Label1);
      R.Assign( 41,  2, 49,  3);
        Label2:=New(PLabel, Init( R ,'~В~алюта', nil));
        Insert(Label2);
      SelectNext(false);
   end;
   Form2^.Initialization;
   NewForm2:=Form2;
end;
end.

