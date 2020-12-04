uses vga2,func,crt;
var t:word;
 pic:spritetype;
begin
 initvga;randomize;
 cls(1);
 loadpal(rgb256,'colors.pal');
 setpal(rgb256);
 loadsprite(pic,'tower');
 putRLE(pic,1,1);
 putRLE(pic,200,1);
 loadfont('font2.fn');
 print_f(100,10,'1234567890 FONT2.FN',true);
 loadfont('font1.fn');
 print_f(100,23,'1234567890 Font1.FN',true);
 print(100,38,15,'1234567890 Normal Font',true);
 loadfont('font2.fn');
 for t := 154 downto 138 do
 begin
  print_fc(60,100,t,'MAKE YOUR OWN FONTS WITH FONT.EXE!!',true);
  delay(50);
 end;
 wait;
end.