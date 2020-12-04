{    dos text render test  
}
      uses crt, dos,games;

 
type ScrType=array [1..25,1..80] of record
       Character: byte;
       Attribute: byte;
     end;


Type 
  Playertype = Record
    X,Y: byte;
    oldX,oldY:byte;
    Boost:byte;
    VelocityX,VelocityY:integer;
    onGround:boolean;
    groundlineY:byte;
    alive:boolean;
    tick:byte;
    ticklimit:byte;
    lock:boolean;
    scrollcounter:integer;
    end;



 var
 gravity:byte;
  Bomb: Playertype;
  Player: Playertype;
  Screen:  ScrType absolute $B800:0000;
  Oldscreen: ScrType;
  Shift,colorChange,colorNum,i,j:byte;


Function IntToStr(I : Longint) : String;
{ Преобразовывает значение типа Integer в строку }
Var S : String [11];
Begin
 Str(I, S);
 IntToStr:=S;
End;

procedure WaitRetrace(i:byte);
  begin
    for i:=0 to i do begin

 while (port[$3da] and 8) <> 0 do;   
 while (port[$3da] and 8) = 0 do;
 end;
 end;

procedure CheckCollision;
  
  var oldgroundline,i,j:byte;
  begin
  screen[2,2].Character:=01;
    
    oldgroundline:=PLayer.groundLineY;
     
        for i:=Player.Y to 24 do begin
      
        
    case (screen[i+1,Player.X].Attribute)  of
    { check for attributes on the screen and find a new groundline, also print what we found in [2,2]}
                 6: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          5: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
             4: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          3: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
          2: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          10: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
               9: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
          
          
        end;


    case (screen[i+1,Player.X+1].Attribute)  of
    { check for attributes on the screen and find a new groundline, also print what we found in [2,2]}
                 6: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          5: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
             4: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          3: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
          2: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end; 
          10: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
               9: begin  Player.groundlineY:=i;  screen[2,2].Character:=screen[i+1,Player.X].Character; break; end;  
          
          
        end;
  {  case (screen[i,Player.X].Character)  of
          82: begin  Player.groundlineY:=i-1;  screen[2,2].Character:=82; break; end; 
          219: begin  Player.groundlineY:=i-1;  screen[2,2].Character:=219; break; end;  
         
       
           
      end;}
      if not (Player.groundlineY = oldgroundline) then break;
    



      { if nothing found than it's floor}
     { if  (Player.groundLineY = 23) then Player.groundLiney:=oldgroundline else Player.groundlineY:=23;
    }
    end;
   
end;


procedure ScrollDown;
    var x,y:byte;

    begin
        for x:=1 to 79 do begin
          for y:=2 to 25 do begin
            OldScreen[y,x].Character:= OldScreen[y+1,x].Character;
             OldScreen[y,x].Attribute:= OldScreen[y+1,x].Attribute;
          end;
        end;
    end;

    procedure ScrollUp;
    var x,y:byte;

    begin
        for x:=1 to 79 do begin
          for y:=25 downto 2 do begin
            OldScreen[y,x].Character:= OldScreen[y-1,x].Character;
             OldScreen[y,x].Attribute:= OldScreen[y-1,x].Attribute;
          end;
        end;
    end;
procedure ThrowBomb;
    begin
        if not (Bomb.alive) then Bomb.tick:=0;
        Bomb.tick:=Bomb.tick+1;
        Bomb.alive :=TRUE;
              if (Bomb.onGround)  then begin

             Screen[3,3].Character := 83;
              Screen[3,3].Attribute := 2 ;
            
              Bomb.VelocityY := Bomb.VelocityY-5;
              Bomb.onGround:=FALSE;

    end;
  end;


procedure ThrowBombDown;
  begin
      if Bomb.VelocityY < -1 then begin 
      

                  Bomb.VelocityY := -1;
                
                  end;


    end;

procedure StartJump;


    begin

      if Player.onGround then begin
          Player.VelocityY := Player.VelocityY-5;
      
          
          Player.onGround := FALSE;
          end;
      end;

procedure EndJump;

    begin
      if Player.VelocityY < -1 then begin 
      

                  Player.VelocityY := -1;
                
                  end;


    end;



procedure Update;
  begin
   
     
    Bomb.VelocityY := Bomb.VelocityY + 1;
    Player.VelocityY := Player.VelocityY + 1; {gravity}
   
    Bomb.Y := Bomb.Y + Bomb.VelocityY;
    Player.Y := Player.Y + Player.VelocityY;


      if Bomb.tick<Bomb.ticklimit then Bomb.X:=Bomb.X + Bomb.VelocityX;
      Bomb.VelocityX := Bomb.VelocityX -1;
      if Bomb.VelocityX <= 0 then Bomb.VelocityX:=0;

        if Player.VelocityX > 2 then Player.VelocityX:=2;
    if Player.VelocityX < -2 then Player.VelocityX:=-2;
    Player.X := Player.X + Player.VelocityX;
      if Player.X > 50 then  begin

            {  if not Player.onGround then begin 
                      Player.VelocityX:=Player.VelocityX*(-1);
                       Player.X := Player.X + Player.VelocityX;
                      end;}

            if not Player.onGround or Player.onGround then begin 
                Player.VelocityX:=0;
                Player.X := 50;
            End;
          end;


      if Player.X < 10 then begin

            if not Player.onGround then begin 
                      Player.VelocityX:=Player.VelocityX*(-1);
                       Player.X := Player.X + Player.VelocityX;
                      end;

            if Player.onGround then begin 
                Player.VelocityX:=0;
                Player.X := 10;
            End;
          end;


      if Player.Y >= Player.groundlineY then begin
      Player.Y := Player.groundlineY;
        Player.VelocityY:=0;
        Player.onGround := TRUE;
      end;

if Player.Y <= 1 then begin
      Player.Y := 1;
      Player.VelocityY:=0;
      end;

      if Bomb.Y <= 1 then begin
      Bomb.Y := 1;
     
      end;



       if Bomb.Y > Bomb.groundlineY then begin
      Bomb.Y := Bomb.groundlineY;
        Bomb.VelocityY:=0;
        Bomb.onGround := TRUE;
      end;

  end;


procedure ScrollForward;
    var x,y:byte;

    begin
    Player.scrollcounter:=Player.scrollcounter + 1;

        for x:=1 to 79 do begin
          for y:=1 to 25 do begin
            OldScreen[y,x].Character:= OldScreen[y,x+1].Character;
             OldScreen[y,x].Attribute:= OldScreen[y,x+1].Attribute;
          end;
        end;
    end;

procedure ScrollBackward;
    var x,y:byte;

    begin
      Player.scrollcounter:=Player.scrollcounter - 1;
        for x:=79 downto 1 do begin
          for y:=1 to 25 do begin
              OldScreen[y,x].Attribute:= OldScreen[y,x-1].Attribute;
            OldScreen[y,x].Character:= OldScreen[y,x-1].Character;
         
          end;
        end;
    end;



procedure renderBomb;
    var color,i:integer;
    begin
    randomize;
    if Bomb.alive then Bomb.tick:=Bomb.tick+1;
      if Bomb.tick >= Bomb.ticklimit then begin
  color:=3;
            for i:=-5 to 5 do begin
            if Bomb.X+i>79 then Bomb.X:=79-i;   { no fucking with right corner}


                Screen[Bomb.Y,Bomb.X+i].Character := 254;
                  Screen[Bomb.Y,Bomb.X+i].Attribute := color;
                   OldScreen[Bomb.Y,Bomb.X+i].Character := 254;
                  OldScreen[Bomb.Y,Bomb.X+i].Attribute :=color;
              end;

                  Bomb.tick:=0;
                  Bomb.alive:=false;
        end;
    end;

 
              
procedure FastWrite(X,Y:byte;Str:string);
  var i,j:byte;
  begin
    for i:=1 to ord(Str[0]) do begin
         Screen[Y,X+i-1].Character:=ord(Str[i]);
         Screen[Y,X+i-1].Attribute:=2;
          OldScreen[Y,X+i-1].Character:=ord(Str[i]);
         OldScreen[Y,X+i-1].Attribute:=2;
  end;
end;


procedure DrawBomb;
begin
if Bomb.alive then begin

if (Bomb.X <> Bomb.oldX) or (Bomb.Y <> Bomb.oldY) then begin
        Screen[Bomb.oldY,Bomb.oldX].Character := OldScreen[Bomb.oldY,Bomb.oldX].Character;
        Screen[Bomb.oldY,Bomb.oldX].Attribute :=  OldScreen[Bomb.oldY,Bomb.oldX].Attribute ;
end;

      Screen[Bomb.Y,Bomb.X].Character := 205;
      Screen[Bomb.Y,Bomb.X].Attribute :=4 ;
 
      Bomb.oldX:=Bomb.X;
      Bomb.oldY:=Bomb.Y;
     
      if  Bomb.Y=Bomb.groundlineY then begin 
           OldScreen[Bomb.Y,Bomb.X].Character := 205;
          OldScreen[Bomb.Y,Bomb.X].Attribute :=4 ;
          Bomb.tick:=Bomb.ticklimit;
          Bomb.alive:=FAlSE;
        end;
  end;


end;
procedure DrawPlayer;
     var x,y:byte;
    begin
     
        {
        for x:=1 to 80 do begin
          for y:=1 to 25 do begin
            Screen
          end;
        end;
    end;}
  

      
      
      if (Player.X <> Player.oldX) or (Player.Y <> Player.oldY) then begin
       

        Screen[Player.oldY,Player.oldX].Character := OldScreen[Player.oldY,Player.oldX].Character;
        Screen[Player.oldY,Player.oldX].Attribute :=  OldScreen[Player.oldY,Player.oldX].Attribute ;
       Screen[Player.oldY,Player.oldX+1].Character := OldScreen[Player.oldY,Player.oldX+1].Character;
        Screen[Player.oldY,Player.oldX+1].Attribute := OldScreen[Player.oldY,Player.oldX+1].Attribute;


      end;
     
     

      Screen[Player.Y,Player.X].Character := 178;
      Screen[Player.Y,Player.X].Attribute := 3 ;

      Screen[Player.Y,Player.X+1].Character := 178;
      Screen[Player.Y,Player.X+1].Attribute := 3 ;
      Player.oldX:=Player.X;
      Player.oldY:=Player.Y;
    end;

Procedure DrawStatus;
    var s:string;
    i:byte;
    begin
        s:=inttostr(Player.scrollcounter);

        for i:=1 to ord(s[0]) do begin
          Screen[5,5+i-1].Character:=ord(s[i]);
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

    procedure AsciiTable;
        var i : Byte;
        begin
             clrscr;
             for i:=1 to 255 do
             begin
                  write(i,'=',chr(i),' ');
             end;
             readkey;
        end;







procedure DrawFloor;
    var ditch,i,floorY:byte;
    begin
      floorY:=24;
       
      ditch:=30;

      for i:=1 to ditch do 
        begin
          screen[floorY,i].Character:=219;
          screen[floorY,i].Attribute:=3;
             oldscreen[floorY,i].Character:=219;
          oldscreen[floorY,i].Attribute:=3;
        end;


        for i:=ditch to ditch+4 do 
         begin
          screen[floorY,i].Character:=219;
          screen[floorY,i].Attribute:=3;
             oldscreen[floorY,i].Character:=219;
          oldscreen[floorY,i].Attribute:=3;
        end;

        for i:=ditch+4 to 79 do 
          begin
          screen[floorY,i].Character:=219;
          screen[floorY,i].Attribute:=3;
             oldscreen[floorY,i].Character:=219;
          oldscreen[floorY,i].Attribute:=3;
        end;



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

 procedure writechar(x,y : byte; c :byte; b:byte);
begin
   
  mem[$b800: (y-1)*80*2 + (x-1)*2] := c;
  mem[$b800: (y-1)*80*2 + (x-1)*2 + 1] := b;
end;
{ --------------------------------------------------------------------------------------------
{ --------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
}
begin
 {  AsciiTable;
}
 
Bomb.ticklimit:=8;

OldScreen:=Screen;
turn_off_cursor;
initnewtimint;
initnewkeyint;
tickwait(0);

 
 {
for i:=0 to 15 do begin
   
    SetColor(i,0,0,i*7)
end;

SetColor(0,0,0,0);


for i:=1 to 80 do begin
    for j:=1 to 25 do begin

        writechar(i,j,177, colorNum);
        colorNum:=colorNum+1;
        if colorNum>15 then colorNum:=0;
    end
  end;
}
Player.X:=40;
  Bomb.groundlineY:=23;
Player.Y := 5;

repeat 
DrawFloor;
 
 
if (keydown[spacescan]) and (Bomb.tick=0) and (Bomb.lock=FALSE) then begin
          
        
          Bomb.Y:=Player.Y-1;
          Bomb.X:=Player.X;
          if (Player.VelocityX<0) or (Player.X < 20) then Bomb.VelocityX:=-5 else 
          if (Player.VelocityX>0) or (Player.X > 40) then Bomb.VelocityX:=5 else
          Bomb.VelocityX:=0;
           
          
          
          Bomb.lock:=TRUE;
       ThrowBomb;

end;

if not keydown[spacescan] then begin 

  ThrowBombDown;
  Bomb.lock:=FALSE;
  end;


if keydown[rightscan] then begin
          Screen[3,3].Character := 83;
  Screen[3,3].Attribute := 2 ;
   Player.VelocityX := Player.VelocityX+1;
 end;

  if not (keydown[rightscan]) and not (keydown[leftscan]) then begin
  
   Player.VelocityX := 0;

  end;



if keydown[leftscan] then begin
  Player.VelocityX := Player.VelocityX-1;

  end;
if (keydown[upscan]) and (Player.lock=FALSE) then begin StartJump; Player.lock:=TRUE; end;
if not keydown[upscan] then begin  EndJump; Player.lock:=FALSE; end;
  

 if (Player.X > 40) and (keydown[rightscan]) then ScrollForward;
 if (Player.X < 20) and (keydown[leftscan]) then ScrollBackward;
  
 

 

 
   Screen:=OldScreen;

CheckCollision;
     
     DrawPlayer;
 RenderBomb;
 DrawBomb;
 DrawStatus;
Update;
screen[4,4].Character:= Bomb.tick+48; {make me some ascii }
  
    
    Player.Boost:=1;

  {  tickwait(1);  }  {actually }
   Player.lock:=FALSE;

 


 WaitRetrace(3);



 

until keydown[escscan];

   

 setoldtimint;
 setoldkeyint;    
turn_on_cursor;
{RestorePallete;
 }
end.
