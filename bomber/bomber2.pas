program BomberMan;
uses fwrite, games,optimer,fwvirt;

{Screen variable type is set in FWRITE.TPU}
 


type Sprite2=array [1..2,1..2] of record
       Character: byte;
       Attribute: byte;
end;

type Sprite4=array [1..2,1..2] of record
       Character: byte;
       Attribute: byte;
end;


type Bomb=Object
    Alive:boolean;
    X,Y,Countdown:integer;
    DieTime:integer;
    Constructor Init(X_,Y_:integer;DieTime_:integer);
    Destructor Done;
    
    procedure Boom; virtual;
    end;



type 
	Bomber=Object
	Alive:boolean;
	X,Y,Xspeed,Yspeed:integer;
    skin:Sprite2;
    haveBombs:byte;
Constructor Init(Alive_:boolean;X_,Y_,Xspeed_,Yspeed_:integer;skin_:Sprite2);
Destructor Done; virtual;

procedure dropBomb; virtual;
procedure Move(dX,dY:integer); virtual;
procedure Render; virtual;
end;

const MAX_BOMBS=1;
var 



DelayCount : Word;
Start, Stop : LongInt;


    Screen:  ScrType absolute $B800:0000;
    RenderScreen:VirtualScrType;
    BomberScreen:VirtualScrType;
    BackScreen:VirtualScrType;
    InterScreen:VirtualScrType;
    
    ControlScreen:ScrType;
    TempScreen:ScrType;
    CollisionScreen:VirtualScrType;
    CameraOffset:integer;
    myBomb:Bomb;
    BOMB_COUNT:byte;
    Counter:longint;
    
    
    mySkin:Sprite2;
    myBomber:Bomber;

Function IntToStr(I : Longint) : String;
 
Var S : String [11];
Begin
 Str(I, S);
 IntToStr:=S;
End;


{CLASS BOMB BEGIN}

constructor Bomb.Init(X_,Y_:integer;DieTime_:integer);
begin
    X:=X_;
    Y:=Y_;
    DieTime:=DieTime_;
   
    Countdown:=5;
    FastWriteVirtual(BackScreen,X,Y,char(9));
    if BOMB_COUNT>MAX_BOMBS then Done;

end;


procedure writeScreen_to_Virtual(offset:integer;var usual:ScrType;var virt:VirtualScrType);
 
 
	var  
		i,j:byte;
	begin

		for i:=1 to high(usual[1]) do Begin
			for j:=1 to high(usual) do begin
			 
	                virt[j,i+offset].Character:=usual[j,i].Character;
					virt[j,i+offset].Attribute:=usual[j,i].Attribute;
					

        end;
            end;

    
    
end;


procedure writeVirtual_to_Screen(offset:integer;virt:VirtualScrType;var usual:ScrType);
 
 
	var  
		i,j:byte;
	begin

		for i:=1 to high(usual[1]) do Begin
			for j:=1 to high(usual) do begin
			 
	                usual[j,i].Character:=virt[j,i+offset].Character;
					usual[j,i].Attribute:=virt[j,i+offset].Attribute;
					

        end;
            end;

    
    
end;

procedure Bomb.Boom;
begin
    
    if (Counter > DieTime) then FastWriteVirtualAttribute(BackScreen,X,Y,3,'Boom!');
     
     if (Counter > DieTime) then FastWriteVirtualAttribute(BackScreen,X,Y,3,'  -  ');
    
    if (Counter > DieTime+1) then FastWriteVirtualAttribute(BackScreen,X,Y,3,' ---  ');

    if (Counter > DieTime+2) then FastWriteVirtualAttribute(BackScreen,X,Y,3,'-----');
    
    if (Counter > DieTime+6) then FastWriteVirtualAttribute(BackScreen,X,Y,3,' --- ');
    
    if (Counter > DieTime+7) then FastWriteVirtualAttribute(BackScreen,X,Y,3,'  - ');

     
     
     
    
    
    if (Counter > DieTime+8) then Done;
    
    
    

end;

Destructor Bomb.Done;
begin
    BOMB_COUNT:=0;
     FastWriteVirtual(BackScreen,X,Y,'      ');
end;
{CLASS BOMB END}

{CLASS BOMBER BEGIN}

