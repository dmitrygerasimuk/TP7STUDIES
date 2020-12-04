{$F+}
unit fwVirt;

interface

uses fwrite;
 { SET THE SIZES}
const YMAX=25;
const XMAX=160;


type VirtualScrType=array [1..YMAX,1..XMAX] of record
       Character: byte;
       Attribute: byte;
     end;
     

 
 
procedure FastWriteVirtual (var Screen:VirtualScrType;X,Y:byte;Str:string);
procedure MergeVirtualScreens(var FrontScreen,BackScreen:VirtualScrType);
procedure ClearVirtualScreen(var ScreenRef:VirtualScrType);
procedure ClearAreaX1Y2VirtualScreen(X1,Y1,X2,Y2:integer;var ScreenRef:VirtualScrType); 
procedure FillVirtualScreen(var ScreenRef:VirtualScrType);
procedure FastWriteVirtualAttribute (var Screen:VirtualScrType;X,Y,Attr:byte;Str:string);
procedure writeVirtualtoScreenYX(offsetY,offsetX:integer;virt:VirtualScrType;var usual:ScrType);
 

implementation


procedure writeVirtualtoScreenYX(offsetY,offsetX:integer;virt:VirtualScrType;var usual:ScrType);
 
 
	var  
		i,j:byte;
	begin

		for i:=1 to high(usual[1]) do Begin
			for j:=1 to high(usual) do begin
			 
	                usual[j,i].Character:=virt[j+offsetY,i+offsetX].Character;
					usual[j,i].Attribute:=virt[j+offsetY,i+offsetX].Attribute;
					

        end;
            end;

    
    
end;

procedure ClearVirtualScreen(var ScreenRef:VirtualScrType); 
    var 
        i,j:byte;
    begin
        for i:=1 to high(ScreenRef[1]) do Begin {160}
			for j:=1 to high(ScreenRef) do begin {25}
				  	 
				  

					ScreenRef[j,i].Character:= 32;
					ScreenRef[j,i].Attribute:= 0;
					
 
			end;
		end;

 

    end;

   procedure ClearAreaX1Y2VirtualScreen(X1,Y1,X2,Y2:integer;var ScreenRef:VirtualScrType); 
    var 
        i,j:byte;
    begin
    
    if (X2 < 0 ) then X2 := 0;
    if (X1 < 0 ) then X1 := 0;
    if (X2 > high(ScreenRef[1]) ) then X2 := high(ScreenRef[1]);
    if (X1 > high(ScreenRef[1]) ) then X1 := high(ScreenRef[1]);

    if (Y2 < 0 ) then Y2 := 0;
    if (Y1 < 0 ) then Y1 := 0;
    if (Y2 > high(ScreenRef) ) then Y2 := high(ScreenRef);
    if (Y1 > high(ScreenRef) ) then Y1 := high(ScreenRef);
    
    
    
        for i:=X1 to X2 do Begin {160}
			for j:=Y1 to Y2 do begin {25}
				  	 
				  

					ScreenRef[j,i].Character:= 32;
					ScreenRef[j,i].Attribute:= 0;
					
 
			end;
		end;

 

    end;

     procedure FillVirtualScreen(var ScreenRef:VirtualScrType); 
    var 
        i,j:byte;
    begin
        randomize;
        for i:=1 to high(ScreenRef[1]) do Begin
			for j:=1 to high(ScreenRef) do begin
				  	 
				  
               
				
                   ScreenRef[j,i].Character:=random(200)+1;
					ScreenRef[j,i].Attribute:= 1;
					
 
			end;
		end;

 

    end;
procedure MergeVirtualScreens(var FrontScreen,BackScreen:VirtualScrType);
	var  
		i,j:byte;
	begin

		for i:=1 to high(FrontScreen[1]) do Begin
			for j:=1 to high(FrontScreen) do begin
				  	 
				  	if (FrontScreen[j,i].Character <> 0 or 32 ) and (FrontScreen[j,i].Attribute <> 0) then begin

					BackScreen[j,i].Character:=FrontScreen[j,i].Character;
					BackScreen[j,i].Attribute:=FrontScreen[j,i].Attribute;
					


					end else
					BackScreen[j,i].Character:=BackScreen[j,i].Character;
					BackScreen[j,i].Attribute:=BackScreen[j,i].Attribute;
			end;
		end;

end;
    
  

  
procedure FastWriteVirtual (var Screen:VirtualScrType;X,Y:byte;Str:string);
  var i,j:byte;
  begin
  if (X< high(Screen[1])) and (Y<high(Screen[1])) then begin
      
  
    for i:=1 to ord(Str[0]) do begin
          Screen[Y,X+i-1].Character:=ord(Str[i]);
          Screen[Y,X+i-1].Attribute:=15;
         
  end;
  end;
end;


procedure FastWriteVirtualAttribute (var Screen:VirtualScrType;X,Y,Attr:byte;Str:string);
  var i,j:byte;
  begin
   if (X< high(Screen[1])) and (Y<high(Screen[1])) then begin
      
  
    for i:=1 to ord(Str[0]) do begin
          Screen[Y,X+i-1].Character:=ord(Str[i]);
          Screen[Y,X+i-1].Attribute:=Attr;
         
  end;
  end;
end;




end.
