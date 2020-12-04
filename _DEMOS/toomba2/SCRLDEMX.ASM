{ Here's a stoopid include file for ModeX stuff in pascal
 version 0.1 with no debugging done
 straight ripped from one of my assembler files so procs need testing}

Procedure Wait;
begin
     repeat until keypressed;
end;

Procedure SetfullPal;Assembler;
asm
        mov bx,0                                { that I did in uppercase.   }
        mov ax,Seg Palbuffer
        mov es,ax
        mov ax,OFFSET Palbuffer                 { from pal1 in _Logo segment}
        mov dx,ax
        mov cx,256                              { all 256 colours }
        mov ah,10h                              { 768 bytes worth}
        mov al,12h
        int 10h                                 { uses int 10h}
        ret
end; {of proc}

Procedure  WaitVsyncStart;Assembler;
asm
        mov     dx, 03dah
@11:
        in      al,dx
        test    al,08h
        jnz     @11
@22:
        in      al,dx
        test    al,08h
        jz      @22

       { ret }
END;

Procedure WaitVsyncEnd;Assembler;
asm
        mov     dx,03dah                { ie display enable period}
@33:
        in      al,dx
        test    al,08h
        jz     @33
@44:
        in      al,dx
        test    al,08h
        jnz      @44
        ret
end;

Procedure InitScreen;assembler;

asm
        mov     ax, 0013h
        int     10h             { switch to 320x200x256c (non-tweaked)}

        mov     dx, 03c4h
        mov     ax, 0604h
        out     dx, ax          { disable chain4 mode                  }
        mov     ax, 0100h
        out     dx, ax          { sync. reset while setting Misc.       }
        mov     dx, 03c4h
        mov     ax, 0300h
        out     dx, ax          { undo reset (restart sequencer)         }
        mov     dx, 03d4h
        mov     al, 11h
        out     dx, al
        inc     dx
        in      al, dx
        and     al, 07fh
        out     dx, al          { clear protection bit        }
        dec     dx
        mov     ax, 0014h
        out     dx, ax          { clear dword mode             }
        mov     ax, 0e317h
        out     dx, ax          { set byte mode                 }
        mov     dx, 03c4h
        mov     ax, 0f02h
        out     dx, ax          { enable writes to all four planes}

        mov     dx, 03d4h
        mov     al, 13h
        out     dx, al          { set logical screen width        }
        inc     dx              { set to size of screen we want    }
        mov     al, 28h
        out     dx, al          { to 320 pixels (== 40 bytes == 28h) }

        mov     ax, 0a000h
        mov     es, ax
        xor     di, di
        xor     ax, ax
        mov     cx, 08000h
        rep     stosw           { clear display memory               }
        ret

end;                  { now in planar modeX... nice....              }

Procedure Readpalfileintobuffer(palfile:string);
VAR pfile:file of byte;
    index:integer;
begin
     assign(pfile,palfile);      { Open a pallette file }
     reset(pfile);
     seek(pfile,0);              { set to first byte }
     for index:=1 to 768 do
         begin
              read(pfile,palbuffer[index])
         end;
     close(pfile);
