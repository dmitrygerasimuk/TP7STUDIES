program tGUI;

uses l_Mouse,fwrite,games,fwVirt;

var     Screen:  ScrType absolute $B800:0000;
        VirtualRenderScreen:VirtualScrType;
        ActualRenderScreen:ScrType;
        CameraOffset:integer;
        Counter:longint;




begin
        

mouseon;
turn_off_cursor;
initnewkeyint;
initnewtimint;



    
    TopLine( Screen,25,'Q - Quit //   '); ;   
    TopLine( Screen,1,'Sceleton app');

repeat 
    
    

    TopLine( Screen,3,intToStr(mousebuff.x));
    
    
  
     
    Retrace; Retrace; Retrace; 

  
    Counter:=Counter+1;

until keydown[escscan] or keydown[$10];   {Q} 



	  
setoldkeyint; 
setoldtimint;
turn_on_cursor;
	 


end.