constructor Bomber.Init(Alive_:boolean;X_,Y_,Xspeed_,Yspeed_:integer;skin_:Sprite2);
begin

Alive:=Alive_;
 
X:=X_;
Y:=Y_;
Xspeed:=Xspeed_;
Yspeed:=Yspeed_;
skin:=skin_;

 
end;

Destructor Bomber.Done;
begin
 
    
end;

Procedure Bomber.dropBomb;
begin
  
  if (BOMB_COUNT<MAX_BOMBS) then  begin 
            myBomb.init(X,Y,(Counter mod 32000)+40);
            BOMB_COUNT := BOMB_COUNT+1;
            end;
  


end;
Procedure Bomber.Move(dX,dY:integer);
 
begin
   
    
        
    
 {COLLISIONS NO}
    

    X := X+dX;
    if X>high(RenderScreen[1]) then X:=high(RenderScreen[1]);
    if X<2 then X:=2;
    
    Y := Y+dY;
    if Y>high(RenderScreen) then Y:=high(RenderScreen);
    if Y<2 then Y:=2;

    CameraOffset := X-50;
    if CameraOffset < 1 then CameraOffset := 0;
    if CameraOffset > high(RenderScreen[1])-80 then CameraOffset := high(RenderScreen[1])-80;

    

 

 
 
    
    
end;


Procedure Bomber.Render;
begin
    
    BomberScreen[Y,X].Character:=00;
    BomberScreen[Y,X].Attribute:=23;
    BomberScreen[Y,X+1].Character:=00;
    BomberScreen[Y,X+1].Attribute:=23;
   


end;

 
 

{CLASS END}



{ MAIN BODY}
begin

       Start := ReadTimer;
   FillVirtualScreen(BackScreen);

    
 myBomber.Init(TRUE,10,10,1,1,mySkin);


turn_off_cursor;
initnewkeyint;
initnewtimint;



repeat

Stop := ReadTimer;

TopLine(ControlScreen,1,'B0MB3RMAN v. 0.1 // '); ; 
TopLine(ControlScreen,25,'Q - Quit //   '); ;   
 
fastwrite(ControlScreen,3,3,'Counter: ' + IntToStr(Counter));
fastwrite(ControlScreen,3,4,'BOMB_COUNT: ' + IntToStr(BOMB_COUNT));
fastwrite(ControlScreen,3,5,'MAX_BOMBS: ' + IntToStr(ord(Screen[myBomber.X,myBomber.Y].Attribute)));
fastwrite(ControlScreen,3,5,'One tick is  ' + ElapsedTimeString(Start, Stop));
fastwrite(ControlScreen,3,6,'One second ' + SecondIs(Start,Stop));
fastwrite(ControlScreen,3,7,'Ticks to die: ' + IntToStr(2*round(10/ElapsedTime(Start,Stop)))+'    ');
 
 FastWriteVirtual(InterScreen,130,4,'LOL');



myBomber.Render;



 

  if keydown[rightscan] then myBomber.Move(1,0);
  if keydown[leftscan] then myBomber.Move(-1,0);
  if keydown[upscan] then myBomber.Move(0,-1);

  if keydown[downscan] then myBomber.Move(0,1);
  if keydown[spacescan] then myBomber.dropBomb;

  if keydown[entscan] then CameraOffset:=CameraOffset+1;
  
  
  
 
 { MERGE ALL SCREENS}
    
Start := ReadTimer;

    RenderScreen:=BackScreen;
    writeScreen_to_Virtual(CameraOffset,ControlScreen,InterScreen);
    MergeVirtualScreens(InterScreen,RenderScreen);
    MergeVirtualScreens(BomberScreen,RenderScreen);
    
    writeVirtual_to_Screen(CameraOffset,RenderScreen,TempScreen);

    Screen := TempScreen;
     
    { MergeVirtualScreens(ControlScreen,CollisionScreen);} 
   
     if myBomb.X>0 then myBomb.Boom;

   
    Counter := Counter + 1;
   
     

     
   

    ClearAreaX1Y2VirtualScreen(myBomber.X-1,myBomber.Y-1,myBomber.X+2,myBomber.Y+2,BomberScreen); 
  

   
until keydown[escscan] or keydown[$10];   {Q} 

myBomber.Done;
	  
setoldkeyint; 
setoldtimint;
turn_on_cursor;
	 

end.

