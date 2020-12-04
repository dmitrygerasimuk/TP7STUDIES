{$N+}
program drops;
 uses  games,dos;
type ScrType=array [1..25,1..80] of record
       Character: byte;
       Attribute: byte;
     end;

type Sprite=array [1..16,1..16] of record
       Character: byte;
       Attribute: byte;
end;

type 
	Drop=Object
	Paused,Alive,onScreen:boolean;
	X:integer;
	Yspeedcounter,Y:integer;
	Yspeed:integer;
	Z:integer;
	glyph:array [0..20] of byte;
	lenght:byte;


Constructor Init(Paused_,Alive_,onScreen_:boolean;X_,Y_,Z_:integer;glyph_:array of byte;lenght_:byte;Yspeed_:integer);
Destructor Done; virtual;
procedure Fall; virtual; 
	
procedure Render; virtual;
end;

{{{{ VARIABLES }


var S:array[0..800] of Drop;
	i,j: integer;
	Screen:  ScrType absolute $B800:0000;
    SaveScreen:ScrType;    { visible when console is ON}
    
    RenderScreen:ScrType;	{ Write all Drops info here, then draw this screen after retrace}
    BlankScreen:ScrType;
    TempScreen:ScrType;	{ Keep clean screen for erasing every frame / retrace}
    BatScreen:ScrType;	
    
    Counter:longint;  		{ Just counter ticking every cycle}
    letterSprites: array[0..10] of Sprite;
    ASprite: Sprite;
    hTime, mTime, sTime, s100:word;

    speed,n:integer;
    minspeed:integer;
    attrControl:integer;
    Wait:integer;
    ShowConsole:boolean;
    PauseTime:integer;
    MemCounter:integer;
    wordlenght:integer;
    Nbr : Word;
    
    OkToInit:boolean;
    DrainIsOn:boolean;
    ITISTIMETOQUIT:boolean;

Procedure doPixel(var Scr:ScrType; var x,y:integer);
 var i,j:byte;
begin
for i:=1 to 80 do Begin

Scr[(x mod 25),i].Attribute := 22;
Scr[(x mod 25)+1,i].Attribute := 22;
Scr[(x mod 25)+2,i].Attribute := 22;

 

end;


end;

procedure flashScreen; 
var Scr: ScrType;
	 
		i,j:byte;
	begin

		for i:=1 to 80 do Begin
			for j:=1 to 25 do begin
				  	 
				 
					Scr[j,i].Attribute:=2;
                    Scr[j,i].Character:=32;
                    
			end;
		end;
    {Scr := buffer};
    Screen := Scr;
end;

Procedure doStuff(var Scr: ScrType; var attr:integer);
var buffer: ScrType;
	 
		i,j:byte;
	begin

		for i:=1 to 80 do Begin
			for j:=1 to 25 do begin
				  	 
				 
					Scr[j,i].Attribute:=attr;
			end;
		end;
    {Scr := buffer};
end;






 Procedure IncPos(var incr:integer);
  var a:integer;

 Begin
 	 if incr>=0 then a:=incr+1;
 	if incr<0 then a:=0;
 	incr:=a;


 end;

  Procedure DecPos(var decr:integer) ;
 Begin
 	if decr>=0 then decr:=decr-1;
 	if decr<0 then decr:=0;
 end;
 


Function IntToStr(I : Longint) : String;
{ Преобразовывает значение типа Integer в строку }
Var S : String [11];
Begin
 Str(I, S);
 IntToStr:=S;
End;
procedure SaveLine(var ThisScreen:ScrType;Y:byte);
	var i:byte;
	begin
	for i:=1 to 80 do Begin
		ThisScreen[Y,i]:=RenderScreen[Y,i];
		 
		end;
		end;

procedure DeleteLine(var ThisScreen:ScrType;Y:byte);
	var i:byte;
	begin
	for i:=1 to 80 do Begin
		ThisScreen[Y,i].Character:=0;
		ThisScreen[Y,i].Attribute:=0;
		
		 
		end;




	end;

procedure TopLine(var ThisScreen:ScrType; Y:byte;Str:String);
  var c,i,j:byte;
  begin
  if not ord(Str[0])>80 then begin
   c:=(80-ord(Str[0])) div 2;
   for i:=1 to c do begin
         ThisScreen[Y,i].Character:=00;
         ThisScreen[Y,i].Attribute:=23;
         end;

  for i:=c+1 to c+ord(Str[0]) do begin
  	   ThisScreen[Y,i].Character:=ord(Str[i-c]);
         ThisScreen[Y,i].Attribute:=23;
         end;
    for i:=ord(Str[0])+c+1 to 80 do begin
         ThisScreen[Y,i].Character:=00;
         ThisScreen[Y,i].Attribute:=23;
         
  end;
  end;
end;



procedure FastWriteToScr(var ThisScreen:ScrType;X,Y:byte;Str:string);
  var i,j:byte;
  begin
    for i:=1 to ord(Str[0]) do begin
         ThisScreen[Y,X+i-1].Character:=ord(Str[i]);
         ThisScreen[Y,X+i-1].Attribute:=2;
         
  end;
end;


procedure putSprite(x,y:byte; mySprite:Sprite; var Screen:ScrType);
 
	var TempScreen:ScrType;
		i,j:byte;
	begin
       
    x := x mod 80;
    y := y mod 25;
		for i:=1 to 17 do Begin
			for j:=1 to 9 do begin
				 
					Screen[y+j,x+i].Character:=mySprite[j,i].Character;
					Screen[y+j,x+i].Attribute:=mySprite[j,i].Attribute;
			end;
		end;

end;

procedure putSpriteLine(y:byte; spr:Sprite;  var scr:ScrType); 
var i:byte;
begin
 scr:=BlankScreen;
for i:=0 to 3 do Begin
    putSprite(4+17*i,y,spr,scr);
end;

end;

procedure cleanSprite(w,h,x,y:byte; var Screen:ScrType);
var  i,j:byte;
    begin

   
   Screen := BlankScreen;
    
end;

            

procedure putSpriteDimensions(w,h,x,y:byte; mySprite:Sprite; var Screen:ScrType);
 
	var TempScreen:ScrType;
		i,j:byte;
	begin
 
    x := x mod 80;
    y := y mod 25;
		for i:=1 to w do Begin
			for j:=1 to h do begin


            	if (mySprite[j,i].Character <> 219 ) then begin

					
					Screen[y+j,x+i].Character:=mySprite[j,i].Character;
					Screen[y+j,x+i].Attribute:=mySprite[j,i].Attribute;


					end else
                    Screen[y+j,x+i].Character:=mySprite[j,i].Character;
					Screen[y+j,x+i].Attribute:=mySprite[j,i].Attribute;
					
					
			end;
				 
				 
		end;

end;

procedure loadASCIISpriteDimension(w,h:byte; FileName:String; var spriteHolder: Sprite);
var 
	i:integer;
	x,y:integer;
	Ii:integer;
	F:file of Byte;
	data:array[0..1024] of byte;

	Begin
	
i:=1;
Assign(F,FileName);
{$I-}
Reset(F); {open for reading}
{$I+}
If (IoResult = 0) Then Begin
 
   While Not(EoF(F)) Do Begin
      Read (F,data[i]);
      i:=i+1;


     
      If (EoF(F)) or (i>w*h*2) Then Break;
  
   End; {of while}


End;
	{$I-}
Close(F);
{$I+}

	for x:=1 to w do Begin
		for y:=1 to h do begin
		 
			spriteHolder[y,x].Character:=ord(data[(y-1)*w*2+(x-1)*2+1]);
			spriteHolder[y,x].Attribute:=2;

		 	 

		 end;
	end;

 
End;



procedure renderTime;
var hl,hh,ml,mh,sl,sh:word;

begin

    hl := hTime div 10;
    hh := hTime mod 10;
    ml := mTime div 10;
    mh := mTime mod 10;
    sl := sTime div 10;
    sh := sTime mod 10;
    

    putSpriteDimensions(10,12,3,6, letterSprites[hl],BatScreen);
    putSpriteDimensions(10,12,12,6,letterSprites[hh],BatScreen);

    putSpriteDimensions(10,12,20,6,letterSprites[10],BatScreen);

    putSpriteDimensions(10,12,29,6,letterSprites[ml],BatScreen);
    putSpriteDimensions(10,12,38,6,letterSprites[mh],BatScreen);

    putSpriteDimensions(10,12,47,6,letterSprites[10],BatScreen);

    putSpriteDimensions(10,12,57,6,letterSprites[sl],BatScreen);
    putSpriteDimensions(10,12,66,6,letterSprites[sh],BatScreen);

end;

procedure LoadASCIIArea17FromFile(FileName:String; var NeatScreen:Sprite);   {load 17x9 bin = 306bytes}
var 
	i:integer;
	x,y:integer;
	Ii:integer;
	F:file of Byte;
	data:array[0..306] of byte;

	Begin
	
i:=1;
Assign(F,FileName);
{$I-}
Reset(F); {open for reading}
{$I+}
If (IoResult = 0) Then Begin
 
   While Not(EoF(F)) Do Begin
      Read (F,data[i]);
      i:=i+1;


     
      If (EoF(F)) or (i>306) Then Break;
  
   End; {of while}


End;
	{$I-}
Close(F);
{$I+}

	for x:=1 to 17 do Begin
		for y:=1 to 9 do begin
		 
			NeatScreen[y,x].Character:=ord(data[(y-1)*17*2+(x-1)*2+1]);
			NeatScreen[y,x].Attribute:=2;

		 	 

		 end;
	end;

 
End;



 
procedure FastWrite (X,Y:byte;Str:string);
  var i,j:byte;
  begin
    for i:=1 to ord(Str[0]) do begin
         RenderScreen[Y,X+i-1].Character:=ord(Str[i]);
         RenderScreen[Y,X+i-1].Attribute:=2;
         
  end;
end;

 

procedure LoadASCIIScreenFromFile(FileName:String; var NeatScreen:ScrType);
var 
	i:integer;
	x,y:integer;
	Ii:integer;
	F:file of Byte;
	data:array[0..4001] of byte;

	Begin
	
i:=1;
Assign(F,FileName);
{$I-}
Reset(F); {open for reading}
{$I+}
If (IoResult = 0) Then Begin
 
   While Not(EoF(F)) Do Begin
      Read (F,data[i]);
      i:=i+1;


     
      If (EoF(F)) or (i>4001) Then Break;
  
   End; {of while}


End;
	{$I-}
Close(F);
{$I+}

	for x:=1 to 80 do Begin
		for y:=1 to 25 do begin
		 
			NeatScreen[y,x].Character:=ord(data[(y-1)*80*2+(x-1)*2+1]);
			NeatScreen[y,x].Attribute:=2;

		 	 

		 end;
	end;

 
End;


procedure MergeScreens(var FrontScreen,BackScreen:ScrType);
	var TempScreen:ScrType;
		i,j:byte;
	begin

		for i:=1 to 80 do Begin
			for j:=1 to 25 do begin
				  	 
				  	if (FrontScreen[j,i].Character <> 0 or 32 ) and (FrontScreen[j,i].Attribute <> 0) then begin

					BackScreen[j,i].Character:=FrontScreen[j,i].Character;
					BackScreen[j,i].Attribute:=FrontScreen[j,i].Attribute;
					


					end else
					BackScreen[j,i].Character:=BackScreen[j,i].Character;
					BackScreen[j,i].Attribute:=BackScreen[j,i].Attribute;
			end;
		end;

end;

procedure MergeScreenAttribute(var FrontScreen,BackScreen:ScrType);
	var TempScreen:ScrType;
		i,j:byte;
	begin

		for i:=1 to 80 do Begin
			for j:=1 to 25 do begin
				  	 
				  	if (FrontScreen[j,i].Character <> 0 or 32 ) and (FrontScreen[j,i].Attribute <> 0) then begin
        
    if (FrontScreen[i,j].Attribute < 11) then begin
    BackScreen[j,i].Attribute:=FrontScreen[j,i].Attribute; 
    end else 
    BackScreen[j,i].Attribute:=2; 
					 { merge attribute from other layer}
					


					end else
					 
					BackScreen[j,i].Attribute:=BackScreen[j,i].Attribute { count transparent pixels as it is } ;
                    

                     
			end;
		end;

end;


Procedure SetColor(Color, R, G, B : Byte); Assembler;
    Asm
     Mov AX, $1007              {Get register for color}
     Mov BL, Color
     Int $10
     Xor BL, BL
     XChg BH, BL                {Put register in BL}
     Mov AX, $1010              {Set RGB for individual color}
     Mov DH, R
     Mov CH, G
     Mov CL, B
     Int $10
End;

Procedure SetColorRGB(Color, R, G, B : Byte); 
    begin
    	SetColor(Color,byte(R div 6), byte(G div 6), byte(B div 6));
    end;
procedure pause(hs:longint); assembler;
asm
  mov  es,seg0040
  mov  si,006ch
  mov  dx,word ptr es:[si+2]
  mov  ax,word ptr es:[si]
  add  ax,word ptr [hs]
  adc  dx,word ptr [hs+2]
  @@1:
  mov  bx,word ptr es:[si+2]
  cmp  word ptr es:[si+2],dx
  jl   @@1
  mov  cx,word ptr es:[si]
  cmp  word ptr es:[si],ax
  jl   @@1
end;
    procedure WaitRetrace(i:byte);
  begin
  if i>0 then begin
    for i:=0 to i do begin

 while (port[$3da] and 8) <> 0 do;   
 while (port[$3da] and 8) = 0 do;
 end;
 end;
 end;
 procedure writechar(x,y : byte; c :byte; b:byte);
begin
   
  mem[$b800: (y-1)*80*2 + (x-1)*2] := c;
  mem[$b800: (y-1)*80*2 + (x-1)*2 + 1] := b;
end;

procedure turn_off_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num or 32;
  end;
  {}
  procedure turn_on_cursor;
  var num : word;
  begin
    port[$03D4]:=$0A; num:=port[$03D5];
    port[$03D4]:=$0A; port[$03D5]:=num xor 32;
  end;

{ --- CLASS BEGIN ----}
Constructor Drop.Init(Paused_,Alive_,onScreen_:boolean;X_,Y_,Z_:integer;glyph_:array of byte; lenght_:byte;Yspeed_:integer);
var j:integer;
begin
Paused:=Paused_;
Alive:=Alive_;
onScreen:=onScreen_;
X:=X_;
Y:=Y_;
Z:=Z_;
Yspeed:=Yspeed_;
Yspeedcounter:=0;
for j:=0 to 20 do begin

glyph[j]:=glyph_[j];
end;
lenght:=lenght_;
end;
Destructor Drop.Done;
begin
 end;

 
 
procedure Drop.Fall;
 
	begin
 
	if not Paused then begin

	if DrainIsON then begin 
     
    if (Yspeed div 10) < 1 then Y:=Y+2 else Y:=Y+(Yspeed div 10)+1;
    
    end else begin


 
 	 if z<Yspeed then Y:=Y+(Yspeed div 10) - (z div 10) else  Y:=Y+(Yspeed div 10);
	 
	 
	 
 	
	YspeedCounter:=Yspeedcounter+(Yspeed mod 10);
	if Yspeedcounter>10 then begin Y:=Y+1; Yspeedcounter:=0; end;

 end;
    
    
    
    
 	 if Y>=25 then onScreen:=FALSE;
     
      
	 

	end;
	
 end;

procedure Drop.Render;
	var AttributeOut:byte;
		AttributeCheck:integer;
		i:byte;
		Ysafe:byte;

	begin

	 
	if (Y>0) and (Y<=25) and (X<=80) then begin

 	{
 	RenderScreen[Y,X].Character:=249+Y mod 2;}
 	
 	AttributeCheck:= 14-(Yspeed div 2)+1;

	if AttributeCheck<4 then AttributeCheck:=4;
 	if AttributeCheck>15 then AttributeCheck:=15;
 	AttributeOut:=AttributeCheck;

	for i:=0 to lenght do begin
	
	Ysafe:=Y+i;
	if Ysafe>=25 then Ysafe:=25;

 	 {RenderScreen[Y,= X].Character:=90; }
 	if (onScreen = TRUE)   then begin

 	  RenderScreen[Ysafe,X].Character:= glyph[i];{Z}
 	  RenderScreen[Ysafe,X].Attribute:=AttributeOut;
 	  end;

Ysafe:=0;


end;
end;

 
	end;


{ --- CLASS END ----}

Procedure Mazimize_Char;

Begin

    Repeat

      Pause(1);

       Asm

            Mov Al, 9
            Mov Dx, 3d4h
            Out Dx, Al
            Mov Dx, 3d5h
            In  Al, Dx
            Inc Al
            Or  Al, 128
            Out Dx, Al

       End;

    Until keydown[Escscan];

     

    Asm Mov Al, 15; Out Dx, Al; End;

End;

Procedure ZoomInFont;

Begin

  Port[$3d4] := $09
  ;              { Je m'adresse au registre 08h du CRTC }

  Port[$3d5] := (Port[$3d5] or 128) ;

  { Positionne à 1 le bit 7 qui divise le rythme d'horloe vertical (clock
    rate) par deux, ce qui a pour effet de dédoubler l'affichage de chaque
    ligne.  Prévu pour la génération des modes 200 lignes dans une résolution
    physique de 400 lignes. }

 
  

  { Remet à 0 le bit 7 }

End;

Procedure Index8;
var i:byte;
	Begin
		For i:=0 to 13 do begin
Port[$3D4]:=8;
Port[$3D5]:=i;
End;
repeat
until keydown [escscan];
end;

Procedure PauseRain;
	Begin
		 for i:=0 to n do begin
		 	if s[i].Alive and s[i].onScreen then s[i].Paused:=TRUE;
		 end;



		 TopLine(SaveScreen,12,'Paused'); 
 

		

	end;

Procedure UnPauseRain;
	Begin
		 for i:=0 to n do begin
		 	if s[i].Alive and s[i].onScreen then s[i].Paused:=FALSE;
		 end;
		 DeleteLine(SaveScreen,12);
	end;




Procedure Smooth_Scrolling (Sens : Byte);

{ Sens = 0 => défilement vers le bas
         1 => Défilement vers le haut  (1 ou tout autre) }

Var Tempo : Word; j:byte;
Begin
 
if Counter mod Sens = 0 then begin
   
  j:=2+random(8);
 

     Asm
          Mov Al, 8
          Mov Dx, 3d4h
          Out Dx, Al
          Mov Dx, 3d5h
          In  Al, Dx
          mov al, J
          And Al, 15
          Out Dx, Al


     { Les bits 0 à 4 représente le Initial Row Adress : indiquent au CRTC
       la ligne de déclenchement du retour du balayage vertical, normalement
       0.  Si on augmente ce paramètre, le CRTC commence par une ligne située
       plus bas, ce qui déplace le contenu de l'écran vers le haut.
       Ce registre fonctionne de la même façon en mode texte qu'en mode
       graphique, de sorte que grâce à lui on peut réaliser un défilement
       continu vertical (qu'on appelle Smooth Scrolling).
       Si la ligne de départ est égale à 15, cela signifie que je vais traiter
       le dernier pixel du caractère, et l'apparition de parasites se fera
       sentir.  Je réinitalise donc à 0 grâce à un AND 15. }

     End;
 
 
 end;

end;


Procedure Xmove(speed:byte;x:integer);

{ Cette procédure décale tout l'écran vers la gauche pixel par pixel.
  Le début de la ligne qui commence à disparaitre fait place au début de la
  ligne suivante.  Par conséquent, la ligne n° 25 (non visible) doit contenir
  le même texte que la ligne 24 pour une question d'esthétique. }



Begin

 
if Counter mod speed = 0 then begin

      Nbr := (Nbr + x mod 80) mod 80;

      Asm

          Mov Dx, 3d4h                { Je m'adresse au port du CRTC : 3d4h }
          Mov Al, 0ch

          { Registre 0ch : Linear Starting Address : définit l'offset à
            l'intérieur de la mémoire d'écran où le CRTC commence à lire
            les données graphiques }

          Mov Ah, Byte Ptr Nbr + 1
          Out Dx, Ax

          { En manipulant cette adresse, on peut provoquer un défilement
            horizontal en incrémentant sans cesse cette valeur de une
            position supérieure }

          Mov Al, 0dh
          Mov Ah, Byte Ptr Nbr
          Out Dx, Ax

      End;
 end;


End;


Procedure Xdefault;

{ Cette procédure décale tout l'écran vers la gauche pixel par pixel.
  Le début de la ligne qui commence à disparaitre fait place au début de la
  ligne suivante.  Par conséquent, la ligne n° 25 (non visible) doit contenir
  le même texte que la ligne 24 pour une question d'esthétique. }



Begin

 
if Counter mod speed = 0 then begin

      Nbr := 0;

      Asm

          Mov Dx, 3d4h                { Je m'adresse au port du CRTC : 3d4h }
          Mov Al, 0ch

          { Registre 0ch : Linear Starting Address : définit l'offset à
            l'intérieur de la mémoire d'écran où le CRTC commence à lire
            les données graphiques }

          Mov Ah, Byte Ptr Nbr 
          Out Dx, Ax

          { En manipulant cette adresse, on peut provoquer un défilement
            horizontal en incrémentant sans cesse cette valeur de une
            position supérieure }

          Mov Al, 0dh
          Mov Ah, Byte Ptr Nbr
          Out Dx, Ax

      End;
 end;


End;


Procedure ZoomOutFont;
Begin
	Port[$3d5] := (Port[$3d5] and not 128) ;
End;

procedure SetLegacyPallete(dr,dg,db:byte);
begin
    SetColorRGB(0 , 3   div dr , 11   div dg  ,  35 div db); { BLACK TINTED BLUE [B:40]}
		SetColorRGB(1 , 141 div dr , 215  div dg  ,  244 div db);   
SetColorRGB(2 , 122 div dr , 195  div dg  ,  239   div db);
		SetColorRGB(3 , 83  div dr , 164  div dg  ,  217  div db);
		SetColorRGB(4 , 52  div dr , 127  div dg  ,  183  div db);
		SetColorRGB(5 , 34  div dr , 90   div dg  ,  135 div db);
		SetColorRGB(6 , 24  div dr , 70   div dg  ,  106 div db);
		SetColorRGB(7 , 14  div dr , 48   div dg  ,  73  div db);
		SetColorRGB(8 , 12  div dr , 40   div dg  ,  60 div db);  
		SetColorRGB(9 , 10  div dr , 35   div dg  ,  55 div  db); 
		SetColorRGB(10, 9   div dr , 62   div dg  ,  84 div  db); 
		SetColorRGB(11, 8   div dr , 52   div dg  ,  74 div  db); 
		SetColorRGB(12, 5   div dr , 42   div dg  ,  64 div  db); 
		SetColorRGB(13, 4   div dr , 35   div dg  ,  50 div  db);  
		SetColorRGB(14, 3   div dr , 30   div dg  ,  54  div  db); 
		SetColorRGB(15, 3   div dr , 30   div dg  ,  54 div  db);

end;

procedure SetRainyPalette(dr,dg,db:byte);
	begin
		  
          
        
        SetColorRGB(0 , 3   div dr , 11   div dg  ,  35 div db); { BLACK TINTED BLUE [B:40]}
		SetColorRGB(1 , 141 div dr , 215  div dg  ,  244 div db);
        SetColorRGB(2 , 122 div dr , 195  div dg  ,  255   div db); { ATTRIBUTE 2 FOR FOREGROUND COLOR}
        SetColorRGB(3 , 83  div dr , 164  div dg  ,  217  div db);
        SetColorRGB(4 , 32  div dr , 70  div dg  ,  100  div db);  { FAST FALLING DROPS}
        SetColorRGB(5 , 24  div dr , 80   div dg  ,  110 div db);
        SetColorRGB(6 , 24  div dr , 80   div dg  ,  106 div db); { FAST FALLING DROPS 2}
        SetColorRGB(7 , 14  div dr , 48   div dg  ,  73  div db); { MEDIUM FAST FALLING DROPS GENERIC FAST }
        SetColorRGB(8 , 12  div dr , 20   div dg  ,  40 div db);  { FASTER FALLING DROPS WITH MINSPEED-4 + 5}
        SetColorRGB(9 , 10  div dr , 35   div dg  ,  55 div  db); 
        SetColorRGB(10, 24  div dr , 70   div dg  ,  106 div  db);  {generic 2}
        SetColorRGB(11, 8   div dr , 52   div dg  ,  74 div  db);  {slow 1}
       	SetColorRGB(12, 5   div dr , 22   div dg  ,  44 div  db);  { slow sloppy}
        SetColorRGB(13, 4   div dr , 35   div dg  ,  50 div  db);  {normal}
       	SetColorRGB(14, 3   div dr , 30   div dg  ,  54  div  db); {slow}
        
        	SetColorRGB(15, 12   div dr , 40   div dg  ,  60 div  db);

 
      
           


        {
		SetColorRGB(2 , 122 div dr , 195  div dg  ,  239   div db);
		SetColorRGB(3 , 83  div dr , 164  div dg  ,  217  div db);
		SetColorRGB(4 , 52  div dr , 127  div dg  ,  183  div db);
		SetColorRGB(5 , 34  div dr , 90   div dg  ,  135 div db);
		SetColorRGB(6 , 24  div dr , 70   div dg  ,  106 div db);
		SetColorRGB(7 , 14  div dr , 48   div dg  ,  73  div db);
		SetColorRGB(8 , 12  div dr , 40   div dg  ,  60 div db);  
		SetColorRGB(9 , 10  div dr , 35   div dg  ,  55 div  db); 
		SetColorRGB(10, 9   div dr , 62   div dg  ,  84 div  db); 
		SetColorRGB(11, 8   div dr , 52   div dg  ,  74 div  db); 
		SetColorRGB(12, 5   div dr , 42   div dg  ,  64 div  db); 
		SetColorRGB(13, 4   div dr , 35   div dg  ,  50 div  db);  
		SetColorRGB(14, 3   div dr , 30   div dg  ,  54  div  db); 
		SetColorRGB(15, 3   div dr , 30   div dg  ,  54 div  db);


        }
        
		 

end;

procedure SetBrightRainyPalette(dr,dg,db:byte);
	begin
		  
          
        
        SetColorRGB(0 , 3   div dr , 11   div dg  ,  20 div db); { BLACK TINTED BLUE [B:40]}
		SetColorRGB(1 , 151 div dr , 235  div dg  ,  255 div db);
        SetColorRGB(2 , 132 div dr , 220  div dg  ,  255   div db); { ATTRIBUTE 2 FOR FOREGROUND COLOR}
        SetColorRGB(3 , 93  div dr , 184  div dg  ,  230  div db);
        SetColorRGB(4 , 62  div dr , 157  div dg  ,  200  div db);  { FAST FALLING DROPS}
        SetColorRGB(5 , 39  div dr , 110   div dg  ,  150 div db);
        SetColorRGB(6 , 32  div dr , 85   div dg  ,  120 div db); { FAST FALLING DROPS 2}
        SetColorRGB(7 , 20  div dr , 68   div dg  ,  90 div db); { MEDIUM FAST FALLING DROPS GENERIC FAST }
        SetColorRGB(8 , 20  div dr , 50   div dg  ,  80 div db);  { FASTER FALLING DROPS WITH MINSPEED-4 + 5}
        SetColorRGB(9 , 17  div dr , 45   div dg  ,  75 div  db); 
        SetColorRGB(10, 29  div dr , 80   div dg  ,  116 div  db);  {generic 2}
        SetColorRGB(11, 14   div dr , 62   div dg  ,  84 div  db);  {slow 1}
       	SetColorRGB(12, 10   div dr , 52   div dg  ,  74 div  db);  { slow sloppy}
        SetColorRGB(13, 8   div dr , 45   div dg  ,  60 div  db);  {normal}
       	SetColorRGB(14, 6   div dr , 40   div dg  ,  64  div  db); {slow}
        
        	SetColorRGB(15, 24   div dr , 70   div dg  ,  90 div  db);

 
      
           


        {
		SetColorRGB(2 , 122 div dr , 195  div dg  ,  239   div db);
		SetColorRGB(3 , 83  div dr , 164  div dg  ,  217  div db);
		SetColorRGB(4 , 52  div dr , 127  div dg  ,  183  div db);
		SetColorRGB(5 , 34  div dr , 90   div dg  ,  135 div db);
		SetColorRGB(6 , 24  div dr , 70   div dg  ,  106 div db);
		SetColorRGB(7 , 14  div dr , 48   div dg  ,  73  div db);
		SetColorRGB(8 , 12  div dr , 40   div dg  ,  60 div db);  
		SetColorRGB(9 , 10  div dr , 35   div dg  ,  55 div  db); 
		SetColorRGB(10, 9   div dr , 62   div dg  ,  84 div  db); 
		SetColorRGB(11, 8   div dr , 52   div dg  ,  74 div  db); 
		SetColorRGB(12, 5   div dr , 42   div dg  ,  64 div  db); 
		SetColorRGB(13, 4   div dr , 35   div dg  ,  50 div  db);  
		SetColorRGB(14, 3   div dr , 30   div dg  ,  54  div  db); 
		SetColorRGB(15, 3   div dr , 30   div dg  ,  54 div  db);


        }
        
		 

end;




Procedure RestorePallete; Assembler;
  Asm
    MOV AH, $12       {Restore palette}
    MOV BL, $31
    MOV AL, $00
    INT $10

    MOV AH, $00        { Change video mode }
    MOV AL, $03
    INT $10

  End;

{ -------------- MAIN ------------}
begin
	{ LoadASCIIScreenFromFile('time.bak',MoreScreen); }
    { LoadASCIIArea17FromFile('area.bin',ASprite); }
    loadASCIISpriteDimension(10,12,'number\x_0.bin',letterSprites[0]);
    loadASCIISpriteDimension(10,12,'number\x_1.bin',letterSprites[1]);
    loadASCIISpriteDimension(10,12,'number\x_2.bin',letterSprites[2]);
    loadASCIISpriteDimension(10,12,'number\x_3.bin',letterSprites[3]);
    loadASCIISpriteDimension(10,12,'number\x_4.bin',letterSprites[4]);
    loadASCIISpriteDimension(10,12,'number\x_5.bin',letterSprites[5]);
    loadASCIISpriteDimension(10,12,'number\x_6.bin',letterSprites[6]);
    loadASCIISpriteDimension(10,12,'number\x_7.bin',letterSprites[7]);
    loadASCIISpriteDimension(10,12,'number\x_8.bin',letterSprites[8]);
    loadASCIISpriteDimension(10,12,'number\x_9.bin',letterSprites[9]);
    loadASCIISpriteDimension(10,12,'number\x_dot.bin',letterSprites[10]);
  
 
    
    

    
   { LoadASCIIScreenFromFile('time.bin',BatScreen); }
    
    
		turn_off_cursor;
        OkToInit:=TRUE;
		n:=700;
		speed:=10;
		minspeed:=1;
		Wait:=1;
		wordlenght:=20;
		Counter:=0;
		
 			{init(x,y,yspeed)}
 
			initnewkeyint;
			initnewtimint;
 
	
 randomize;

 
  
 
 SetRainyPalette(1,1,1);
 
 repeat
 
 
 
	for i:=1 to n do begin
		MemCounter:=MemCounter+20;
	MemCounter:=MemCounter+20;

		if (s[i].ALIVE=FALSE) and (s[i].Paused=FALSE)  then 
		begin  
			for j:=0 to 20 do begin
				repeat
				
				s[i].glyph[j]:=mem[$0A00*(MemCounter div 256):byte(MemCounter)+j];
				MemCounter:=Memcounter+1;
				until s[i].glyph[j] <> 0;

			end;

if OkToInit = TRUE then s[i].init(FALSE,TRUE,TRUE,random(80),(-1)*(10+random(50)),i div 5 ,
    s[i].glyph,random(wordlenght),random(speed)
    +minspeed);
		end;
			 if (s[i].onScreen=FALSE) and (s[i].Paused=FALSE) then begin
            for j:=0 to 20 do begin
					repeat
			s[i].glyph[j]:=mem[$0A00*(MemCounter div 256):byte(MemCounter)+j];
				MemCounter:=Memcounter+1;
				until s[i].glyph[j] <> 0;
			
			end;

			 if OkToInit = TRUE then
             s[i].init(FALSE,TRUE,TRUE,random(80),(-1)*(10+random(50)),i div 5 
             ,s[i].glyph,random(wordlenght),random(speed)+minspeed);
			end;


                if DrainIsON = TRUE then begin  
                    if s[i].Y < -5 then s[i].Y:=30;
                    end;
				s[i].fall;
			    s[i].render; 

                
			   
			    end;


			
			Counter:=Counter+1;



					if keydown[$11] then incpos(n);   { W }
if keydown[$1f] then decpos(n);    				{ S }
if keydown[$1e] then decpos(minspeed);   		{ A }
if keydown[$20] then incpos(minspeed);    		{ D }
if keydown[upscan] then incpos(wait);			{ UP }
if keydown[downscan] then decpos(wait);			{DOWN}
 if keydown[$13] then incpos(PauseTime); 		{ R }
 if keydown[$21] then decpos(pausetime);  		{ F }
 if keydown[$14] then incpos(attrControl); 		{ T }
 if keydown[$22] then decpos(attrControl);  		{ G }

  if keydown[$2c] then ZoomInFont; 				{ Z }
 if  keydown[$2d] then  ZoomOutFont;			{ X }

 if keydown[$2e] then Xdefault; 					{ C }
if keydown[$2f] then Xmove(1,attrControl); 					{ V}



  if keydown[$19] then PauseRain; 					{ P }
 if keydown[$1a] then UnPauseRain; 					{ [ }
 
 if keydown[$1b] then begin 
  					{ ] }
   
   OkToInit:=FALSE;
   DrainIsOn:=TRUE;
  
   
    
  
   { doStuff(SaveScreen,attrControl); } 

 
   {doPixel(BatScreen,attrControl,attrControl);}
  
  { MergeScreenAttribute(BatScreen,RenderScreen); }
  
  { putSprite(10,attrControl,ASprite,BatScreen);
 }

  { putSpriteLine(attrControl,ASprite,BatScreen); }

 






 end;



 
 
if keydown[Entscan] then ShowConsole:=TRUE;
if keydown[escscan] then ShowConsole:=FALSE;
if keydown[rightscan] then incpos(speed);
if keydown[leftscan] then decpos(speed);

					if ShowConsole then begin
 
	
       
		TopLine(RenderScreen,1,'Enter/ESC - toggle Console | Q - quit'); 

	FastWrite(2,2,'Drops [W|S]:     ');FastWrite(18,2,inttoStr(n));
	FastWrite(2,3,'Speed [<-|->]:   ');FastWrite(18,3,inttoStr(speed));
	FastWrite(2,4,'minSp [A|D]:     ');FastWrite(18,4,inttoStr(minspeed));
	FastWrite(2,5,'Len   [T|G]:     ');FastWrite(18,5,inttoStr(wordlenght));
	 
	FastWrite(2,6,'Wait  [Up|Down]: ');FastWrite(18,6 ,inttoStr(Wait));
	FastWrite(2,7,'Pause [R|F]:     ');FastWrite(18,7 ,inttoStr(PauseTime));
	FastWrite(2,8,'Counter: ');FastWrite(18,8 ,inttoStr(Counter));
    FastWrite(2,9,'attrControl: ');FastWrite(18,9 ,inttoStr(attrControl));
     
    
	 

	  	TopLine(RenderScreen,25,'[Z|X] Zoom [C] Shake [V] Xmove [P|]] Pause');
	end;	

		 if ShowConsole then MergeScreens(SaveScreen,RenderScreen);	


       

        renderTime;
             
         TempScreen:=RenderScreen;
         MergeScreenAttribute(BatScreen,TempScreen);
        RenderScreen:=TempScreen;
        MergeScreens(RenderScreen,TempScreen);

         
     {


     MergeScreens(BatScreen,RenderScreen); } 

 

       
        
        Screen:=RenderScreen;
		

 
    

			WaitRetrace(Wait);
			Pause(PauseTime);
            GetTime(hTime, mTime, sTime, s100);
             
            if Counter mod (random(20)+10) = 0 then begin
            

           {  speed:=10+round( abs( 7 * ( Sin(counter mod 500) )  )  ); }
           speed:=20;
           speed:=14;
           

            wordlenght:=5+round( abs( 15 * ( Sin(counter div 30) )  )  );
            minspeed:=4++round( abs(  2 * ( Sin(counter div 30) )  )  );
           end;
          {   
            if Counter mod 15 = 0 then begin
            Smooth_Scrolling(1);
            Xmove(1,random(1));
            Xdefault;
             
            end;
}
 
		    RenderScreen:=BlankScreen; { erase shit}
 
if keydown[$10] then DrainIsON:=TRUE;
ITISTIMETOQUIT:=TRUE;	
for i:=1 to n do begin
if s[i].Y < 25 then ITISTIMETOQUIT:=FALSE;
end;





until ITISTIMETOQUIT;  {Q} 
 
 



	 setoldkeyint; 
	  setoldtimint;
	  turn_on_cursor;
     
   
   
	  RestorePallete;

end.
{$N-}
