uses vga2,func,crt;
var t,x,y:integer;
 ch:char;
 pic:array[1..2] of spritetype;
begin
 initvga;randomize;
 use(virt);
 loadpal(rgb256,'colors.pal');
 setpal(rgb256);
 loadsprite(pic[1],'sword');
 loadsprite(pic[2],'tower');
 loadfont('font2.fn');
 cls(2);
 t := random(2)+1;
 x:=100;Y:=100;
 print_fc(71,101,8,'THIS IS JUST A CLIPPING DEMO',true);
 print_f(70,100,'THIS IS JUST A CLIPPING DEMO',true);
 putRLE_c(pic[t],x,y);
 print(70,1,15,'Move with arrow keys',true);
 flip;
 repeat
  ch := readkey;
  if ch = 'M' then begin
   cls(2);
   inc(x);
   print_fc(71,101,8,'THIS IS JUST A CLIPPING DEMO',true);
   print_fc(70,100,15,'THIS IS JUST A CLIPPING DEMO',true);
   putRLE_c(pic[t],x,y);
   print(70,1,15,'Move with arrow keys',true);
   flip;
  end;
   if ch = 'K' then begin
   cls(2);
   dec(x);
   print_fc(71,101,8,'THIS IS JUST A CLIPPING DEMO',true);
   print_fc(70,100,15,'THIS IS JUST A CLIPPING DEMO',true);
   putRLE_c(pic[t],x,y);
   print(70,1,15,'Move with arrow keys',true);
   flip;
  end;
  if ch = 'P' then begin
   cls(2);
   inc(y);
   print_fc(71,101,8,'THIS IS JUST A CLIPPING DEMO',true);
   print_fc(70,100,15,'THIS IS JUST A CLIPPING DEMO',true);
   putRLE_c(pic[t],x,y);
   print(70,1,15,'Move with arrow keys',true);
   flip;
  end;
  if ch = 'H' then begin
   cls(2);
   dec(y);
   print_fc(71,101,8,'THIS IS JUST A CLIPPING DEMO',true);
   print_f(70,100,'THIS IS JUST A CLIPPING DEMO',true);
   putRLE_c(pic[t],x,y);
   print(70,1,15,'Move with arrow keys',true);
   flip;
  end;
 until ch = chr(13);
end.