end;
{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure  ReadRawfileintobuffer(filename)                             Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Reads a raw screen file into a memory buffer to put into VM later บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure ReadRawfileintobuffer(Rawfile:string);
VAR rfile:file;
    index:word;
begin
     index:=64000;
     assign(rfile,Rawfile);   { open the Raw screen file }
     reset(rfile,1);
     seek(rfile,0);
           blockread(rfile,rawbuffer,index);
     close(rfile);
end;
{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure  BlasbuffertoVM                                              Ûฐ}
{Û ษอ Description อออออออออออออออออออออออออออออออออออออออออออออออออออออ0ป Ûฐ}
{Û บ  Chucks the screen from buffer into VGA mem (number of page in byt)บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure BlastbuffertoVM(page:byte);assembler;
asm
   xor  ax,ax
   mov  al,page
   mov  bx,16000
   imul  bx
   mov  di,ax
   mov  ax,0a000h
   mov  es,ax
   mov  ax,seg Rawbuffer
   mov  ds,ax
   mov  ax,offset rawbuffer
   mov  si,ax
end;

{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure   Flippages                                                  Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Toggles between the pages pointed to by hiddenofs and visibleofs  บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure FlipPages;assembler;

asm     mov     bx, [HiddenOfs]      { exchange hidden and visible page}
        xchg    bx, [VisibleOfs]
        xchg    [HiddenOfs], bx
        mov     ax, bx                  { ax now contains HiddenOfs      }
        mov     bh, al
        mov     ch, ah
        mov     bl, 0dh                 { page address low               }
        mov     cl, 0ch                 { page address high              }

        mov     dx, 03dah               { wait for trailing edge of Vsync }
@WaitDE:
        in      al, dx
        test    al, 01h
        jnz     @WaitDE

        mov     dx, 03d4h
        mov     ax, bx
        out     dx, ax                  { start address low              }
        mov     ax, cx
        out     dx, ax                  { start address high             }
        ret
end;
{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure   Showpage (byte)                                            Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Used to make one of the 4 pages of mode visible....               บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure Showpage(page:byte);assembler;

asm
        xor     ax,ax
        mov     al,page
        mov     bx,16000
        imul    bx
        mov     bh, al
        mov     ch, ah
        mov     bl, 0dh                 { page address low               }
        mov     cl, 0ch                 { page address high              }

        mov     dx, 03dah               { wait for trailing edge of Vsync }
@WaitDE:
        in      al, dx
        test    al, 01h
        jnz     @WaitDE

        mov     dx, 03d4h
        mov     ax, bx
        out     dx, ax                  { start address low              }
        mov     ax, cx
        out     dx, ax                  { start address high             }
        {ret}
end;

{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure   Scrollpages                                                Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Scrolls the screen between two pages by setting the screen start  บ Ûฐ}
{Û บ  address register and then incrementing line by line up a page..   บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure ScrollPages;assembler;
asm
        mov     bx, [VisibleOfs]
        mov     ax, bx                  { ax now contains VisibleOfs     }
        add     ax,[pageaddline]        { add a line to move address down}
        mov     bh, al
        mov     ch, ah
        mov     bl, 0dh                 { page address low               }
        mov     cl, 0ch                 { page address high              }

        mov     dx, 03dah               { wait for trailing edge of Vsync }
@Waitdisplay:
        in      al, dx
        test    al, 01h
        jnz     @Waitdisplay

        mov     dx, 03d4h
        mov     ax, bx
        out     dx, ax                  { start address low              }
        mov     ax, cx
        out     dx, ax                  { start address high             }
        call    WaitVsyncStart          {; wait for start vert. retrace
                                        ; to avoid screen flickering}
        ret
end;


{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure Blastplanarscreen                                            Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ point DS:SI to your planar screen segment start                    บ Ûฐ}
{Û บ ES:DI to the screen you want to write to.... and go...             บ Ûฐ}
{Û บ This proc has been unrolled to show you what to do & to save speed บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure Blastplanarscreen;assembler;
asm
        mov     dx,seqadd               { dx sequencer address           }
        mov     al,mapmask              { index to use with seq add       }
        out     dx,al                   { go..                             }
        inc     dx                      { data port to put our value in     }
        mov     al,plane0               { value to put into the data port 01b}
        out     dx,al                   { write the value (set plane 1 only) }
        dec     dx                      { set dx back                        }
        mov     cx,screenplane                    {; uses fast rep movsb}
        rep     movsb                             {; for CX number of bytes}
        sub     di,screenplane                    {; then resets the screen adrs}

        mov     dx,seqadd               { dx sequencer address               }
        mov     al,mapmask              { index to use with seq add          }
        out     dx,al                   { go..                               }
        inc     dx                      { data port to put our value in      ]
        mov     al,plane1               { value to put into the data port 10b}
        out     dx,al                   {write the value (set plane 1 only) }
        dec     dx
        mov     cx,screenplane
        rep     movsb
        sub     di,screenplane

        mov     dx,seqadd               { dx sequencer address               }
        mov     al,mapmask              { index to use with seq add          }
        out     dx,al                   { go..                               }
        inc     dx                      { data port to put our value in      }
        mov     al,plane2               { value to put into the data port 100b }
        out     dx,al                   { write the value (set plane 1 only)   }
        dec     dx
        mov     cx,screenplane                  {  ; uses fast rep movsb}
        rep     movsb                           {  ; for CX number of bytes}
        sub     di,screenplane                  {  ; then resets the screen adrs}

        mov     dx,seqadd               { dx sequencer address                }
        mov     al,mapmask              { index to use with seq add           ]}
        out     dx,al                   { go..                                 }
        inc     dx                      { data port to put our value in        }
        mov     al,plane3               { value to put into the data port 1000b}
        out     dx,al                   { write the value (set plane 1 only)   }
        dec     dx

        mov     cx,screenplane
        rep     movsb
        sub     di,screenplane
        ret
end;

{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure  Fadeonfull                                                  Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  fadesinto a pallette ie from black to picture pal....             บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}

Procedure Fadeonfull;assembler;

asm
end;












{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure  Textmode                                                    Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Just sets the CRT back to 80x25 text mode....                     บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}


Procedure Textmode;assembler;
asm
   mov ax,3
   int 10h
end;


{Û฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿Û }
{Û Procedure  Scroller                                                    Ûฐ}
{Û ษอ Description ออออออออออออออออออออออออออออออออออออออออออออออออออออออป Ûฐ}
{Û บ  Scrolls the screen from one page to the next (use spritedirec to  บ Ûฐ}
{Û บ  change the scroll direction ) needs some work.....                บ Ûฐ}
{Û ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ Ûฐ}
{ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛฐ}
{ ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ}



Procedure Scroller;assembler;
asm
@fliploop:
        cmp    [spritedirec],1
        jne    @scrollup
        jmp    @scrolldn
@scrollup:
        add     [pageaddline],320
        call    scrollpages
        cmp     [pageaddline],16000
        jne     @scrollup
        mov     [spritedirec],1
        jmp     @keyloop
@scrolldn:
        sub     [pageaddline],320
        call    scrollpages
        cmp     [pageaddline],0
        jne     @scrolldn
        mov     [spritedirec],0
        jmp     @keyloop
@keyloop:
        mov     ah,1                   { ; see if a key is ready  }
        int     16h

        jz      @keyloop              { ; nope then loop         }

        mov     ah,0                   { ; yes so get the key     }
        int     16h
        cmp     al,"f"                 { ; is it 'f'              }
        je      @fliploop             { ; yeah so flip screens   }
        cmp     al,"q"                 { ; is it 'q'              }
        je      @alldone              { ; yeah so finish         }

        jmp     @keyloop              { ; no so loop again       }
@alldone:
end;
