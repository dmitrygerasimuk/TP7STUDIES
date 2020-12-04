program DpmiDemo;
 
uses DPMI;
var
  rmSeg: Word;
  LinAddr: Word;
  rmRegs: TRmRegs;
  i: DWord;
begin
  // �뤥���� 256 ���� � ������ ����� � ��࠭��� ����
  // real mode ᥣ����
  rmSeg := DOSMemoryAlloc(256);
  if rmSeg = 0 then
  begin
   Writeln('�������筮 ������ �����!');
   Halt(0);
  end;
  // ������� � ���饭��� ०��� ���� real-mode ᥣ����
  LinAddr := DWord(rmSeg) * 16;
  // ������ �������� rmRegs (��������� �� ��ﬨ)
  ClearRmRegs(rmRegs);
  // �㭪�� VBE 4F00h - GetVESAInfo
  rmRegs.AX := $4F00;
  // ������ � Real mode ॣ���� ES ���祭�� ᥣ����
  // �뤥������� ����� �����
  rmRegs.ES := rmSeg;
  // �맢��� �㭪�� VBE 4F00h, ���� �������� �뤥����� ����
  // ���ଠ樥� � VESA VBE
  RealModeInt($10, rmRegs);
  Write('�����䨪���: ');
  // ������ ���� 4 ���� �� ����� � ������ ����� �
  // �뢥�� �� �� �࠭. �᫨ ��� ��������� �����ন����
  // VESA VBE, �� 㢨��� ᫮�� 'VESA'
  for i := LinAddr to LinAddr + 3 do Write(char(Pointer(i)^));
  // Free allocated memory block
  DOSMemoryFree(rmSeg);
end.