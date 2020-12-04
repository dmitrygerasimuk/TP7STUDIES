{$N+}
program drops;
 uses games;
type ScrType=array [1..25,1..80] of record
       Character: byte;
       Attribute: byte;
     end;


type 
	Drop=Object
	X:byte;
	Yspeedcounter,Y:integer;
	Yspeed:integer;
	Z:integer;
	glyph:array [0..20] of byte;
	lenght:byte;


Constructor Init(X_,Y_,Z_:byte;glyph_:array of byte;lenght_:byte;Yspeed_:integer);
Destructor Done; virtual;
procedure Fall;  virtual; 
	
procedure Render; virtual;
end;

{{{{ VARIABLES }


var S:array[0..1001] of Drop;
	i,j: integer;
	 Screen:  ScrType absolute $B800:0000;
     OldScreen: ScrType;
     RenderScreen:ScrType;
     BlankScreen:ScrType;
     Counter:longint;
     	speed,n:integer;
     	minspeed:integer;
     	Wait:integer;
     	ShowConsole:boolean;
     	PauseTime:integer;
     	MemCounter:integer;
     	wordlenght:integer;

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

procedure TopLine(Y:byte;Str:String);
  var c,i,j:byte;
  begin
  if not ord(Str[0])>80 then begin
   c:=(80-ord(Str[0])) div 2;
   for i:=1 to c do begin
         RenderScreen[Y,i].Character:=00;
         RenderScreen[Y,i].Attribute:=23;
         end;

  for i:=c+1 to c+ord(Str[0]) do begin
  	   RenderScreen[Y,i].Character:=ord(Str[i-c]);
         RenderScreen[Y,i].Attribute:=23;
         end;
    for i:=ord(Str[0])+c+1 to 80 do begin
         RenderScreen[Y,i].Character:=00;
         RenderScreen[Y,i].Attribute:=23;
         
  end;
  end;
end;



procedure FastWrite(X,Y:byte;Str:string);
  var i,j:byte;
  begin
    for i:=1 to ord(Str[0]) do begin
         RenderScreen[Y,X+i-1].Character:=ord(Str[i]);
         RenderScreen[Y,X+i-1].Attribute:=2;
         
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
Constructor Drop.Init(X_,Y_,Z_:byte;glyph_:array of byte; lenght_:byte;Yspeed_:integer);
var j:integer;
begin
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
 

	 

 	 if z<Yspeed then Y:=Y+(Yspeed div 10) - (z div 10) else  Y:=Y+(Yspeed div 10);
	 
	 
	
	  {some gravity if lucky}
 	 
 	
	YspeedCounter:=Yspeedcounter+(Yspeed mod 10);
	if Yspeedcounter>10 then begin Y:=Y+1; Yspeedcounter:=0; end;

	

 	 if Y>=25 then Y:=25;
	 

	end;
	
 

procedure Drop.Render;
	var AttributeOut:byte;
		AttributeCheck:integer;
		i:byte;
		Ysafe:byte;

	begin

	if (Y<=25) and (X<=80) then begin

 	{
 	RenderScreen[Y,X].Character:=249+Y mod 2;}
 	
 	AttributeCheck:= 14-(Yspeed div 2)+1;

	if AttributeCheck<1 then AttributeCheck:=1;
 	if AttributeCheck>15 then AttributeCheck:=15;
 	AttributeOut:=AttributeCheck;

	for i:=0 to lenght do begin
	Ysafe:=Y+i;
	if Ysafe>=25 then Ysafe:=25;

 
 	 {RenderScreen[Y,X].Character:=90; }
 	if RenderScreen[Ysafe+1,X].Attribute <= AttributeOut then begin
 	  RenderScreen[Ysafe,X].Character:= glyph[i];{Z}
 	  RenderScreen[Ysafe,X].Attribute:=AttributeOut;
 	  end;

Ysafe:=0;


end;
end;

	
	end;


{ --- CLASS END ----}



procedure SetRainyPalette(dr,dg,db:byte);
	begin
			SetColorRGB(0 , 3 div dr , 11 div dg, 30 div db);
		SetColorRGB(1 , 141 div dr, 215  div dg    , 244 div db);
		SetColorRGB(2 , 122 div dr,195   div dg ,  239   div db);
		SetColorRGB(3 , 83 div dr, 164  div dg   ,217  div db);
		SetColorRGB(4 , 52 div dr, 127  div dg   , 183  div db);
		SetColorRGB(5 , 34 div dr , 90  div dg    , 135 div db);
		SetColorRGB(6 , 24 div dr , 70  div dg    , 106 div db);
		SetColorRGB(7 , 14 div dr , 48   div dg   , 73  div db);
		SetColorRGB(8 , 12 div dr , 40 div dg  ,  60 div db);  
		SetColorRGB(9 , 10 div dr , 35 div dg  ,  55 div  db); 
		SetColorRGB(10, 9  div dr , 62 div dg  ,  84 div  db); 
		SetColorRGB(11, 8  div dr , 52 div dg  ,  74 div  db); 
		SetColorRGB(12, 5 div dr , 42 div dg  ,  64 div  db); 
		SetColorRGB(13, 4  div dr , 35 div dg  ,  50 div  db);  
		SetColorRGB(14, 3  div dr , 30  div dg ,  54  div  db); 
		SetColorRGB(15, 3  div dr  , 30 div dg  ,  54 div  db);
		 

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

		turn_off_cursor;
		n:=128;
		speed:=25;
		minspeed:=3;
		Wait:=1;
		wordlenght:=6;
		Counter:=0;
		SetRainyPalette(1,1,1);
 			{init(x,y,yspeed)}
 
	initnewkeyint;
	initnewtimint;
	
	
 randomize;
 SetRainyPalette(1,1,1);



randomize;




 repeat
 
 
 
			for i:=0 to n do begin
			MemCounter:=MemCounter+20;

			if s[i].y=0  then begin  
			for j:=0 to 20 do begin
				s[i].glyph[j]:=mem[$0A00*(MemCounter div 256):byte(MemCounter)+j];
			end;

			 s[i].init(random(80),1,7+random(20) ,s[i].glyph,random(wordlenght),random(speed)+minspeed);
			 end;
			 if s[i].y>24 then begin
for j:=0 to 20 do begin
				s[i].glyph[j]:=mem[$0A00*(MemCounter div 256):byte(MemCounter)+j];
			end;

			 s[i].init(random(80),1,7+random(20) ,s[i].glyph,random(wordlenght),random(speed)+minspeed)

				 
			 end;

				s[i].fall;
			    s[i].render; 
			   
			    end;


			
			Counter:=Counter+1;
					if keydown[$11] then incpos(n);   { W }
if keydown[$1f] then decpos(n);    { S }
if keydown[$1e] then decpos(minspeed);   { A }
if keydown[$20] then incpos(minspeed);    { D }
if keydown[upscan] then incpos(wait);
if keydown[downscan] then decpos(wait);
 if keydown[$13] then incpos(PauseTime); { R }
 if keydown[$21] then decpos(pausetime);  {F }
 if keydown[$14] then incpos(wordlenght); { T }
 if keydown[$22] then decpos(wordlenght);  {G }
 
 
if keydown[Entscan] then ShowConsole:=TRUE;
if keydown[escscan] then ShowConsole:=FALSE;
if keydown[rightscan] then incpos(speed);
if keydown[leftscan] then decpos(speed);

					if ShowConsole then begin
 
	
		TopLine(1,'Enter/ESC - toggle Console | Q - quit');

	FastWrite(2,2,'Drops [W|S]:     ');FastWrite(18,2,inttoStr(n));
	FastWrite(2,3,'Speed [<-|->]:   ');FastWrite(18,3,inttoStr(speed));
	FastWrite(2,4,'minSp [A|D]:     ');FastWrite(18,4,inttoStr(minspeed));
	FastWrite(2,5,'Len   [T|G]:     ');FastWrite(18,5,inttoStr(wordlenght));
	 
	FastWrite(2,6,'Wait  [Up|Down]: ');FastWrite(18,6 ,inttoStr(Wait));
	FastWrite(2,7,'Pause [R|F]:     ');FastWrite(18,7 ,inttoStr(PauseTime));

	  	TopLine(25,'');
	end;
			Screen:=RenderScreen; { draw what we've done}

	
			WaitRetrace(Wait);
			Pause(PauseTime);

		    RenderScreen:=BlankScreen; { erase shit}
 
	


until keydown[$10];   {Q} 


	 setoldkeyint; 
	  setoldtimint;
	  turn_on_cursor;
	  RestorePallete;

end.
{$N-}
