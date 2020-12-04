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
	Yspeedcounter,Y:byte;
	Yspeed:integer;
	Z:byte;

Constructor Init(X_,Y_,Z_:byte;Yspeed_:integer);
Destructor Done; virtual;
procedure Fall;  virtual; 
	
procedure Render; virtual;
end;


var S:array[0..1001] of Drop;
	i: integer;
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
    	SetColor(Color,R div 6, G div 6, B div 6);
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
Constructor Drop.Init(X_,Y_,Z_:byte;Yspeed_:integer);

begin
X:=X_;
Y:=Y_;
Z:=Z_;
Yspeed:=Yspeed_;
Yspeedcounter:=0;
end;
Destructor Drop.Done;
begin
 end;

 
 
procedure Drop.Fall;
	begin
 
	if Yspeed > 0 then begin
	 
	if z<Yspeed then Y:=Y+(Yspeed div 10)-(z div 10);
	if y>5+random(20) then Yspeed := Yspeed +1;


	YspeedCounter:=Yspeedcounter+(Yspeed mod 10);
	if Yspeedcounter>10 then begin Y:=Y+1; Yspeedcounter:=0; end;

	 if Y>25 then Y:=25;
	end;

	if Yspeed < 0 then begin
	Yspeed := Yspeed * (-1);

	Y:=Y-Yspeed div 10;
	 

	YspeedCounter:=Yspeedcounter+(Yspeed mod 10);
	if Yspeedcounter>10 then begin Y:=Y-1; Yspeedcounter:=0; end;

	 if Y>0 then Y:=0;
	end;

	end;
 

procedure Drop.Render;
	var AttributeOut:byte;
		AttributeCheck:integer;

	begin
 	{
 	RenderScreen[Y,X].Character:=249+Y mod 2;}
 	AttributeCheck:= 15-(Yspeed div 2)+1;
 	if AttributeCheck<1 then AttributeCheck:=1;
 	if AttributeCheck>16 then AttributeCheck:=16;
 	AttributeOut:=AttributeCheck;

 	 RenderScreen[Y,X].Character:=90;
	RenderScreen[Y,X].Attribute:=AttributeOut;

	if ShowConsole then begin
	TopLine(1,'Enter/ESC - toggle Console | Q - quit');
	TopLine(25,'');
	
	FastWrite(2,2,'Drops: [W|S]:     ');FastWrite(20,2,inttoStr(n));
	FastWrite(2,3,'Speed: [<-|->]:   ');FastWrite(20,3,inttoStr(speed));
	FastWrite(2,4,'minSp: [A|D]:     ');FastWrite(20,4,inttoStr(minspeed));

	FastWrite(2,5,'YSpeed: ');FastWrite(9,5 ,inttoStr(Yspeed));
	FastWrite(2,6,'Wait   [Up|Down]: ');FastWrite(20,6 ,inttoStr(Wait));
	FastWrite(2,7,'Pause  [R|F]:     ');FastWrite(20,7 ,inttoStr(PauseTime));
	FastWrite(2,8,'Attribute: ');FastWrite(20,8,inttoStr(20-(Yspeed div 2)+1));
	end;
	
	end;


{ --- CLASS END ----}

procedure SetRainyPalette(dr,dg,db:byte);
	begin
			SetColorRGB(0 , 3 div dr , 11 div dg, 30 div db);
		SetColorRGB(1 , 191 div dr, 215  div dg    , 244 div db);
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
		SetColorRGB(13, 4  div dr , 35 div dg  ,  40 div  db);  
		SetColorRGB(14, 3  div dr , 30  div dg ,  24  div  db); 
		SetColorRGB(15, 2  div dr  , 2 div dg  ,  14 div  db);
		SetColorRGB(16, 2 div dr , 2  div dg ,  9   div  db);  

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
		n:=133;
		speed:=22;
		minspeed:=3;
		Wait:=1;
		Counter:=0;
		SetRainyPalette(1,1,1);
 			{init(x,y,yspeed)}
 
	initnewkeyint;
	initnewtimint;
	
	
 randomize;
 repeat



			for i:=0 to n do begin
			if s[i].x=0  then begin   s[i].init(random(80),0,random(20),random(speed)+minspeed); end;
			 if s[i].y>24 then begin

			 s[i].init(random(80),0,random(20),random(speed)+minspeed)

				 
			 end;

				s[i].fall;
			    s[i].render; 
			   
			    end;

			
			Counter:=Counter+1;
			
			
			Screen:=RenderScreen;
			if keydown[$11] then incpos(n);   { W }
if keydown[$1f] then decpos(n);    { S }
if keydown[$1e] then decpos(minspeed);   { A }
if keydown[$20] then incpos(minspeed);    { D }
if keydown[upscan] then incpos(wait);
if keydown[downscan] then decpos(wait);
 if keydown[$13] then incpos(PauseTime); { R }
 if keydown[$21] then decpos(pausetime);  {F }
 
if keydown[Entscan] then ShowConsole:=TRUE;
if keydown[escscan] then ShowConsole:=FALSE;
if keydown[rightscan] then speed:=speed+1;
if keydown[leftscan] then speed:=speed-1;

			WaitRetrace(Wait);
			Pause(PauseTime);
		    RenderScreen:=BlankScreen;
SetRainyPalette(1,1,1);





SetColorRGB(4 , 52 , 127   , 183 );

if Wait<=0 then Wait:=0;
if n<0 then n:=0;
 if speed<0 then speed:=0;
 if minspeed<=0 then minspeed:=0;


until keydown[$10];   {Q} 


	 setoldkeyint; 
	  setoldtimint;
	  turn_on_cursor;
	  RestorePallete;

end.
{$N-}
