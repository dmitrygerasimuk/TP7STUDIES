{Модуль - создаются интерфейсные элементы}

{$IFDEF VER70}
{$O+}
{$ENDIF}
{$I Define.inc}
unit CrString;
interface
uses Objects, Register;

const
  VerNum = 2.2;
const
  BildStr: string= '';
const
  Signature: string[23] = 'TV resurse maker v 2.0'#26;

procedure CreateStrings(var RezFile:TResourceFile);
procedure CreateStatusLine;
procedure CreateMenu;
implementation
uses Views, DAE, ResStrs, Ext_Type, SelElem, Ext_Str, Reports, App, RESHELP,
     Menus, Drivers, CmdConst, Editors, Ext_Hlp, ResTools, Ext_Dos, Ext_Math,
     Std_Str;

procedure CreateStrings(var RezFile:TResourceFile);
var
  S: PStrListMaker;
  i:integer;
  ii:TComponentType;
  K:TErrorCode;
  TM:TTextMessage;
begin
  S := New(PStrListMaker, Init(65520, 65520));
  S^.Put(sCopyright,'Visual extender '+FloatToStr(VerNum)+' for Borland Pascal Version 7.0 (c) by Alexs 1995-'+
         IntToStr(CurrentYear)+#13#10+
   BildStr+#13#10);
  S^.Put(sHelp,strHelp);
  S^.Put(sOK,strOk);
  S^.Put(sCancel,strCancel);
  S^.Put(sYes,strYes);
  S^.Put(sNo,strNo);
  S^.Put(sWarningStr,{$IFNDEF RUS}'Warning'{$ELSE}'Предупреждение'{$ENDIF});
  S^.Put(sErrorStr,{$IFNDEF RUS}'Error'{$ELSE}'Ошибка'{$ENDIF});
  S^.Put(sInfoStr,{$IFNDEF RUS}'Information'{$ELSE}'Информация'{$ENDIF});
  S^.Put(sConfirmStr,{$IFNDEF RUS}'Confirmation'{$ELSE}'Потверждение'{$ENDIF});
  S^.Put(sPropertylist,{$IFNDEF RUS}'Property list'{$ELSE}'Список свойств'{$ENDIF});
  S^.Put(sMem,{$IFNDEF RUS}'Memory'{$ELSE}'Память'{$ENDIF});
  S^.Put(sDisk,{$IFNDEF RUS}'Disk'{$ELSE}'Диск'{$ENDIF});
  S^.Put(sUknowCmd,{$IFNDEF RUS}'Unknow command ''%s'''{$ELSE}'Неизвестная команда - ''%s'''{$ENDIF});

  S^.Put(sErrorOpenDesk, {$IFNDEF RUS}'Could not open desktop file.'
                         {$ELSE}'Невозможно открыть файл настроек.'{$ENDIF});
  S^.Put(sErrorReadingDesk, {$IFNDEF RUS}'Error reading desktop file.'
                            {$ELSE}'Ошибка чтения файла настроек.'{$ENDIF});
  S^.Put(sDeskInvalid, {$IFNDEF RUS}'Error: Invalid Desktop file.'
                       {$ELSE}'Ошибка в файле настроек.'{$ENDIF});
  S^.Put(sErrorDeskCreate, {$IFNDEF RUS}'Could not create RES2.DSK.'
                           {$ELSE}'Невозможно запистаь файл настроек RES2.DSK.'{$ENDIF});
  S^.Put(sOwerWriteFile, {$IFNDEF RUS}'File ''%s'' already exists. Rewrite it?'
                         {$ELSE}'Файл ''%s'' уже существует. Перезаписать?'{$ENDIF});
  S^.Put(sDosShellMsg,{$IFNDEF RUS}'Type EXIT to return...'#13#10
                      {$ELSE}'Наберите EXIT для возврата в программу...'#13#10{$ENDIF});
  S^.Put(sProgectNotSave,{$IFNDEF RUS}'Progect not save. Save it?'
                         {$ELSE}'Проект не сохранен! Сохранить?'{$ENDIF});
  S^.Put(sToManyUnits,{$IFNDEF RUS}'To many modules.'
                      {$ELSE}'Слишком много подключаемых модулей.'{$ENDIF});
  S^.Put(sReturnCode,{$IFNDEF RUS}'Return code %s.'
                     {$ELSE}'Код возврата %s.'{$ENDIF});
  S^.Put(sUknowType,{$IFNDEF RUS}'Uknow type - %s.'{$ELSE}'Неизвестный тип - %s.'{$ENDIF});

  S^.Put(sErrorOpenDSK,'Error open file RES2.DSK.');//{$IFNDEF RUS}'Error open file RES2.DSK.'{$ELSE}''{$ENDIF});
  S^.Put(sErrorReadDSK,'Error read file RES2.DSK');//{$IFNDEF RUS}'Error read file RES2.DSK'{$ELSE}''{$ENDIF});
  S^.Put(sErrorInDSK,{$IFNDEF RUS}'Error in file RES2.DSK'{$ELSE}''{$ENDIF});
  S^.Put(sErrorCreateDSK,{$IFNDEF RUS}'Error create file RES2.DSK'{$ELSE}''{$ENDIF});
  S^.Put(sErrorWriteDSK,{$IFNDEF RUS}'Error write file RES2.DSK'{$ELSE}''{$ENDIF});
  S^.Put(sInvalidAddres, {$IFNDEF RUS}'Invalid addres value. Format is ''xxxx:yyyy''.'
                        {$ELSE}'Неверное значение для указателя. Фомат значения: ''xxxx:yyyy''.'{$ENDIF});
  S^.Put(sInvalidRange, {$IFNDEF RUS}'Invalid range. Valid range is %d - %d.'
                        {$ELSE}'Неверный диапазон. Значения диапазона - %d - %d.'{$ENDIF});
  S^.Put(sValueNotInRg, {$IFNDEF RUS}'Value ''%s'' not in valid list.'
                        {$ELSE}'Значение ''%s'' не в допустимом списке.'{$ENDIF});
  S^.Put(sNotDate,{$IFNDEF RUS}'''%s'' is not valid date.'{$ELSE}'''%s'' неверная дата.'{$ENDIF});
  S^.Put(sConfirmFreeForm, {$IFNDEF RUS}'Delete form ''%s'' from progect?'
                           {$ELSE}'Удалить форму ''%s'' из проекта?'{$ENDIF});
  S^.Put(sFileNotFound, {$IFNDEF RUS}'File ''%s'' not found.'
                        {$ELSE}'Файл ''%s'' не найден.'{$ENDIF});
  S^.Put(sNotChDir, {$IFNDEF RUS}'Error change dir %s.'
                    {$ELSE}'Ошибка смены каталога ''%s''.'{$ENDIF});
  S^.Put(sStartupIDEWarning,{$IFNDEF RUS}'Changes are written directly to '+
     'RESRS2.INI and do not take effect until you reload the IDE.'
     {$ELSE}'Изменения записаны в файл RESRS2.INI и возымеют действие только после перегрузки программы.'{$ENDIF});
  S^.Put(sNotReturnDir,{$IFNDEF RUS}'Unable to return startup dir.'{$ELSE}''{$ENDIF});

  S^.Put(sNoMem, {$IFNDEF RUS}'Not enough memory available to compilete operation.'
                 {$ELSE}'Нехватает памяти для выполнения этой операции.'{$ENDIF});
  S^.Put(sErrorReading, {$IFNDEF RUS}'Error reading file %s.'
                        {$ELSE}'Ошибка чтения файла %s.'{$ENDIF});
  S^.Put(sErrorWriting, {$IFNDEF RUS}'Error writing file %s.'
                        {$ELSE}'Ошибка записи файла %s.'{$ENDIF});
  S^.Put(sErrorCreating, {$IFNDEF RUS}'Error creating file %s.'
                         {$ELSE}'Ошибка создания файла %s.'{$ENDIF});
  S^.Put(sModified, {$IFNDEF RUS}'%s has been modified. Save?'
                    {$ELSE}'%s был изменён. Сохранить?'{$ENDIF});
  S^.Put(sSaveUntitled, {$IFNDEF RUS}'Save untitled file?'
                        {$ELSE}'Сохранить безымянный файл?'{$ENDIF});
  S^.Put(sStrNotFound, {$IFNDEF RUS}'Search string not found.'
                       {$ELSE}'Искомая строка не найдена'{$ENDIF});
  S^.Put(sReplace, {$IFNDEF RUS}'Replace this occurence?'
                   {$ELSE}'Заменять это вхождение?'{$ENDIF});
  S^.Put(sErrorHelp, {$IFNDEF RUS}'Could not open help file.'
                     {$ELSE}'Невозможно открыть файл помощи.'{$ENDIF});
  S^.Put(sLanguage,{$IFNDEF RUS}'English'{$ELSE}'Русский'{$ENDIF});
  S^.Put(sNotChangeDir,{$IFNDEF RUS}'Unable to change worked dir.'
                       {$ELSE}'Невозможно изменить рабочий каталог'{$ENDIF});
  S^.Put(sComents1, '{'+DupChar('*',58)+'}');
  S^.Put(sComents2,'{       Этот файл создан TV генератором экранов            }');
  S^.Put(sComents3,'{               (c) 1995-'+IntToStr(CurrentYear)+'by Alexs                       }');
  S^.Put(sComents4,'{               %2d.%2d.%4d   %2d:%2d                         }');
  S^.Put(sUnitProto,'unit %s;'#13#10'interface'#13#10#13#10'implementation'#13#10'end.');
  S^.Put(sUnit1,'Editors');
  S^.Put(sUnit1+1,'GauGes');
  S^.Put(sUnit1+2,'DBGrids');
  S^.Put(sUnit1+3,'MultiSel');
  S^.Put(sUnit1+4,'Outline');
  S^.Put(sUnit1+5,'AddCntrl');
  S^.Put(sUnit1+6,'DataCtrl, DBFTable');
  S^.Put(sUnit1+7,'StdDlg');
  S^.Put(sUnit1+8,'AboutPn');
  S^.Put(sUnit1+9,'DBCtrls');
  S^.Put(sUnit1+10,'GadGets');
  S^.Put(sUnit1+11,'ASCIITab');
  S^.Put(sUnit1+12,'Grids');
  S^.Put(sUnit1+13,'El_Lists');
  S^.Put(sUnit1+14,'Reports');
  S^.Put(sUnit1+15,'ColorSel');
  S^.Put(sVarDef,'    %s:P%s;');
  S^.Put(sFieldEditor,{$IFNDEF RUS}'Field editor'{$ELSE}'DDD'{$ENDIF});
  S^.Put(sNotHelpName,{$IFNDEF RUS}'Unknow help file name.'{$ELSE}'Не задано имя файла подсказки.'{$ENDIF});
  S^.Put(sDataSetOpen,{$IFNDEF RUS}'Cannot perform this operation on an open dataset.'
                      {$ELSE}'Невозможно выполнить эту операцию над открытым набором данных.'{$ENDIF});
  S^.Put(sDelRecordConfirm,{$IFNDEF RUS}'Delete record ''%s''?'{$ELSE}'Удалить запись ''%s''?'{$ENDIF});
  S^.Put(sRecalRecordConfirm,{$IFNDEF RUS}'Recall record ''%s''?'{$ELSE}'Восстановить запись ''%s''?'{$ENDIF});
  S^.Put(sSyntaxError,{$IFNDEF RUS}'Syntax error ''%s'' '{$ELSE}'Синтаксическая ошибка ''%s''.'{$ENDIF});
  S^.Put(sDupIdent,{$IFNDEF RUS}'Duplicate identifier ''%s'''{$ELSE}'''%s'' - это имя уже используется.'{$ENDIF});
  S^.Put(sUnknowIdentifier,{$IFNDEF RUS}'''%s'' - Unknow identifier.'{$ELSE}'Неизвестный идентификатор ''%s''.'{$ENDIF});
  S^.Put(sProjectManager,{$IFNDEF RUS}'Project manager'{$ELSE}'Диспетчер проекта'{$ENDIF});
  S^.Put(sFormNotFound,{$IFNDEF RUS}'Form %s not found.'{$ELSE}'Форма %s не найдена'{$ENDIF});
  S^.Put(sNotDisplayClp,{$IFNDEF RUS}'Current clipboard not displaed.'
                              {$ELSE}'Используется буфер обмена Windows. Отображение невозможно.'{$ENDIF});
  S^.Put(sNoLoadForm,{$IFNDEF RUS}'Error at read form %s.'{$ELSE}'Ошибка при чтении формы ''%s''.'{$ENDIF});


(*
  //S^.Put(sExtPas,'*.pas');
  S^.Put(sNewUnit, 'NewUnit.pas');
  S^.Put(sDosVer, 'DOS %d.%d');
  S^.Put(sWinVer, 'WIN %d.%d');


  S^.Put(2100,'Invalid Addres value. Format is ''xxxx:yyyy''.');
  S^.Put(2101,'Invalid range. Valid range is %d - %d');
  S^.Put(2102,^C'Значение не ''%s'' в допустимом списке');
  S^.Put(2103,{$IFNDEF RUS}'''%s'' is not a valid date value'{$ELSE}'Значение ''%s'' не дата.'{$ENDIF});
  S^.Put(sConfirmDelAlias,{$IFNDEF RUS}'Confirm delete alias ''%s''.'{$ELSE}'Невозможно удалит псевдоним ''%s''.'{$ENDIF});
  //S^.Put(sNoLoadForm,{$IFNDEF RUS}'Error at read form %s.'{$ELSE}'Ошибка при чтении формы ''%s''.'{$ENDIF});
  //S^.Put(sSignature,'TV resurse maker v 2.0'#26);
  //S^.Put(sDataSetOpen,{$IFNDEF RUS}'Cannot perform this operation on an open dataset.'
  //                    {$ELSE}'Невозможно выполнить эту операцию над открытым набором данных.'{$ENDIF});
  //S^.Put(sDelRecordConfirm,{$IFNDEF RUS}'Delete record ''%s''?'{$ELSE}'Удалить запись ''%s''?'{$ENDIF});
  //S^.Put(sRecalRecordConfirm,{$IFNDEF RUS}'Recall record ''%s''?'{$ELSE}'Восстановить запись ''%s''?'{$ENDIF});
  //S^.Put(sDupIdent,{$IFNDEF RUS}'Duplicate identifier ''%s'''{$ELSE}'''%s'' - это имя уже используется.'{$ENDIF});

  //S^.Put(sSyntaxError,{$IFNDEF RUS}'Syntax error ''%s'' '{$ELSE}'Синтаксическая ошибка ''%s''.'{$ENDIF});
  //S^.Put(sUnknowIdentifier,{$IFNDEF RUS}'''%s'' - Unknow identifier.'{$ELSE}'Неизвестный идентификатор ''%s''.'{$ENDIF});
  S^.Put(sNotHelpName,{$IFNDEF RUS}'Unknow help file name.'{$ELSE}'Не задано имя файла подсказки.'{$ENDIF});
  //S^.Put(sNotDisplayClp,{$IFNDEF RUS}'Current clipboard not displaed.'
  //                            {$ELSE}'Используется буфер обмена Windows. Отображение невозможно. Извините.'{$ENDIF});
  //S^.Put(sProjectManager,{$IFNDEF RUS}'Project manager'{$ELSE}'Диспетчер проекта'{$ENDIF});
  S^.Put(sFieldEditor,'Field editor');


  S^.Put(sExtDBF,'*.dbf');


  S^.Put(sCmdBase+cmHelp,{$IFNDEF RUS}'~H~elp'{$ELSE}'~П~омощь'{$ENDIF});
  S^.Put(sCmdBase+cmOK,{$IFNDEF RUS}'~O~k'{$ELSE}'~У~гу'{$ENDIF});
  S^.Put(sCmdBase+cmCancel,{$IFNDEF RUS}'Cancel'{$ELSE}'Отмена'{$ENDIF});
  S^.Put(sCmdBase+cmYes,{$IFNDEF RUS}'~Y~es'{$ELSE}'~Д~а'{$ENDIF});
  S^.Put(sCmdBase+cmNo,{$IFNDEF RUS}'~N~o'{$ELSE}'~Н~ет'{$ENDIF});
  //S^.Put(sFormNotFound,{$IFNDEF RUS}'Form %s not found.'{$ELSE}'Форма не найдена'{$ENDIF});
  //S^.Put(sTextExt,'*.txt');
  //S^.Put(sTextSQL,'*.sql');

  S^.Put(sIndex_ITV,'.TVI');
  S^.Put(sIndex_NTX,'.NTX');
  S^.Put(sIndex_IND,'.IND');
  S^.Put(sIndex_NDX,'.NDX');
  S^.Put(sIndex_IDX,'.IDX');
  S^.Put(110+Ord(alNone), 'alNone');
  S^.Put(110+Ord(alTop),'alTop');
  S^.Put(110+Ord(alBottom),'alBottom');
  S^.Put(110+Ord(alLeft),'alLeft');
  S^.Put(110+Ord(alRight),'alRight');
  S^.Put(110+Ord(alClient),'alClient');
  S^.Put(110+Ord(alCenter),'alCenter');
  S^.Put(sStateFlagBase+0,'sfVisible + ');
  S^.Put(sStateFlagBase+1,'sfCursorVis + ');
  S^.Put(sStateFlagBase+2,'sfCursorIns + ');
  S^.Put(sStateFlagBase+3,'sfShadow + ');
  S^.Put(sStateFlagBase+4,'sfActive + ');
  S^.Put(sStateFlagBase+5,'sfSelected + ');
  S^.Put(sStateFlagBase+6,'sfFocused + ');
  S^.Put(sStateFlagBase+7,'sfDragging + ');
  S^.Put(sStateFlagBase+8,'sfDisabled + ');
  S^.Put(sStateFlagBase+9,'sfModal + ');
  S^.Put(sStateFlagBase+10,'sfDefault + ');
  S^.Put(sStateFlagBase+11,'sfExposed + ');

  //S^.Put(sInsert,'  Insert(%s);');
  //S^.Put(sNew,'  %s:=New(P%s, Init( R ');
  //S^.Put(sSelEnd, '      SelectNext(false);'#13#10'   end;');
  for k:=edbNoError to High(TErrorCode) do
      S^.Put(2500+byte(k),StdErrorNames(k));

{  S^.Put(sErrorinStream, 'Error in stream: %d - %s ');}
  S^.Put(101+stOk, {$IFNDEF RUS}'No error'
                   {$ELSE}'Нет ошибок'{$ENDIF});
  S^.Put(101+stError, {$IFNDEF RUS}'Access error'
                      {$ELSE}'Ошибка доступа'{$ENDIF});
  S^.Put(101+stInitError, {$IFNDEF RUS}'Cannot initialize stream'
                          {$ELSE}'Невозможно инициализировтаь поток'{$ENDIF});
  S^.Put(101+stReadError, {$IFNDEF RUS}'Read beyond end of stream'
                          {$ELSE}'Чтение за пределами потока'{$ENDIF});
  S^.Put(101+stWriteError, {$IFNDEF RUS}'Cannot expand stream'
                           {$ELSE}'Невозможно расширить поток'{$ENDIF});
  S^.Put(101+stGetError, {$IFNDEF RUS}'Get of unregistered object type'
                         {$ELSE}'Ошибка чтения незарегестрированного объекта'{$ENDIF});
  S^.Put(101+stPutError, {$IFNDEF RUS}'Put of unregistered object type'
                         {$ELSE}'Ошибка записи незарегистрированного объекта'{$ENDIF});
  S^.Put(sErrorExecMacro, {$IFNDEF RUS}'Error compile macro %s.'
                         {$ELSE}'Ошибка компиляции макроса %s.'{$ENDIF});

  //S^.Put(sbfNormal,'bfNormal');
  //S^.Put(sbfDefault,'bfDefault+');
  //S^.Put(sbfLeftJust,'bfLeftJust+');
  //S^.Put(sbfBroadcast,'bfBroadcast+');
  //S^.Put(sbfGrabFocus,'bfGrabFocus+');


  S^.Put(500,'unit %s;'#13#10'interface'#13#10#13#10'implementation'#13#10'end.');
  S^.Put(501,'function %s:PDialog;'#13#10'var R:TRect;');
  S^.Put(503,'    %s:PDialog;'#13#10'begin');
  S^.Put(505,'end;'#13#10'end.');
  S^.Put(506,'   %s:=New(PDialog,Init(R,'#39'%s'#39'));');
  S^.Put(507,'   with %s^ do'#13#10'   begin');
  S^.Put(508,'      Pallete:=dpBlueDialog;');
  S^.Put(509,'      Pallete:=dpCyanDialog;');
  S^.Put(510, 'New(PDbfTable, Init('#13#10'          ''%s'', stOpen))));');
  S^.Put(511,#32#39'%s'#39', %s, %s');
  S^.Put(512,'NewSItem('#39'%s'#39',');
  S^.Put(513,'R.Assign(%3d,%3d,%3d,%3d);');
  //S^.Put(514,'    %s:P%s;');
  S^.Put(Byte(rlsDate)+515,'Дата печати - %s');
  S^.Put(Byte(rlsTime)+515,'Время печати - %s');
  S^.Put(Byte(rlsDateTime)+515,'Дата и время печати - %s');
  S^.Put(Byte(rlsPageNo)+515,'Страница - %d');
  S^.Put(Byte(rlsLineNo)+515,'%d');
  S^.Put(520,'TValidator');
  S^.Put(521,'TPXPictureValidator');
  S^.Put(522,'TLookupValidator');
  S^.Put(523,'TFilterValidator');
  S^.Put(524,'TStringLookupValidator');
  S^.Put(525,'TRangeValidator');
  S^.Put(526,'        with %s^ do'#13#10+
             '        begin');
  S^.Put(527,'        end;');
  S^.Put(528,'   %s^.Initialization;');
  S^.Put(529,'   %s:=%s;');
  S^.Put(530,'rlsDate');
  S^.Put(531,'rlsTime');
  S^.Put(532,'rlsDateTime');
  S^.Put(533,'rlsPageNo');
  S^.Put(534,'rlsLineNo');
  S^.Put(504,'unit %s;'#13#10'interface'#13#10'uses Dialogs, Objects, Views, Ext_Dos, Clases, Register');
  S^.Put(535,'function %s:PDialog;'#13#10#13#10'implementation'#13#10);
  S^.Put(536,'type'#13#10'   %sRecord=record');
  S^.Put(537,'   end;'#13#10);
  S^.Put(538,'record'#13#10'               Length: Word;'#13#10'               Buffer:array[0..%d];'#13#10'             end');
  S^.Put(539,'unit ');
  S^.Put(540,#13#10'interface'#13#10#13#10'const'#13#10);
  S^.Put(541,#13#10'implementation'#13#10#13#10'end.');
  S^.Put(542,'  hc%-40s = %d;');
  S^.Put(543,'Unresolved forward reference "');
  S^.Put(544,#32#39'%s'#39', %s, %s, %s');
  S^.Put(545,'^.DataSet^.OpenIndex(''%s'');');
  S^.Put(546,'csBackground');
  S^.Put(547,'csForeground');
  S^.Put(548,'rsRectangle');
  S^.Put(549,'rsTopAndBottom');
  S^.Put(550,'rsRightAndLeft');
  S^.Put(551,'psSingleLine');
  S^.Put(552,'psDoubleLine');
  S^.Put(553,'    %s%s:%s;');
  S^.Put(554,'%s%s%s:=%s(%s.^FieldByName(''%s''));');

  for TM:=txtSQLWait to High(TTextMessage) do
      S^.Put(700+byte(TM), stdDBTextMessageFunc(TM));

  S^.Put(sCodeGenBase,   '{$F-,');
  S^.Put(sCodeGenBase+1, '{$F+,');
  S^.Put(sCodeGenBase+2, 'O-,');
  S^.Put(sCodeGenBase+3, 'O+,');
  S^.Put(sCodeGenBase+4, 'A-,');
  S^.Put(sCodeGenBase+5, 'A+,');
  S^.Put(sCodeGenBase+6, 'G-,');
  S^.Put(sCodeGenBase+7, 'G+,');
  S^.Put(sRuntimeErrorsBase,   'R-,');
  S^.Put(sRuntimeErrorsBase+1, 'R+,');
  S^.Put(sRuntimeErrorsBase+2, 'S-,');
  S^.Put(sRuntimeErrorsBase+3, 'S+,');
  S^.Put(sRuntimeErrorsBase+4, 'I-,');
  S^.Put(sRuntimeErrorsBase+5, 'I+,');
  S^.Put(sRuntimeErrorsBase+6, 'Q-,');
  S^.Put(sRuntimeErrorsBase+7, 'Q+,');
  S^.Put(sSyntaxOptionsBase  , 'V-,');
  S^.Put(sSyntaxOptionsBase+1, 'V+,');
  S^.Put(sSyntaxOptionsBase+2, 'B-,');
  S^.Put(sSyntaxOptionsBase+3, 'B+,');
  S^.Put(sSyntaxOptionsBase+4, 'X-,');
  S^.Put(sSyntaxOptionsBase+5, 'X+,');
  S^.Put(sSyntaxOptionsBase+6, 'T-,');
  S^.Put(sSyntaxOptionsBase+7, 'T+,');
  S^.Put(sSyntaxOptionsBase+8, 'P-,');
  S^.Put(sSyntaxOptionsBase+9, 'P+,');
  S^.Put(sDebuggingBase,  'D-,');
  S^.Put(sDebuggingBase+1,'D+,');
  S^.Put(sDebuggingBase+2,'L-,');
  S^.Put(sDebuggingBase+3,'L+,');
  S^.Put(sDebuggingBase+4,'Y-,');
  S^.Put(sDebuggingBase+5,'Y+,');
  S^.Put(sNumericProcessingBase,  'N-,');
  S^.Put(sNumericProcessingBase+1,'N+,');
  S^.Put(sNumericProcessingBase+2,'E-}');
  S^.Put(sNumericProcessingBase+3,'E+}');
  S^.Put(sConditionalDefines,#13#10'{$DEF %s}');


  //S^.Put(sMenuBar,'MenuBar');
  //S^.Put(sStatusLine,'StatusLine');
  //S^.Put(sAbout,'About');
  //S^.Put(sObjectInspector,'ObjectInspector');
  S^.Put(sSaveAsReport,'SaveAsReport');
  //S^.Put(sFormOpenDialog,'FormOpenDialog');
  //S^.Put(sFormSaveDialog,'FormSaveDialog');
  S^.Put(2104,'SaveAsReport');
  //S^.Put(sSetInputLineOption, 'SetInputLineOption');
  //S^.Put(sSetPswInputLine, 'SetPswInputLine');
  //S^.Put(sCommandDB,'CommandDB');
  //S^.Put(sChDirDialog,'ChDirDialog');
  //S^.Put(sMouseDlg,'MouseDlg');
  //S^.Put(sDirForm,'DirForm');
  //S^.Put(sColorDlg,'ColorDlg');
  //S^.Put(sFileOpenDialog,'FileOpenDialog');
  //S^.Put(sCommandNameDB,'CommandNameDB');
  S^.Put(sInfoDlg,'InfoDlg');
  S^.Put(sAsciiTable,'AsciiTable');
  S^.Put(sCalendarWindow,'CalendarWindow');
  S^.Put(sPuzzle,'Puzzle');
  S^.Put(sNodeObj,'NodeObj');
  S^.Put(sScrlBrOpt,'ScrlBrOpt');
  S^.Put(sListBoxOpt,'ListBoxOpt');
  S^.Put(sParamTextOpt,'ParamTextOpt');
  S^.Put(sClusterOpt,'ClusterOpt');
  S^.Put(sPercentGauge,'PercentGaugeOpt');
  S^.Put(sBarGauge,'BarGaugeOpt');
  S^.Put(sRangeILineOpt,'RangeILineOpt');
  S^.Put(sAboutPanelOpt,'AboutPanelOpt');
  S^.Put(sLabelSetOpt,'LabelSetOpt');
  S^.Put(sFormInspector,'Form Inspector');
  S^.Put(sButtonsOpt,'ButtonsOpt');
  S^.Put(sStaticTextOpt,'StaticTextOpt');
  S^.Put(sColorTextOpt,'ColorTextOpt');
  S^.Put(sMemoOpt,'MemoOpt');
  S^.Put(sDBSourseOpt,'DBSourseOpt');
  //S^.Put(sDBFOpenDialog,'DBFOpenDialog');
  //S^.Put(sSaveAsDialog,'SaveAsDialog');
  //S^.Put(sFindDialog,'FindDialog');
  //S^.Put(sReplaceDialog,'ReplaceDialog');
  //S^.Put(sGNOpt,'GNOpt');
  //S^.Put(sCompOpt,'CompOpt');
  //S^.Put(sPrefDlg,'PrefDlg');
  //S^.Put(sDSKOpenDialog,'DSKOpenDialog');
  //S^.Put(sDSKSaveDialog,'DSKSaveDialog');
  //S^.Put(sEditorOptions,'EditorOptions');

  S^.Put(sGridOpt,'GridOpt');
  //S^.Put(sProgectDialog,'ProgectDialog');
  //S^.Put(sElemList,'ElemList');
  //S^.Put(sGoLine,'GoLine');
  S^.Put(sPrgDlg,'PrgDlg');
  //S^.Put(sProgectSaveDialog,'ProgectSaveDialog');
  //S^.Put(sStartupDlg,'StartupDlg');
  //S^.Put(sText_editor, 'Text editor');
  //S^.Put(sConfirmDelete,'ConfirmDelete');
  //S^.Put(sTReportPopUp,'TReportPopUp');
  //S^.Put(sTDBGridPopUp,'TDBGridPopUp');
  //S^.Put(sFieldListDlg,'FieldListDlg');
  //S^.Put(sTDBSoursePopUp,'TDBSoursePopUp');
  //S^.Put(sReindexsForm,'ReindexsForm');
  S^.Put(sIndexOpenDialog,'IndexOpenDialog');
  //S^.Put(sRepositoryDlg,'RepositoryDlg');
  //S^.Put(sRepositFile,'Reposit.tvr');
  //S^.Put(sAddRepositoryDlg,'AddRepositoryDlg');
  S^.Put(sDataBaseWindow, 'DataBaseWindow');
  S^.Put(sReportForm,'Report form');
  //S^.Put(sDEPref,'DEPref');
  S^.Put(sExpDlgForm,'DialogWizzardForm_0');
  S^.Put(sExpDlgForm1,'DialogWizzardForm_1');
  S^.Put(sExpDlgForm2,'DialogWizzardForm_2');
  S^.Put(sPTabbedNotebook,'PTabbedNotebook0');
  S^.Put(sPTabbedNotebook1,'PTabbedNotebook1');
  S^.Put(sPTabbedNotebook2,'PTabbedNotebook2');
  S^.Put(sIndexPageStack,'IndexPageStack');
  //S^.Put(sInfoStruDialog,'InfoStruDialog');
  S^.Put(sNewIndexDlg,'NewIndexDlg');
  //S^.Put(sProgectOpt,'ProgectOpt');
  S^.Put(sOpenHelpFileDialog,'OpenHelpFileDialog');
  S^.Put(sCompHelpStatDlg,'CompHelpStatDlg');
  S^.Put(sTQueryPopUp,'TQueryPopUp');
  S^.Put(sParamsProperty,'ParamsProperty');
  S^.Put(sConfirmDeleteParam,'Удалить параметр %s ?');
  //S^.Put(sNewDBFieldDialog,'NewDBFieldDialog');
  //S^.Put(sDBFCreateDialog,'DBFCreateDialog');
  //S^.Put(sTViewPopUp,'TViewPopUp');
  S^.Put(sDBAliasEditor,'DBAliasEditor');
  S^.Put(sDBAliasProperty, 'DBAliasProperty');
  S^.Put(sDAE_CFG_LOAD,'DAE_CFG_LOAD');
  S^.Put(sDAE_CFG_STORE,'DAE_CFG_STORE');
  //S^.Put(sCreateIndexDlg,'CreateIndexDlg');
  //S^.Put(sTabOrderDlg,'TabOrderDlg');
  //S^.Put(sSizeDialog,'SizeDialog');
  //S^.Put(sSelectMaster,'SelectMaster');
  //S^.Put(sOpenText,'OpenText');
  //S^.Put(sSaveText,'SaveText');
  //S^.Put(sOpenSQL,'OpenSQL');
  //S^.Put(sSaveSQL,'SaveSQL');
  //S^.Put(sPrnOptDlg,'PrnOptDlg');
  //S^.Put(sAddHelpFileDlg,'AddHelpFileDlg');
  //S^.Put(sOpenTPH,'OpenTPH');
  //S^.Put(sPrgMngMenu,'PrgMngMenu');
  //S^.Put(sPrintFileDlg,'PrintFileDlg');
  //S^.Put(sWriteBlock,'WriteBlock');
  //S^.Put(sReadBlock,'ReadBlock');
  S^.Put(sPrepReport1,'PrepReport1');
  S^.Put(sPrepReport2,'PrepReport2');
  //S^.Put(sAppWizardDlg,'AppWizardDlg');
*)
  S^.Put(4000+byte(ftUnknown),'ftUnknown');
  S^.Put(4000+byte(ftString), 'ftString');
  S^.Put(4000+byte(ftSmallint), 'ftSmallint');
  S^.Put(4000+byte(ftInteger), 'ftInteger');
  S^.Put(4000+byte(ftWord), 'ftWord');
  S^.Put(4000+byte(ftBoolean), 'ftBoolean');
  S^.Put(4000+byte(ftFloat), 'ftFloat');
  S^.Put(4000+byte(ftCurrency), 'ftCurrency');
  S^.Put(4000+byte(ftBCD), 'ftBCD');
  S^.Put(4000+byte(ftDate), 'ftDate');
  S^.Put(4000+byte(ftTime), 'ftTime');
  S^.Put(4000+byte(ftDateTime), 'ftDateTime');
  S^.Put(4000+byte(ftBytes), 'ftBytes');
  S^.Put(4000+byte(ftVarBytes), 'ftVarBytes');
  S^.Put(4000+byte(ftAutoInc), 'ftAutoInc');
  S^.Put(4000+byte(ftBlob), 'ftBlob');
  S^.Put(4000+byte(ftMemo), 'ftMemo');
  S^.Put(4000+byte(ftGraphic), 'ftGraphic');
  S^.Put(4000+byte(ftFmtMemo), 'ftFmtMemo');
  S^.Put(4000+byte(ftParadoxOle), 'ftParadoxOle');
  S^.Put(4000+byte(ftDBaseOle), 'ftDBaseOle');
  S^.Put(4000+byte(ftTypedBinary), 'ftTypedBinary');

  S^.Put(4030+byte(ftUnknown),'PField');
  S^.Put(4030+byte(ftString), 'PStringField');
  S^.Put(4030+byte(ftSmallint), 'ftSmallint');
  S^.Put(4030+byte(ftInteger), 'PIntegerField');
  S^.Put(4030+byte(ftWord), 'ftWord');
  S^.Put(4030+byte(ftBoolean), 'PBooleanField');
  S^.Put(4030+byte(ftFloat), 'PFloatField');
  S^.Put(4030+byte(ftCurrency), 'PCurrencyField');
  S^.Put(4030+byte(ftBCD), 'ftBCD');
  S^.Put(4030+byte(ftDate), 'PDateField');
  S^.Put(4030+byte(ftTime), 'PTimeField');
  S^.Put(4030+byte(ftDateTime), 'PDateTimeField');
  S^.Put(4030+byte(ftBytes), 'ftBytes');
  S^.Put(4030+byte(ftVarBytes), 'ftVarBytes');
  S^.Put(4030+byte(ftAutoInc), 'ftAutoInc');
  S^.Put(4030+byte(ftBlob), 'PBlobField');
  S^.Put(4030+byte(ftMemo), 'PMemoField');
  S^.Put(4030+byte(ftGraphic), 'ftGraphic');
  S^.Put(4030+byte(ftFmtMemo), 'ftFmtMemo');
  S^.Put(4030+byte(ftParadoxOle), 'ftParadoxOle');
  S^.Put(4030+byte(ftDBaseOle), 'ftDBaseOle');
  S^.Put(4030+byte(ftTypedBinary), 'ftTypedBinary');

  for ii:=0 to CountComponents do
      S^.Put(sComponentTypeNameBase+Ord(ii), ANameType(ii));

  RezFile.Put(S, 'Strings');
  Dispose(S, Done);


  S := New(PStrListMaker, Init(65520, 65520));
  S^.Put(hcWindows,{$IFNDEF RUS}'Open, arrange, and list windows'
                   {$ELSE}'Открытие, упорядочивание и список окон'{$ENDIF});
  S^.Put(hcMWindowList,{$IFNDEF RUS}'Show a list of all open windows'
                       {$ELSE}'Показать список всех открытых окон'{$ENDIF});
  S^.Put(hcTile,{$IFNDEF RUS}'Arrange windows on desktop by tiling'
                {$ELSE}'Упорядочить все окна черепицей'{$ENDIF});
  S^.Put(hcCascade,{$IFNDEF RUS}'Arrange windows on desktop by cascading'
                   {$ELSE}'Упорядочить все окна каскадом'{$ENDIF});
  S^.Put(hcCloseAll,{$IFNDEF RUS}'Close all windows on the desktop'
                    {$ELSE}'Закрыть все окна'{$ENDIF});
  S^.Put(hcResize,{$IFNDEF RUS}'Change the size or position of the active window'
                  {$ELSE}'Изменить размер или положение текущего окна'{$ENDIF});
  S^.Put(hcZoom,{$IFNDEF RUS}'Enlarge or restore the size of the active window'
                {$ELSE}'Свернуть или востановить текущее окно'{$ENDIF});
  S^.Put(hcNext,{$IFNDEF RUS}'Make the next window active'
                {$ELSE}'Перейти в следующее окно'{$ENDIF});
  S^.Put(hcPrev,{$IFNDEF RUS}'Make the previous window active'
                {$ELSE}'Вернуться в первыдущее окно'{$ENDIF});
  S^.Put(hcClose,{$IFNDEF RUS}'Close the active window'
                 {$ELSE}'Закрыть текущее окно'{$ENDIF});
(*  S^.Put(hcUndo,{$IFNDEF RUS}'Undo the previous editor operation'
                {$ELSE}'Отменить превыдущую операцию'{$ENDIF});
  S^.Put(hcCut,{$IFNDEF RUS}'Remove the selected text and put it in the Clipboard'
               {$ELSE}'Вырезать выделенный текст в буфер обмена'{$ENDIF});
  S^.Put(hcCopy,{$IFNDEF RUS}'Copy the selected text into the Clipboard'
                {$ELSE}'Скопировать выделенный текст в буфер обмена'{$ENDIF});
  S^.Put(hcPaste,{$IFNDEF RUS}'Insert selected text from the Clipboard at the cursor position'
                 {$ELSE}'Вставить текст из буфера обмена в позицию курсора'{$ENDIF});
  S^.Put(hcClear,{$IFNDEF RUS}'Delete the selected text'
                 {$ELSE}'Удалить помеченный текст'{$ENDIF});
  S^.Put(hcShowClip,{$IFNDEF RUS}'Open the Clipboard window'
                    {$ELSE}'Открыть окно буфера обмена'{$ENDIF});
  S^.Put(hcFile,{$IFNDEF RUS}'File management commands (Open, New, Save, etc.)'
                {$ELSE}'Команды управления файлами (Окрыть, Создать, Сохранить и т.д.)'{$ENDIF});
  S^.Put(hcNew,{$IFNDEF RUS}'Create a new project'
               {$ELSE}'Создать новый проект'{$ENDIF});
  S^.Put(hcOpen,{$IFNDEF RUS}'Locate and open a project'
                {$ELSE}'Окрыть существующий проект'{$ENDIF});
  S^.Put(hcSave,{$IFNDEF RUS}'Save the file in the active Edit window'
                {$ELSE}'Сохранить текущий редактируемый файл'{$ENDIF});
  S^.Put(hcSaveAs, {$IFNDEF RUS}'Save the current file under a different name, directory, or drive'
                   {$ELSE}'Сохранить файл под другим именем, в другом каталоге, диске'{$ENDIF});
  S^.Put(hcSaveAll, {$IFNDEF RUS}'Save all modified files'
                    {$ELSE}'Сохранить все изменённые файлы'{$ENDIF});
  S^.Put(hcChangeDir, {$IFNDEF RUS}'Choose a new default directory'
                      {$ELSE}'Выбрать новуй каталог по умолчанию'{$ENDIF});

  S^.Put(hcPrintFile, {$IFNDEF RUS}'Print the contents of the active Edit window'
                      {$ELSE}'Печать содержимого текущего окна'{$ENDIF});
  S^.Put(hcDosShell, {$IFNDEF RUS}'Temporarily exit to DOS'
                     {$ELSE}'Впеменный выход в DOS'{$ENDIF});
  S^.Put(hcExit, {$IFNDEF RUS}'Exit ResMaker '
                 {$ELSE}'Выход из ResMaker '{$ENDIF}+FloatToStr(VerNum)+'.');
  S^.Put(hcEdit, {$IFNDEF RUS}'Cut-and-paste editing commands'
                 {$ELSE}'Команды копирования и вставки'{$ENDIF});
  S^.Put(hcSearch, {$IFNDEF RUS}'Text and error search commands'
                   {$ELSE}'Команды поиска текста, компонент и ошибок'{$ENDIF});
  S^.Put(hcFind, {$IFNDEF RUS}'Search for text'
                 {$ELSE}'Поиск по тексту'{$ENDIF});
  S^.Put(hcReplase, {$IFNDEF RUS}'Search for text and replace it with new text'
                    {$ELSE}'Поиск по тексту и замена найденного фрагмента на новый'{$ENDIF});
  S^.Put(hcSearchAgain, {$IFNDEF RUS}'Repeat the last Find or Replace command'
                        {$ELSE}'Повтор последней команды поиска или замены'{$ENDIF});
  S^.Put(hcGotoLine, {$IFNDEF RUS}'Move the cursor to a specified line number'
                     {$ELSE}'Переместить курсор на указанную строку'{$ENDIF});
  S^.Put(hcFindComponent,{$IFNDEF RUS}'Search component at form'
                    {$ELSE}'Поиск указанного компонента на форме'{$ENDIF});
  S^.Put(hcPreviewReport,'Preview you new report''s');
  S^.Put(hcPrintReport,'Print you report''s');
  S^.Put(hcSaveReport,'Save you report''s to disk file');
  S^.Put(hcDBGridFieldEditor,'DBGrid field''s editor');
  S^.Put(hcDbfSFieldEditor,'DBSourse field''s editor');
  S^.Put(hcDbfSIndexsEditor,'DBSourse index''s editor');
  S^.Put(hcDbfSNewIndexs, 'New DBSourse index');
  S^.Put(hcDBEnginePref, 'Конфигурация системы доступа к базам дынных');
  S^.Put(hcDBUtil,'Утилиты для работы с базами данных');
  S^.Put(hcNewDataBase,'Создать новый файл базы данных');
  S^.Put(hcOpenDataBase,'Открыть файл базы данных');
  S^.Put(hcDBPref, 'Окно конфигурации системы доступа к базам дынных');
  S^.Put(hcMenuExperts, 'Мастер диалогов, отчетов и т.д');
  S^.Put(hcObjectRepository,'Библиотека готовых форм');
  S^.Put(hcAddToRepository,'Добавить в библиотеку готовых форм');
  S^.Put(hcSPuzzle,'Просто головоломка');
  S^.Put(hcSCalendar, 'Календарь на все случаи жизни');
  S^.Put(hcSAsciiTable, 'Таблица сиволов ASCII');
  S^.Put(hcDBWindRecords,'Команды, связанные с перемещением по таблице');
  S^.Put(hcDBWindFirst,'Перейти в начало таблицы');
  S^.Put(hcDBWindPrev,'Перейти на одну запись вверх');
  S^.Put(hcDBWindNext,'Перейти на одну запись вниз');
  S^.Put(hcDBWindLast,'Перейти в конец таблицы');
  S^.Put(hcDBWindDelete,'Удалить текущую запись');
  S^.Put(hcDBWindRecal,'Восcтановить текущую запись');
  S^.Put(hcDBWindSearch,'Команды поиска по таблице');
  S^.Put(hcDBWindFind,'Найти запись');
  S^.Put(hcDBWindSearchAgain,'Продолжить поиск по образцу');
  S^.Put(hcDBWindTools,'Инструменты для обработки таблицы');
  S^.Put(hcDBWindInfoStruc,'Получить информацию о таблице');
  S^.Put(hcDBWindReStruct,'Изменить структуру таблицы');
  S^.Put(hcDBWindCopy,'Скопировать записи по условию');
  S^.Put(hcDBWindPack,'Произвести упаковку таблицы');
  S^.Put(hcDBWindAppend,'Добавить новую запись');
  S^.Put(hcDBWindEdit,'Редактировать текущее значение');
  S^.Put(hcOpenDBox_ITV,'Открыть индексный файл');
  S^.Put(hcOpenDBox_NTX,'Открыть индексный файл стандарта Clipper');
  S^.Put(hcOpenDBox_IND,'Открыть индексный файл');
  S^.Put(hcOpenDBox_NDX,'Открыть индексный файл стандарта DBase');
  S^.Put(hcOpenDBox_IDX,'Открыть индексный файл стандарта FoxPro');
  S^.Put(hcCompDirect, {$IFNDEF RUS}'Display help about the compiler directives'
                       {$ELSE}'Показать помощь о дерективах копилятора'
                       {$ENDIF});
  S^.Put(hcProc_Fun, {$IFNDEF RUS}'Display help about procedures and functions'
                     {$ELSE}'Показать помощь о процедурах и функциях'
                     {$ENDIF});
  S^.Put(hcReservWords,{$IFNDEF RUS}'Display Borland Pascal''s reserved words'
                     {$ELSE}'Показать служебные слова Borland Pascal'
                     {$ENDIF});
  S^.Put(hcStdUnit,'Display help about standard Borland Pascal units');
  S^.Put(hcBPLang,'Display help about the Borland Pascal language');
  S^.Put(hcErrorMessag,'Display help about the error messages');
  S^.Put(hcCreateNewInd,'Задайте параметры для создания индекса');
  S^.Put(hcIndFileNameLine,'Введите имя индексного файла');
  S^.Put(hcIndexExpr,'Введите индексное выражение');
  S^.Put(hcIndUnique,'Определите уникальность индексного выражения');
  S^.Put(hcInfoStruDbf,'Информация о структуре таблицы');
  S^.Put(hcDBWindReIndex,'Проиндексировать таблицу');
  S^.Put(hcProgectMenu,'Команды для управления проектом');
  S^.Put(hcPViewProgect,'Просмотр всего проекта');
  S^.Put(hcPNewElement,'Создать новый элемент на форму');
  S^.Put(hcPCreateForm,'Сгенерировать исходный текст для формы');
  S^.Put(hcPCreateAll,'Сгенерировать все формы');
  S^.Put(hcPTestForm,'Протестировать работу созданной формы');
  S^.Put(hcPRundemoPrg,'Запустить проект в режиме отладки');
  S^.Put(hcPrintManager,'Вызвать диспетчер печати');
  S^.Put(hcOkBtn,'Accept the settings in this dialog box');
  S^.Put(hcCancleBtn,'Close the dialog box without making any changes');
  S^.Put(hcNoBtn,'Do not perform the action');
  S^.Put(hcYesBtn,'Perform the action');
  S^.Put(hcForceFarCalls,'Force all procedures and functions to use far call model');
  S^.Put(hcOverlaysAllowed,'Enable units to be overlaid');
  S^.Put(hcWordAlignData,'Align variables and typed constants on word boundaries');
  S^.Put(hcInstructions286,'Generate 80286 instructions');
  S^.Put(hcSmartCallbacks,'Generate Windows smart callbacks');
  S^.Put(hcWindowsStackFrames,'Generate real-mode Windows stack frames');
  S^.Put(hcRangeChecking,'Generate range-checking code');
  S^.Put(hcStackChecking,'Check for stack overflow on entry to procedures and functions');
  S^.Put(hcI_OChecking,'Generate runtime error if I/O operation fails');
  S^.Put(hcOverflowChecking,'Generate runtime error if arithmetic operations overflow');
  S^.Put(hcStrictVarStrings,'Var string parameter type must be identical to formal parameter type');
  S^.Put(hcComplBoolEval,'Always evaluate all boolean expressions in a statement');
  S^.Put(hcExtendedSyntax,'Enable syntax extensions');
  S^.Put(hcTypedPOperator,'Enable type checking for @ operator');
  S^.Put(hcOpenParameters,'Enable open var arrays and open var strings');
  S^.Put(hcDebugInformation,'Generate information to allow debugging');
  S^.Put(hcLocalSymbols,'Include local symbols in generated debug information');
  S^.Put(hcSymbolInformation,'Include browser symbol information in generated debug information');
  S^.Put(hc_8087_80287,'Generate 8087 code for use with math coprocessor or emulator');
  S^.Put(hcEmulation,'Use 8087 emulator if math coprocessor is not present');
  S^.Put(hcConditDefine,'Define conditional compilation symbols');
  S^.Put(hcHelpBtn,'View a help screen about this dialog box');
  S^.Put(hcEnterNewLnNum,'Move cursor to specified line number in file');
  S^.Put(hcEditorOptDialogBox,'Syntax highlights the files matching the given file masks');
  S^.Put(hcCreateBackupFile,'Create a backup (.BAK) file whenever you save');
  S^.Put(hcInsertMode,'Editor uses insert mode by default');
  S^.Put(hcAutoIndentMode,'Turn auto-indentation on by default');
  S^.Put(hcUseTabCharacter,'Insert actual tab characters into file');
  S^.Put(hcOptimalFill,'Optimally replace consecutive spaces with tabs');
  S^.Put(hcBackspaceUnindents,'Backspace uninidents based on previous starting columns');
  S^.Put(hcCursorThroughTabs,'Allow cursor to move through tabs one column at a time');
  S^.Put(hcGroupedUndo,'Undo/Redo edits as words or full blocks');
  S^.Put(hcPersistentBlocks,'Selected block remains highlighted in cursor move');
  S^.Put(hcOverwriteBlocks,'Selected block is replaced by new insertions');
  S^.Put(hcSyntaxHighlight,'Syntax highlighting is enabled');
  S^.Put(hcBlockinsertcursor,'Block cursor on insert mode');
  S^.Put(hcCurTextSerchRepl,'Search/Replace text defaults to word at the cursor location');
  RezFile.Put(S, 'HelpStrings');*)
{  RezFile.Put(S, 'Strings');}
  Dispose(S, Done);
end;

procedure CreateMenu;
var
  R: TRect;
  P: PView;
begin
  R.Assign(0, 0, 80, 1);
  P := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu({$IFDEF RUS}'~Ф~айл'{$ELSE}'~F~ile'{$ENDIF}, hcFile, NewMenu(
      NewItem({$IFDEF RUS}'~Н~овый проект'{$ELSE}'~N~ew Project'{$ENDIF}, '', kbNoKey, cmNewRes, hcNew,
      NewItem({$IFDEF RUS}'~О~ткрыть проект'{$ELSE}'~O~pen Project...'{$ENDIF}, '', kbShiftF3, cmOpenRes, hcNoContext,
      NewItem({$IFDEF RUS}'~С~охранить проект'{$ELSE}'~S~ave Project...'{$ENDIF}, '', kbNoKey, cmSaveAll, hcNoContext,
      NewItem({$IFDEF RUS}'~З~акрыть проект'{$ELSE}'C~l~ose Project'{$ENDIF}, '', kbNoKey, cmCloseRes, hcNoContext,
      NewLine(
      NewSubMenu({$IFDEF RUS}'Созда~т~ь...'{$ELSE}'Ne~w~...'{$ENDIF}, hcFile, NewMenu(
        NewItem({$IFDEF RUS}'Новая ~ф~орма'{$ELSE}'New ~f~orm'{$ENDIF}, 'F7', kbF7, cmNew, hcNoContext,
        NewItem({$IFDEF RUS}'Новый ~м~одуль'{$ELSE}'New ~u~nit'{$ENDIF}, '', kbNoKey, cmNewUnit, hcNoContext,
        NewItem({$IFDEF RUS}'Новый ~т~екстовый файл'{$ELSE}'New ~t~ext file'{$ENDIF}, '', kbNoKey, cmNewTextFile, hcNoContext,
        NewItem({$IFDEF RUS}'Новое ~г~лавное меню'{$ELSE}'New ~m~ain menu'{$ENDIF}, '', kbNoKey, cmNewTextFile, hcNoContext,
        NewItem({$IFDEF RUS}'Новый модуль ~д~анных'
                {$ELSE}'New ~d~ata module...'{$ENDIF}, '', kbNoKey, cmDBConstructor, hcNoContext,
        nil)))))),
      NewSubMenu({$IFDEF RUS}'~О~крыть...'{$ELSE}'~R~eopen...'{$ENDIF}, hcFile, NewMenu(
        NewItem({$IFDEF RUS}'Новая ~ф~орма'{$ELSE}'New ~f~orm'{$ENDIF}, 'F7', kbF7, cmNew, hcNoContext,
        nil)),
      NewLine(
      NewItem({$IFDEF RUS}'Открыть фа~й~л'{$ELSE}'O~p~en file...'{$ENDIF}, 'F3', kbF3, cmOpenFile, hcOpen,
      NewItem({$IFDEF RUS}'Открыть фор~м~у'{$ELSE}'Open for~m~...'{$ENDIF}, '', kbNoKey, cmOpen, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'Сохранить к~а~к'{$ELSE}'Save ~a~s...'{$ENDIF}, '', kbNoKey, cmSaveAs, hcSaveAs,
      NewItem({$IFDEF RUS}'Сохранить ~ф~орму'{$ELSE}'Save ~f~orm'{$ENDIF}, '', kbNoKey, cmSaveForm, hcNoContext,
      NewItem({$IFDEF RUS}'Сохранить вс~ё~'{$ELSE}'Save a~l~l'{$ENDIF}, '', kbNoKey, cmSaveAll, hcSaveAll,
      NewLine(
      NewItem({$IFDEF RUS}'~П~ечать...'{$ELSE}'~P~rint...'{$ENDIF}, '', kbNoKey, cmPrintFile, hcPrintFile,
      NewItem({$IFDEF RUS}'Сменить ~к~аталог'{$ELSE}'~C~hange dir...'{$ENDIF}, '', kbNoKey, cmChangeDir, hcChangeDir,
      NewItem({$IFDEF RUS}'Вызов ~Д~ОС'{$ELSE}'~D~OS shell'{$ENDIF}, '', kbNoKey, cmShellDos, hcDosShell,
      NewItem({$IFDEF RUS}'Вы~х~од'{$ELSE}'E~x~it'{$ENDIF}, 'Alt+X', kbAltX, cmQuit, hcExit,
      nil)))))))))))))))))))),
    NewSubMenu({$IFDEF RUS}'~Р~едактор'{$ELSE}'~E~dit'{$ENDIF}, hcEdit, NewMenu(
      NewItem({$IFDEF RUS}'~О~тмена'{$ELSE}'~U~ndo'{$ENDIF}, '', kbAltBack, cmUndo, hcUndo,
      NewLine(
      NewItem({$IFDEF RUS}'~В~ырезать'{$ELSE}'Cu~t~'{$ENDIF}, 'Shift+Del', kbShiftDel, cmCut, hcCut,
      NewItem({$IFDEF RUS}'~К~опировать'{$ELSE}'~C~opy'{$ENDIF}, 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
      NewItem({$IFDEF RUS}'В~с~тавить'{$ELSE}'~P~aste'{$ENDIF}, 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
      NewItem({$IFDEF RUS}'~О~чистить'{$ELSE}'C~l~ear'{$ENDIF}, 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
      NewLine(
      NewItem({$IFDEF RUS}'~Б~уфер обмена'{$ELSE}'~S~how clipboard'{$ENDIF}, '', kbNoKey, cmShowClip, hcShowClip,
      NewLine(
      NewItem({$IFDEF RUS}'~У~далить элемент'{$ELSE}'~D~elete view''s '{$ENDIF}, '', kbNoKey, cmDeleteElem, hcNoContext,
      nil))))))))))),
    NewSubMenu({$IFDEF RUS}'~П~оиск'{$ELSE}'~S~earch'{$ENDIF}, hcSearch, NewMenu(
      NewItem({$IFDEF RUS}'~И~скать...'{$ELSE}'~F~ind...'{$ENDIF}, '', kbNoKey, cmFind, hcFind,
      NewItem({$IFDEF RUS}'~З~аменить...'{$ELSE}'~R~eplace...'{$ENDIF}, '', kbNoKey, cmReplace, hcReplase,
      NewItem({$IFDEF RUS}'Искать ~д~алее'{$ELSE}'~S~earch again'{$ENDIF}, '', kbNoKey, cmSearchAgain, hcSearchAgain,
      NewLine(
      NewItem({$IFDEF RUS}'Идти к ~с~троке...'{$ELSE}'~G~o to line number...'{$ENDIF}, '', kbNoKey, cmGotoLine, hcGotoLine,
      NewLine(
      NewItem({$IFDEF RUS}'Список ~э~лементов'{$ELSE}'Find ~c~omponent...'
              {$ENDIF}, 'Shift+F2', kbShiftF2, cmFindElement, hcFindComponent,
      nil)))))))),
    NewSubMenu({$IFDEF RUS}'Про~е~кт'{$ELSE}'~P~rogect'{$ENDIF}, hcProgectMenu, NewMenu(
      NewItem({$IFDEF RUS}'~П~росмотр проекта'{$ELSE}'~V~iew Project'{$ENDIF}, '', kbNoKey, cmViewProject, hcPViewProgect,
      NewLine(
      NewItem({$IFDEF RUS}'Новый ~э~лемент...'{$ELSE}'~N~ew element...'{$ENDIF}, 'F4', kbF4, cmNewElement, hcPNewElement,
      NewLine(
      NewItem({$IFDEF RUS}'~С~оздать форму'{$ELSE}'~C~reate form'{$ENDIF}, '', kbNoKey, cmCreateForm, hcPCreateForm,
      NewItem({$IFDEF RUS}'~В~ виде текста'{$ELSE}'View ~a~s text'{$ENDIF}, '', kbNoKey, cmViewAsText, hcPCreateForm,
      NewItem({$IFDEF RUS}'Соз~д~ать всё'{$ELSE}'Create a~l~l'{$ENDIF}, '', kbNoKey, cmCreateAll, hcPCreateAll,
      NewLine(
      NewItem({$IFDEF RUS}'~Т~ест формы'{$ELSE}'Test ~f~orm'{$ENDIF}, 'Ctrl+F9', kbCtrlF9, cmTestForm, hcPTestForm,
      NewItem({$IFDEF RUS}''{$ELSE}'~R~un Project demo'{$ENDIF}, '', kbNoKey, cmRunDemoPrg, hcPRundemoPrg,
      NewLine(
      NewItem({$IFDEF RUS}''{$ELSE}'~B~uild help file'{$ENDIF}, 'Shift+F10', kbShiftF10, cmBuildHlpFile, hcPRundemoPrg,
      nil))))))))))))),
    NewSubMenu({$IFDEF RUS}'~О~тладка'{$ELSE}'~D~ebug'{$ENDIF}, hcNoContext, NewMenu(
      NewItem({$IFDEF RUS}'Дерево объектов'{$ELSE}'~O~bjects tree global'{$ENDIF}, '', kbNoKey, cmNodeObjects, hcNoContext,
      NewItem({$IFDEF RUS}'Окно свойств'{$ELSE}'~P~roperty list'{$ENDIF}, '', kbNoKey, cmPropertyList, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'Список индексных страниц'
              {$ELSE}'~I~ndex page stack...'{$ENDIF}, '', kbNoKey, cmIndexPageStack, hcNoContext,
      NewItem({$IFDEF RUS}'Список ресурсов'{$ELSE}'~L~ist resurses...'{$ENDIF}, '', kbNoKey, cmListResurse, hcNoContext,
      NewItem({$IFDEF RUS}'Добавить модуль'{$ELSE}'~A~dd units'{$ENDIF}, '', kbNoKey, cmTpuWindow, hcNoContext,
      NewItem({$IFDEF RUS}'Исходный текст'{$ELSE}'~R~econstruct interface'{$ENDIF}, '', kbNoKey, cmInterface, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Ко~нтекстное меню'{$ELSE}'L~o~cal memu...'{$ENDIF}, 'Alt+F10', kbAltF10, cmLocalMenu, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~В~ывод'{$ELSE}'~O~utput'{$ENDIF}, '', kbNoKey, cmOutput, hcNoContext,
      NewItem({$IFDEF RUS}'Экран ~п~ользователя'{$ELSE}'~U~ser screen'{$ENDIF}, 'Alt+F5', kbAltF5, cmUserScreen, hcNoContext,
      nil))))))))))))),
    NewSubMenu({$IFDEF RUS}'~И~нстр.'{$ELSE}'~T~ools'{$ENDIF}, hcNoContext, NewMenu(
      NewItem({$IFDEF RUS}'~Р~епозитарий'{$ELSE}'~R~epository'{$ENDIF}, '', kbNoKey, cmObjectRepository, hcObjectRepository,
      NewItem({$IFDEF RUS}'~Д~обавить в репозитарий'
              {$ELSE}'~A~dd to Repository'{$ENDIF}, '', kbNoKey, cmAddToRepository, hcAddToRepository,
      NewLine(
      NewSubMenu({$IFDEF RUS}'~Б~азы данных'{$ELSE}'~D~atabase'{$ENDIF}, hcDBUtil, NewMenu(
        NewItem({$IFDEF RUS}'~Н~овая база'{$ELSE}'~N~ew database...'{$ENDIF}, '', kbNoKey, cmNewData, hcNewDataBase,
        NewItem({$IFDEF RUS}'~О~ткрыть базу'{$ELSE}'~O~pen database...'{$ENDIF}, '', kbNoKey, cmOpenData, hcOpenDataBase,
        NewLine(
        NewItem({$IFDEF RUS}'~Н~астройки'{$ELSE}'~P~references...'{$ENDIF}, '', kbNoKey, cmDBPref, hcDBPref,
        NewItem({$IFDEF RUS}'~Р~едактор псевдонимов'{$ELSE}'~A~lias editor...'{$ENDIF}, '', kbNoKey, cmAliasEditor, hcDBPref,
        nil)))))),
      NewSubMenu({$IFDEF RUS}'~М~астер'{$ELSE}'~E~xperts'{$ENDIF}, hcMenuExperts, NewMenu(
        NewItem({$IFDEF RUS}'Мастер ~о~тчётов'{$ELSE}'~R~eport expert...'{$ENDIF}, '', kbNoKey, cmReportExpert, hcNoContext,
        NewItem({$IFDEF RUS}'Мастер ~д~иалогов'{$ELSE}'~D~ialog wizard...'{$ENDIF}, '', kbNoKey, cmDialogExpert, hcNoContext,
        NewItem({$IFDEF RUS}'Форма ~с~ данными'
                {$ELSE}'Data~b~ase form...'{$ENDIF}, '', kbNoKey, cmDataBaseFormExpert, hcNoContext,
        NewItem({$IFDEF RUS}'Мастер ~п~риложений'
                {$ELSE}'~A~pplication wizard...'{$ENDIF}, '', kbNoKey, cmAppExpert, hcNoContext,
        nil))))),
      NewLine(
      NewItem({$IFDEF RUS}'Диспетчер ~п~ечати'{$ELSE}'~P~inter manager'{$ENDIF}, '', kbNoKey, cmPrintManager, hcPrintManager,
      NewItem({$IFDEF RUS}'~Г~оловоломка'{$ELSE}'~P~uzzle'{$ENDIF}, '', kbNoKey, cmPuzzle, hcSPuzzle,
      NewItem({$IFDEF RUS}'~К~алендарь'{$ELSE}'Ca~l~endar'{$ENDIF}, '', kbNoKey, cmCalendar, hcSCalendar,
      NewItem({$IFDEF RUS}'~Т~аблица Ascii'{$ELSE}'Ascii ~t~able'{$ENDIF}, '', kbNoKey, cmAsciiTab, hcSAsciiTable,
      NewItem({$IFDEF RUS}'~К~алькулятор'{$ELSE}'~C~alculator'{$ENDIF}, '', kbNoKey, cmCalculator, hcNoContext,
      nil)))))))))))),
    NewSubMenu({$IFDEF RUS}'Оп~ц~ии'{$ELSE}'~O~ptions'{$ENDIF}, hcNoContext, NewMenu(
      NewItem({$IFDEF RUS}'~Б~уффер'{$ELSE}'~B~uffer'{$ENDIF}, 'Disk', kbNoKey, cmBuffer, hcNoContext,
      NewItem({$IFDEF RUS}'~Г~енератор кода'{$ELSE}'~G~enerator'{$ENDIF}, '', kbNoKey, cmGNOpt, hcNoContext,
      NewItem({$IFDEF RUS}'~К~омпилятор'{$ELSE}'~C~ompiler...'{$ENDIF}, '', kbNoKey, cmCompOpt, hcNoContext,
      NewItem({$IFDEF RUS}'~П~роект'{$ELSE}'~P~rogect...'{$ENDIF}, '', kbNoKey, cmProgectOpt, hcNoContext,
      NewItem({$IFDEF RUS}'К~а~талоги'{$ELSE}'~D~irectories...'{$ENDIF}, '', kbNoKey, cmDir, hcNoContext,
      NewItem({$IFDEF RUS}'~И~нструменты'{$ELSE}'~T~ools...'{$ENDIF}, '', kbNoKey, cmTools, hcNoContext,
      NewLine(
      NewSubMenu({$IFDEF RUS}'~О~кружение...'{$ELSE}'~E~nvironment...'{$ENDIF}, hcNoContext, NewMenu(
         NewItem({$IFDEF RUS}'~Н~астройки...'{$ELSE}'~P~references...'{$ENDIF}, '', kbNoKey, cmPreferences, hcNoContext,
         NewItem({$IFDEF RUS}'~Р~едактор...'{$ELSE}'~E~ditors...'{$ENDIF}, '', kbNoKey, cmEditorOpt, hcNoContext,
         NewItem({$IFDEF RUS}'~М~ышь...'{$ELSE}'~M~ouse...'{$ENDIF}, '', kbNoKey, cmMouse, hcNoContext,
         NewItem({$IFDEF RUS}'~З~агрузка...'{$ELSE}'~S~tartup...'{$ENDIF}, '', kbNoKey, cmStartup, hcNoContext,
         NewLine(
         NewItem({$IFDEF RUS}'~Ц~вета...'{$ELSE}'~C~olor...'{$ENDIF}, '', kbNoKey, cmColors, hcNoContext,
         nil))))))),
      NewLine(
      NewItem({$IFDEF RUS}'О~т~крыть'{$ELSE}'~O~pen'{$ENDIF}, '', kbNoKey, cmOpenDskFile, hcNoContext,
      NewItem({$IFDEF RUS}'~С~охранить'{$ELSE}'~S~ave'{$ENDIF}, 'RES2.DSK', kbNoKey, cmSaveDskFile, hcNoContext,
      NewItem({$IFDEF RUS}'Со~х~ранить как...'{$ELSE}'Save ~a~s'{$ENDIF}, '', kbNoKey, cmSaveAsDskFile, hcNoContext,
      nil))))))))))))),
    NewSubMenu({$IFDEF RUS}'Окн~а~'{$ELSE}'~W~indow'{$ENDIF}, hcWindows, NewMenu(
      NewItem({$IFDEF RUS}'~Ч~ерепицей'{$ELSE}'~T~ile'{$ENDIF}, '', kbNoKey, cmTile, hcTile,
      NewItem({$IFDEF RUS}'~К~аскадом'{$ELSE}'C~a~scade'{$ENDIF}, '', kbNoKey, cmCascade, hcCascade,
      NewItem({$IFDEF RUS}'Закрыть ~в~сё'{$ELSE}'Cl~o~se all'{$ENDIF}, '', kbNoKey, cmCloseAll, hcCloseAll,
      NewLine(
      NewItem({$IFDEF RUS}'~Р~азмер/Перемещение'{$ELSE}'~S~ize/Move'{$ENDIF},'Ctrl+F5', kbCtrlF5, cmResize, hcResize,
      NewItem({$IFDEF RUS}'~М~асштаб'{$ELSE}'~Z~oom'{$ENDIF}, 'F5', kbF5, cmZoom, hcZoom,
      NewItem({$IFDEF RUS}'Сле~д~ующее'{$ELSE}'~N~ext'{$ENDIF}, 'F6', kbF6, cmNext, hcNext,
      NewItem({$IFDEF RUS}'~П~ревыдущее'{$ELSE}'~P~revious'{$ENDIF}, 'Shift+F6', kbShiftF6, cmPrev, hcPrev,
      NewItem({$IFDEF RUS}'~З~акрыть'{$ELSE}'~C~lose'{$ENDIF}, 'Alt+F3', kbAltF3, cmClose, hcClose,
      NewLine(
      NewItem({$IFDEF RUS}'~С~писок'{$ELSE}'~L~ist'{$ENDIF}, 'Alt+0', kbAlt0, cmListWindow, hcMWindowList,
      nil)))))))))))),
    NewSubMenu({$IFDEF RUS}'~П~омощь'{$ELSE}'~H~elp'{$ENDIF}, hcNoContext, NewMenu(
      NewItem({$IFDEF RUS}'~К~онтекстная'{$ELSE}'~C~ontents'{$ENDIF}, 'F1', kbF1, cmHelp, hcHelpOnHelp,
      NewItem({$IFDEF RUS}'О~г~лавление'{$ELSE}'~I~ndex'{$ENDIF},'Shift+F1', kbShiftF1, cmHelpIndex, hcNoContext,
      NewItem({$IFDEF RUS}'По~и~ск раздела'{$ELSE}'~T~opic search'{$ENDIF},'Ctrl+F1', kbCtrlF1, cmTopicSearch, hcNoContext,
      NewItem({$IFDEF RUS}'Пр~е~выдущий раздел'{$ELSE}'~P~revious topic'{$ENDIF},'Alt+F1', kbAltF1, cmPrevTopic, hcNoContext,
      NewItem({$IFDEF RUS}'И~с~пользование помощи'{$ELSE}'Using ~h~elp'{$ENDIF},'',kbNoKey, cmUsinghelp, hcNoContext,
      NewItem({$IFDEF RUS}'~Ф~айлы...'{$ELSE}'~F~iles...'{$ENDIF},'',kbNoKey, cmHelpFiles, hcNoContext,
      NewLine(
      NewItem({$IFDEF RUS}'~Д~ерективы компилятора'
              {$ELSE}'Compiler ~d~irectives'{$ENDIF}, '', kbNoKey, cmCompDirect, hcCompDirect,
      NewItem({$IFDEF RUS}'~П~роцедуры и функции'
              {$ELSE}'Pr~o~cedures and functions'{$ENDIF}, '', kbNoKey, cmProc_Fun, hcProc_Fun,
      NewItem({$IFDEF RUS}'С~л~ужебные слова'{$ELSE}'~R~eserved words'{$ENDIF}, '', kbNoKey, cmReservWords, hcReservWords,
      NewItem({$IFDEF RUS}'Стандартные ~м~одули'{$ELSE}'Standard ~u~nits'{$ENDIF}, '', kbNoKey, cmStdUnits, hcStdUnit,
      NewItem({$IFDEF RUS}'~Я~зык Borland Pascal'{$ELSE}'Borland Pascal ~L~anguage'{$ENDIF}, '', kbNoKey, cmBPLang, hcBPLang,
      NewItem({$IFDEF RUS}'Сообщения об о~ш~ибках'{$ELSE}'~E~rror messages'{$ENDIF}, '', kbNoKey, cmErrorMessag, hcErrorMessag,
      NewLine(
      NewItem({$IFDEF RUS}'Об ~а~вторе'{$ELSE}'~A~bout...'{$ENDIF},'', kbNoKey, cmAbout, hcNoContext,
      NewItem({$IFDEF RUS}'~И~нформация'{$ELSE}'~I~nformation...'{$ENDIF},'', kbNoKey, cmInfo, hcNoContext,
      nil))))))))))))))))),
      nil))))))))))));

  ResourseFile.Put(P, 'MenuBar');
  Dispose(P, Done);
end;

procedure CreateStatusLine;
var
  R: TRect;
  P: PView;
begin
  R.Assign(0, 24, 80, 25);
//  P := New(PHCStatusLine, Init(R,
  P := New(PStatusLine, Init(R,
    NewStatusDef(hcNoContext, hcNoContext,
      NewStatusKey('~Alt+X~ '+{$IFDEF RUS}'Вы~х~.'{$ELSE}'E~x~it'{$ENDIF}, kbAltX, cmQuit,
{      NewStatusKey('', kbAltX, cmQuit,}
      NewStatusKey('~F1~ '+{$IFDEF RUS}'Помощь'{$ELSE}'Help'{$ENDIF}, kbF1, cmHelp,
      NewStatusKey('~F3~ '+{$IFDEF RUS}'Открыть'{$ELSE}'Open'{$ENDIF}, kbF3, cmOpenFile,
      NewStatusKey('~Alt-F3~ '+{$IFDEF RUS}'Закр.'{$ELSE}'Close'{$ENDIF}, kbAltF3, cmClose,
      NewStatusKey('~F7~ '+{$IFDEF RUS}'Форма'{$ELSE}'New form'{$ENDIF}, kbF7, cmNew,
      NewStatusKey('~F4~ '+{$IFDEF RUS}'Элемент'{$ELSE}'Element'{$ENDIF}, kbF4, cmNewElement,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('', kbF5, cmZoom,
      nil))))))))),
    NewStatusDef(hcDragging, hcDragging,
      NewStatusKey({$IFDEF RUS}'~'#$18#$19#$1A#$1B'~ Перемещение  ~Shift+'#$18#$19#$1A#$1B+
           '~Размер  ~'#$11#$C4#$D9'~ Готово  ~ESC~ Отмена'
                   {$ELSE}'~'#$18#$19#$1A#$1B'~ Move  ~Shift+'#$18#$19#$1A#$1B+
           '~ Resize  ~'#$11#$C4#$D9'~ Done  ~ESC~ Cancel'{$ENDIF}, kbNoKey, cmError,
      nil),
    NewStatusDef(hcEditWindow, hcEditWindow,
      NewStatusKey('~Alt+X~ '+{$IFDEF RUS}'Вы~х~од'{$ELSE}'E~x~it'{$ENDIF}, kbAltX, cmQuit,
{      NewStatusKey('', kbAltX, cmQuit,}
      NewStatusKey('~F1~ '+{$IFDEF RUS}'Помощь'{$ELSE}'Help'{$ENDIF}, kbF1, cmHelp,
      NewStatusKey('~F2~ '+{$IFDEF RUS}'Сохранить'{$ELSE}'Save'{$ENDIF}, kbF2, cmSave,
      NewStatusKey('~F3~ '+{$IFDEF RUS}'Открыть'{$ELSE}'Open'{$ENDIF}, kbF3, cmOpenFile,
      NewStatusKey('~Alt-F3~ '+{$IFDEF RUS}'Закр.'{$ELSE}'Close'{$ENDIF}, kbAltF3, cmClose,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('', kbF5, cmZoom,
      NewStatusKey('', kbAltX, cmQuit,
      nil))))))))),
    NewStatusDef(hcEditWindow+1, hccmXXXX-1,
      NewStatusKey('~F1~ '+{$IFDEF RUS}'Помощь'{$ELSE}'Help'{$ENDIF}, kbF1, cmHelp,
      NewStatusKey('', kbAltX, cmQuit,
      NewStatusKey('', kbF3, cmOpenFile,
      NewStatusKey('', kbAltF3, cmClose,
      NewStatusKey('', kbF7, cmNew,
      NewStatusKey('', kbF4, cmNewElement,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('', kbF5, cmZoom,
      nil))))))))),
    NewStatusDef(hccmXXXX, $F000-1,
      NewStatusKey('~Alt+X~ '+{$IFDEF RUS}'Вы~х~од'{$ELSE}'E~x~it'{$ENDIF}, kbAltX, cmQuit,
{      NewStatusKey('', kbAltX, cmQuit,}
      NewStatusKey('~F1~ '+{$IFDEF RUS}'Помощь'{$ELSE}'Help'{$ENDIF}, kbF1, cmHelp,
      NewStatusKey('~F3~ '+{$IFDEF RUS}'Открыть'{$ELSE}'Open'{$ENDIF}, kbF3, cmOpenFile,
      NewStatusKey('~Alt-F3~ '+{$IFDEF RUS}'Закр.'{$ELSE}'Close'{$ENDIF}, kbAltF3, cmClose,
      NewStatusKey('~F7~ '+{$IFDEF RUS}'Форма'{$ELSE}'New form'{$ENDIF}, kbF7, cmNew,
      NewStatusKey('~F4~ '+{$IFDEF RUS}'Элемент'{$ELSE}'Element'{$ENDIF}, kbF4, cmNewElement,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('', kbF5, cmZoom,
      nil))))))))),
    NewStatusDef($F000,$FFFF,
      NewStatusKey('~F1~ '+{$IFDEF RUS}'Помощь'{$ELSE}'Help'{$ENDIF}, kbF1, cmHelp,
      NewStatusKey('', kbAltX, cmQuit,
      NewStatusKey('', kbF3, cmOpenFile,
      NewStatusKey('', kbAltF3, cmClose,
      NewStatusKey('', kbF7, cmNew,
      NewStatusKey('', kbF4, cmNewElement,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('', kbF5, cmZoom,
      nil))))))))),
    nil))))))));
  ResourseFile.Put(P, 'StatusLine');
  Dispose(P, Done);
end;

end.
