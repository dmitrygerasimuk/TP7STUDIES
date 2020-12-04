{$O+,F-}
unit NodeObj;
interface
uses Views;

function CreateObjectWin:PWindow;
implementation
uses OutLine, Objects;

function CreteViewsLiv(Next:PNode):PNode;
begin
  CreteViewsLiv:=
           NewNode('TView',
                NewNode('TFrame', nil,
                NewNode('TTable', nil,
                NewNode('TReport', nil,
                NewNode('TCalcDisplay', nil,
                NewNode('TCalendarView', nil,
                NewNode('THeapView', nil,
                NewNode('TClockView', nil,
                NewNode('TPuzzleView', nil,
                NewNode('TFileInfoPane', nil,
                NewNode('TOutlineViewer',
                   NewNode('TOutline', nil,
                   nil),
                NewNode('TIndicator', nil,
                NewNode('TEditor',
                   NewNode('TFileEditor',nil,
                   NewNode('TMemo',nil,
                   nil)),
                NewNode('TDrawGrid',
                   NewNode('TStringGrid',nil,
                   nil),
                NewNode('TScroller',
                   NewNode('TFileViewer', nil,
                   NewNode('THelpViewer', nil,
                   NewNode('TTextDevice',
                      NewNode('TTerminal', nil,
                      nil),
                   nil))),
                NewNode('TScrollBar', nil,
                NewNode('TStatusLine', nil,
                NewNode('TGroup',
                   NewNode('TWindow',
                      NewNode('TDialog',
                         NewNode('TCalculator',nil,
                         NewNode('TChDirDialog',nil,
                         NewNode('TMouseDialog',nil,
                         NewNode('TFileDialog',nil,
                         nil)))),
                      NewNode('THistoryWindow',nil,
                      NewNode('TLockUpBox',nil,
                      NewNode('TTextWindow',nil,
                      NewNode('TEditWindow',nil,
                      NewNode('TASCIIChart',nil,
                      NewNode('TCalendarWindow',nil,
                      NewNode('THelpWindow',nil,
                      NewNode('TPuzzleWindow',nil,
                      nil))))))))),
                   NewNode('TDeskTop', nil,
                   NewNode('TProgram',
                      NewNode('TApplication',nil,
                      nil),
                   nil))),
                NewNode('TBackGround', nil,
                NewNode('TButton', nil,
                NewNode('TCluster',
                   NewNode('TRadioButtons', nil,
                   NewNode('TCheckBoxes', nil,
                   NewNode('TMultiCheckBoxes', nil,
                   nil))),
                NewNode('TInputLine',
                   NewNode('TInputLineUC', nil,
                   NewNode('TInputLineLC', nil,
                   NewNode('TInputLinePS', nil,
                   NewNode('TRangeILine', nil,
                   NewNode('TFilterInput', nil,
                   NewNode('TFileInputLine', nil,
                   NewNode('TLockUpInputLine', nil,
                   NewNode('TDBEdit', nil,
                   nil)))))))),
                NewNode('THistory', nil,
                NewNode('TColorText', nil,
                NewNode('TStaticText',
                   NewNode('TClickTester', nil,
                   NewNode('TLabel', nil,
                   NewNode('TParamText', nil,
                   NewNode('TDBText', nil,
                   nil)))),
                NewNode('TMenuView',
                   NewNode('TMenuBar',nil,
                   NewNode('TMenuBox',nil,
                   nil)),
                NewNode('TDBGrid', nil,
                NewNode('TListViewer',
                   NewNode('TListBox',
                      NewNode('TSortedListBox',
                         NewNode('TFileList', nil,
                         nil),
                      NewNode('TDirListBox', nil,
                      NewNode('TMultiSelBox', nil,
                      NewNode('TOkListBox', nil,
                      nil)))),
                   NewNode('THistoryViewer', nil,
                   NewNode('TElementGroupList', nil,
                   NewNode('TElementItemList', nil,
                   NewNode('TDBLockUp', nil,
                   nil))))),
                NewNode('TDataSourseObj',
                   NewNode('TDbfSourse', nil,
                   nil),
                nil)))))))))))))))))))))))))))),
             Next);
end;

function CreateObjectWin:PWindow;
var
  W:PWindow;
  HScrollBar, VScrollBar: PScrollBar;
  R:TRect;
begin
  R.Assign( 30, 0, 80, 15);
  W:=New(PWindow, Init(R, 'Иерархии...', wnNoNumber));
  with W^ do
  begin
    Palette:=wpCyanWindow;
    R.Assign( Size.X-1, Origin.Y + 1, Size.X, Size.Y-1 );
    VScrollBar := StandardScrollBar( sbHorizontal);
    Insert(VScrollBar);
    HScrollBar := StandardScrollBar( sbVertical);
    Insert(HScrollBar);
    GetExtent(R);
    R.Grow(-1, -1);
    Insert(New(POutLine, Init(R, VScrollBar, HScrollBar,
            NewNode('TObject',
               CreteViewsLiv(
               NewNode('TCollection',
                  NewNode('TDirCollection',nil,
                  NewNode('TLineCollection',nil,
                  NewNode('TSortedCollection',
                     NewNode('TStringCollection',
                        NewNode('TResourceCollection',nil,
                        nil),
                     NewNode('TStrCollection',nil,
                     NewNode('TFileCollection',nil,
                     nil))),
                  nil))),
               NewNode('TResourceFile',nil,
               NewNode('TStringList', nil,
               NewNode('TStrListMaker', nil,
               NewNode('TStream',
                  NewNode('TMemoryStream', nil,
                  NewNode('TEmsStream', nil,
                  NewNode('TDosStream',
                     NewNode('TBufStream', nil,
                     nil),
                  nil))),
               NewNode('TDBFObject',
                  NewNode('TDbf',nil,
                  nil),
               NewNode('TIndexObject',
                  NewNode('TNTX',nil,
                  NewNode('TNDX',nil,
                  nil)),
               NewNode('TPageStackManadger',nil,
               NewNode('TValidator',
                  NewNode('TPXPictureValidator',nil,
                  NewNode('TFilterValidator',
                     NewNode('TRangeValidator',nil,
                     nil),
                  NewNode('TLookupValidator',
                     NewNode('TStringLookupValidator',nil,
                     nil),
                  nil))),
               nil)))))))))),
            nil))));
  end;
  CreateObjectWin:=W;
end;

end.
