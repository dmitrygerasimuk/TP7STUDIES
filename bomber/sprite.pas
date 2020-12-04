program printSprite;

uses games,fwrite; {fwrite for fastwrite, games for kbd interruption vector}

type Sprite=array [1..16,1..16] of record
       Character: byte;
       Attribute: byte;
     end;



var 
Screen:  ScrType absolute $B800:0000;
RenderScreen:ScrType;
mySprites: array [0..10] of Sprite;
frame:integer;
Counter:longint;
smallCounter:integer;
x,y:integer;
w,h:integer;


Procedure IncPos(var incr:integer;limit:integer);
  var a:integer;

 Begin
 	 if incr>=0 then a:=incr+2;
 	if incr<0 then a:=0;
 	incr:=a;

    if incr>limit then incr:=limit;

 end;

  Procedure DecPos(var decr:integer;limit:integer) ;
 Begin
 	if decr>=0 then decr:=decr-2;
 	if decr<0 then decr:=0;
    if decr>limit then decr:=limit;
 end;
 

Function IntToStr(I : Longint) : String;
 
Var S : String [11];
Begin
 Str(I, S);
 IntToStr:=S;
End;


procedure putSpriteDimensions(w,h,x,y:byte; mySprite:Sprite; var Screen:ScrType);
 
	var TempScreen:ScrType;
		i,j:byte;
	begin
 
    x := x mod 80;
    y := y mod 25;
		for i:=1 to w do Begin
			for j:=1 to h do begin


             
                    Screen[y+j,x+i].Character:=mySprite[j,i].Character;
					Screen[y+j,x+i].Attribute:=mySprite[j,i].Attribute;
					
					
			end;
				 
				 
		end;

end;


procedure clearSprite(w,h,x,y:byte; var Screen:ScrType);
		var i,j:byte;
	begin
 
    x := x mod 80;
    y := y mod 25;
		for i:=1 to w do Begin
			for j:=1 to h do begin


             
					
					Screen[y+j,x+i].Character:=0;
					Screen[y+j,x+i].Attribute:=0;


				 
					
					
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


     
      If (EoF(F)) or (i>w*h*2+1) Then Break;
  
   End; {of while}


End;
	{$I-}
Close(F);
{$I+}

	for x:=1 to w do Begin
		for y:=1 to h do begin
		 
			spriteHolder[y-1,x-1].Character:=ord(data[(y-1)*w*2+(x-1)*2+1]);
			spriteHolder[y-1,x-1].Attribute:=ord(data[(y-1)*w*2+(x-1)*2]);;

		 	 

		 end;
	end;

 
End;


begin
turn_off_cursor;
initnewkeyint;
initnewtimint;






loadASCIISpriteDimension(18,13,'s_1.bin',mySprites[0]);
loadASCIISpriteDimension(18,13,'s_1.bin',mySprites[1]);
 

w := 18;    { sprite wei }
h := 13;    { hei}

frame :=0;

x := 33;
y := 4;
repeat
     


    if keydown[spacescan] then  TopLine(RenderScreen,15,'Enter/ESC - toggle Console | Q - quit'); ;
   if keydown[leftscan] then DecPos(x,80-w) ;
     if keydown[rightscan] then IncPos(x,80-w) ;
       if keydown[upscan] then DecPos(y,25-h) ;
         if keydown[downscan] then IncPos(y,25-h) ;
 

    
     putSpriteDimensions(w,h,x,y, mySprites[frame],RenderScreen);

    
    TopLine(RenderScreen,2,'x:'+IntToStr(x)+' y: ' + IntToStr(y) + ' Cnt: '+inttoStr(Counter)+' sCT: '+
                IntToStr(smallCounter));
    TopLine(RenderScreen,1,'Enter/ESC - toggle Console | Q - quit'); 
TopLine(RenderScreen,25,'ESC - quit');
    Screen:=RenderScreen;
    Counter:=Counter+1;
    smallCounter:=smallCounter+1;
   
    if smallCounter > 1000 then smallCounter := 0;
    if frame > 9 then frame := 0;

   
   waitretrace(1);
   clearSprite(w,h,x,y,RenderScreen);
   
until keydown[escscan] or  keydown[$10];   {Q} 


	  
      
      setoldkeyint; 
	  setoldtimint;
	  turn_on_cursor;
	 

end.


