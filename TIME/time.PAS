uses Dos,Crt;
const
  days : array [0..6] of String[9] =
    ('Sunday','Monday','Tuesday',
     'Wednesday','Thursday','Friday',
     'Saturday');
  timeout = 5;
var
  y,ma,d,dow,h, m, s, s100, s1, y_old, ma_old, d_old, dow_old : word;
  fir:text;
  Ch:char;
  xx, yy : word;
  check_tm : boolean;

procedure  ShowDate(y, m, d, dow : word);
begin
  TextColor(lightgreen);
  write( days[dow],', ');
  TextColor(yellow);
  write(  d:0, '/', m:0, '/', y:0,'   ');
  TextColor(black);
  write(' ');
  GoToXY(WhereX - 1, WhereY);
end;

begin
  writeln;
  writeln('Enter  go, '#$1a' inc day, '#$1b' dec day, '#$18,
          ' inc month, '#$19' dec month');
  writeln('Esc exit without saving, gray + dec year, gray - inc year');
  {$I-}
  assign (fir,'clock.txt');
  reset (fir);
  if IoResult <> 0 then begin
                          y := 1994;
                          ma := 1;
                          d := 1;
                        end
  else begin
         readln (fir,d,ma,y);
         close (fir);
       end;
  y_old := y;
  ma_old := ma;
  d_old := d;
  SetDate (y,ma,d);
  GetDate(y,ma,d,dow);
  dow_old := dow;
  Write('Today is ');
  xx := WhereX;
  yy := WhereY;
  ShowDate(y, ma, d, dow);

  GetTime(h, m, s, s100);
  check_tm := true;

  while true do
   begin
     if  check_tm  then
     begin
          while not KeyPressed do
          begin
               GetTime(h, m, s1, s100);
               if  s1-s mod 60 = timeout  then  break;

          end;
          if not KeyPressed  then break;
     end;
     Ch := ReadKey;
     case Ch of
       #13 : break;
       #27 : begin
                  GoToXY(xx,yy);
                  ShowDate(y_old, ma_old, d_old, dow_old);
                  TextColor(LightGray);
                  writeln;
                  SetDate(y_old, ma_old, d_old);
                  Halt(0);
              end;
       '+' : begin
                 y := y + 1;
                 check_tm := false;
             end;
       '-' : begin
                 y := y - 1;
                 check_tm := false;
              end;
       #0  :  begin
                Ch := ReadKey;
                case Ch of
                  #77 : begin
                             if d < 31 then d := d + 1;
                             check_tm := false;
                        end;
                  #75 : begin
                             if d > 1 then d := d - 1;
                             check_tm := false;
                        end;
                  #72 : begin
                             if ma < 12 then ma := ma + 1;
                             check_tm := false;
                        end;
                  #80 : begin
                             if ma > 1 then ma := ma - 1;
                             check_tm := false;
                        end;
                end;
              end;
     end;
     GoToXY(xx,yy);
     SetDate (y,ma,d);
     GetDate(y,ma,d,dow);
     ShowDate(y, ma, d, dow);
   end;
   SetDate(y,ma,d);
   assign(fir,'clock.txt');
   rewrite(fir);
   writeln(fir,d,' ',ma,' ',y);
   close(fir);
   TextColor(LightGray);
   writeln;
end.