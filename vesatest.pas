program DpmiDemo;
 
uses DPMI;
var
  rmSeg: Word;
  LinAddr: Word;
  rmRegs: TRmRegs;
  i: DWord;
begin
  // Выделить 256 байт в нижней памяти и сохранить адрес
  // real mode сегмента
  rmSeg := DOSMemoryAlloc(256);
  if rmSeg = 0 then
  begin
   Writeln('Недостаточно нижней памяти!');
   Halt(0);
  end;
  // Получить в защищенном режиме адрес real-mode сегмента
  LinAddr := DWord(rmSeg) * 16;
  // Очистить структуру rmRegs (заполнить ее нулями)
  ClearRmRegs(rmRegs);
  // Функция VBE 4F00h - GetVESAInfo
  rmRegs.AX := $4F00;
  // Занести в Real mode регистр ES значение сегмента
  // выделенного блока памяти
  rmRegs.ES := rmSeg;
  // Вызвать функцию VBE 4F00h, котора заполнит выделенный блок
  // информацией о VESA VBE
  RealModeInt($10, rmRegs);
  Write('Идентификатор: ');
  // Прочитать первые 4 байта из блока в нижней памяти и
  // вывести их на экран. Если Ваша видеокарта поддерживает
  // VESA VBE, Вы увидите слово 'VESA'
  for i := LinAddr to LinAddr + 3 do Write(char(Pointer(i)^));
  // Free allocated memory block
  DOSMemoryFree(rmSeg);
end.