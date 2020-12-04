program skeleton;

uses fwrite,games,fwVirt;

var     Screen:  ScrType absolute $B800:0000;
        VirtualRenderScreen:VirtualScrType;
        ActualRenderScreen:ScrType;
        CameraOffset:integer;
        Counter:longint;




begin
        


turn_off_cursor;
initnewkeyint;
initnewtimint;



   

repeat 

    


    
     
    TopLine(ActualRenderScreen,25,'Q - Quit //   '); ;   
    TopLine(ActualRenderScreen,1,'Sceleton app');

     
    Retrace; Retrace; 

    Screen := ActualRenderScreen;
    Counter:=Counter+1;

until keydown[escscan] or keydown[$10];   {Q} 



	  
setoldkeyint; 
setoldtimint;
turn_on_cursor;
	 


end.