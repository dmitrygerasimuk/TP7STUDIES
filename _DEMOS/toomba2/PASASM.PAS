{ Test program, mainly screen draws - and flips etc.. }
Program testing;

uses dos,crt;

{ Initialise the sound routines (modobj this time)}
{$M $4000,0,0} 			{16k stack, no heap - adjust as needed }
{$L MOD-obj.OBJ} 	        { Link in Object file }


CONST
    seqadd:word=$3c4;
    mapmask:byte=02;
    plane0:byte=1;
    plane1:byte=2;
    plane2:byte=4;
    plane3:byte=8;
    screenplane:word=16000;
    scrbytewidth:byte=80;

VAR palbuffer:array [1..768] of byte;
    hiddenofs:word;
    visibleofs:word;
    Rawbuffer:array[1..64000] of byte;
    spritedirec:byte;
    pageaddline:word;
    moddev:integer;          { mod handle }

{$I Scrldemx.asm}

{$F+}         { force calls to be 'far'}
procedure modvolume(v1,v2,v3,v4:integer); external ; {Can do while playing}
procedure moddevice(var device:integer); external ;
procedure modsetup(var status:integer;device,mixspeed,pro,loop:integer;var str:string); external ;
procedure modstop; external ;
procedure modinit; external;
{$F-}

Procedure SBModPlay (md : string);

var
    stat : integer;

begin
     modinit;
     modvolume (255,255,255,255);    { Full volume }
     modsetup (stat, moddev, 10000, 1, 4, md);
end;

{ Set up the first four raw PCX files into the VGA memory }
Procedure Setupfirstfour;
begin
     readpalfileintobuffer('glass.col');
     readrawfileintobuffer('1.raw');
     setfullpal;
     blastbuffertoVm(0);                   { screen 0 }
     blastplanarscreen;
     readrawfileintobuffer('2.raw');
     blastbuffertoVM(1);                   { screen 1 }
     blastplanarscreen;
     readrawfileintobuffer('3.raw');
     blastbuffertoVM(2);                   { screen 2 }
     blastplanarscreen;
     readrawfileintobuffer('4.raw');
     blastbuffertoVM(3);                   { screen 3 }
     blastplanarscreen;
end;


{ Flip the four pages (well point to them in turn really) }
procedure flipfirstfour;
begin
   repeat
     showpage(0);
     delay(100);
     showpage(1);
     delay(100);
     showpage(2);
     delay(100);
     showpage(3);
     delay(100);
   until keypressed;
end;


{MAIN BEGIN}
begin
     modinit;                    { external initialisation procedures }
     moddevice(moddev);
     SBmodplay('freedom.mod');   { get sound going }
     hiddenofs:=$3e80;           { setup initial screens }
     visibleofs:=$00;            { to point to right places }
     pageaddline:=0;             { and vars to 0 first off }
     spritedirec:=0;
     initscreen;                 { set modex 4 page 320x200 mode }

{ Ok, now we're set up, load all 4 pages with the first grafix }

     setupfirstfour;             { load into VGA mem }
     flipfirstfour;              { flip through em   }


     readrawfileintobuffer('5.raw');     { stupid way of doing this }
     blastbuffertoVM(1);                 { put the 64k into video mem }
     blastplanarscreen;                  { setup and do it....        }
     showpage(1);                        { show what we've done       }
     readrawfileintobuffer('6.raw');     { now setup the last page    }
     blastbuffertoVM(2);                 { setup and do it......      }
     blastplanarscreen;                  { for a whole screens worth  }
     delay(1000);                        { wait?                      }
     visibleofs:=$3e80;                  { point to visible page      }
     scroller;                           { call the scroller procedure}
     modstop;                            { stop playing the mod       }
     textmode;                           { get back to mode 03h       }
end.
