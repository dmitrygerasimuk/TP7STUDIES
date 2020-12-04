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

Constructor Init(X_,Y_:byte;Yspeed_:integer);
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

Function IntToStr(I : Longint) : String;
{ Преобразовывает значение типа Integer в строку }
Var S : String [11];
Begin
 Str(I, S);
 IntToStr:=S;
End;

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


{ --- CLASS BEGIN ----}
Constructor Drop.Init(X_,Y_:byte;Yspeed_:integer);

begin
X:=X_;
Y:=Y_;
Yspeed:=Yspeed_;
Yspeedcounter:=0;
end;
Destructor Drop.Done;
begin
 end;

 
 
procedure Drop.Fall;
	begin
	
	if Yspeed > 0 then begin


	Y:=Y+Yspeed div 10;
	 

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
	begin
 	{RenderScreen[Y,X].Character:=249+Y mod 2;}
 	 RenderScreen[Y,X].Character:=90;
	RenderScreen[Y,X].Attribute:=10-(Yspeed div 2)+1;

	FastWrite(2,2,'Drops: ');FastWrite(9,2,inttoStr(n));
	FastWrite(2,3,'Speed: ');FastWrite(9,3,inttoStr(speed));
	FastWrite(2,4,'MinSpeed: ');FastWrite(12,4,inttoStr(minspeed));

	FastWrite(2,5,'YSpeed: ');FastWrite(9,5 ,inttoStr(Yspeed));
	FastWrite(2,6,'WaitRetrace: ');FastWrite(14,6 ,inttoStr(Wait));
	
	
	end;


{ --- CLASS END ----}

procedure SetRainyPalette;
	begin
			SetColorRGB(7,55, 55, 55);
	
		SetColorRGB(0, 3, 11, 30);
		SetColorRGB(1, 191, 215, 224);
		SetColorRGB(2,  172,204,217);
		SetColorRGB(3, 147, 184, 205);
		SetColorRGB(4, 115, 160, 190);
		SetColorRGB(5, 69  , 122 , 154);
		SetColorRGB(6, 49  , 102 , 144);
		SetColorRGB(7, 39  , 92 , 124);
		SetColorRGB(8, 29  , 82 , 104);
		SetColorRGB(9, 19  , 72 , 94);
		SetColorRGB(10, 9  , 62 , 84);
		SetColorRGB(8, 9  , 52 , 74);


end;

{ -------------- MAIN ------------}
begin
		n:=103;
		speed:=18;
		minspeed:=4;
		Wait:=1;
		Counter:=0;
		SetRainyPalette;
 			{init(x,y,yspeed)}
 
	initnewkeyint;
	
	
 randomize;
 repeat



			for i:=0 to n do begin
			if s[i].y=0  then begin   s[i].init(random(80),0,random(speed)+minspeed); end;
			 if s[i].y>24 then begin

			 s[i].init(random(80),1,random(speed)+minspeed)

				 
			 end;

				s[i].fall;
			    s[i].render; 
			   
			    end;

			
			Counter:=Counter+1;
			
			
			Screen:=RenderScreen;
			WaitRetrace(Wait);
		    RenderScreen:=BlankScreen;
if keydown[$11] then n:=n+1;   { W }
if keydown[$1f] then n:=n-1;    { S }
if keydown[$1e] then minspeed:=minspeed-1;   { A }
if keydown[$20] then minspeed:=minspeed+1;    { D }
if keydown[upscan] then Wait:=Wait+1;
if keydown[downscan] then Wait:=Wait-1;

if keydown[rightscan] then speed:=speed+1;
if keydown[leftscan] then speed:=speed-1;


if Wait<=0 then Wait:=0;
if n<0 then n:=0;
 if speed<0 then speed:=0;
 if minspeed<=0 then minspeed:=0;


until keydown[escscan];

 


	 setoldkeyint; 
end.
{$N-}
