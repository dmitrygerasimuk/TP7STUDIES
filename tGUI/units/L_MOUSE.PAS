{
     Модуль для работы с мышью в текстовых режимах
     (c) Viktor Ostashev

     04.02.96 15:15
}

{$a-}
unit l_mouse;

interface

type
     tmousebuf           = record
                                status, x, y        : byte;
                           end;

var
     mouseyes            : boolean;
     mousebuff           : tmousebuf;

procedure mouseon;
{
Включить курсор мыши
}

procedure mouseoff;
{
Выключить курсор мыши
}

procedure setmouserange(x1, y1, x2, y2 : byte);
{
Установить границы для курсора мыши
}

procedure getmousepos(var x, y : byte);
{
Получить текущую позицию курсора мыши
}

function mousein(x1, y1, x2, y2 : byte) : boolean;
{
Проверить нахождение курсора мыши в заданном прямоугольнике
}

procedure setmousecrs(screenmask, crsmask : word);
{
Установить вид курсора мыши (int 33h)
}

function setmousedrv(activate : word; driver : pointer) : boolean;
{
Установить драйвер события мыши
}

function clickmouse : byte;
{
Прочитать информацию о последнем нажатии мыши
}


function mousebufyes : boolean;
{
Проверить наличие события в буфере мыши
}

procedure setdefmousedrv;
{
Установить драйвер по умолчанию события мыши
}
procedure defaultmousedriver;

implementation

var
     crsmouse            : boolean;
     saveexit            : pointer;
     bufs                : array [1..3] of byte absolute mousebuff;

     function initmouse  : boolean; assembler;
     asm
          xor     ax,ax
          int     33h
          mov     crsmouse,0
     end;

     procedure mouseon;
     begin
          if mouseyes then
               asm
                    mov     ax,0001h
                    int     33h
               end;
          crsmouse := true;
     end;

     procedure mouseoff;
     begin
          if mouseyes and crsmouse then
               asm
                    mov     ax,0002h
                    int     33h
               end;
          crsmouse := false;
     end;

     procedure setmouserange;
     begin
          if mouseyes then
               asm
                    mov     al,08h
                    mul     x1
                    mov     cx,ax
                    mov     al,08h
                    mul     x2
                    mov     dx,ax
                    mov     ax,0007h
                    int     33h
                    mov     al,08h
                    mul     y1
                    mov     cx,ax
                    mov     al,08h
                    mul     y2
                    mov     dx,ax
                    mov     ax,0008h
                    int     33h
               end;
     end;

     procedure getmousepos;
     var a, b            : byte;
     begin
          if mouseyes and crsmouse then
               asm
                    mov     ax,0003h
                    int     33h
                    mov     ax,dx
                    mov     bh,08h
                    div     bh
                    mov     b,al
                    mov     ax,cx
                    div     bh
                    mov     a,al
               end
                                   else
               begin
                    a := 255;
                    b := 255;
               end;
          x := a;
          y := b;
     end;

     function mousein;
     var x, y            : byte;
     begin
          x := mousebuff.x;
          y := mousebuff.y;
          mousein := (x <= x2) and (x >= x1) and (y <= y2) and (y >= y1);
     end;

     procedure setmousecrs;
     begin
          if mouseyes then
               asm
                    mov     ax,000Ah
                    xor     bx,bx
                    mov     cx,screenmask
                    mov     dx,crsmask
                    int     33h
               end;
     end;

     function setmousedrv;
     begin
          if mouseyes then
               asm
                    mov     ax,000Ch
                    mov     cx,activate
                    les     dx,driver
                    int     33h
                    not     ax
               end
                      else setmousedrv := false;
     end;

     {$f+}
     procedure defaultmousedriver; assembler;
          asm
               push    seg @data
               pop     ds
               mov     byte ptr mousebuff,bl
               mov     ax,cx
               mov     bh,08h
               div     bh
               mov     byte ptr mousebuff[1],al
               mov     ax,dx
               div     bh
               mov     byte ptr mousebuff[2],al
               mov     ax,000Ah
               xor     bx,bx
               or      byte ptr mousebuff,00h
               jnz     @1
               mov     cx,0FFFFh
               mov     dx,7700h
               jmp     @2
               @1:
               mov     cx,0FF00h
               mov     dx,77FBh
               @2:
               int     33h
          end;

     procedure setdefmousedrv;
     begin
          setmousedrv($7F, @defaultmousedriver);
     end;

     procedure mouseexitproc;
     begin
          exitproc := saveexit;
          setmousedrv(00, @defaultmousedriver);
     end;

     function clickmouse;
     begin
          clickmouse := mousebuff.status;
          mousebuff.status := 255;
     end;

     function mousebufyes;
     begin
          mousebufyes := mousebuff.status < 255;
     end;

begin
     mousebuff.status := 255;
     mouseyes := initmouse;
     saveexit := exitproc;
     exitproc := @mouseexitproc;
     setdefmousedrv;
end.


