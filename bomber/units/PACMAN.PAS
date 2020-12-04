uses
  crt,dos;
const
  HAAMU  = $0E04;
  PACMAN = $0301;
  SPACE  = $0320;
  ESINE  = $03F9;
  BLOCKED= $00FF;
  DEADPAC= $8D05;
  MUUATR = 4;

type
  str80 = string[80];

var
  pl : array[1..25,1..80] of word absolute $b800:0000;
  x, y, ye, xe, ty, tx, pacsuunta, pacnewsuunta:byte;
  points, maxpoints:word;
  merkki:char;
  game_over:boolean;
  clktck:pointer;
  entinen: array[1..4] of word;
  hy,hx,suunta: array[1..4] of byte;

procedure haamut;interrupt;
var
  n, news, dummy, tulosuunta:byte;
  ac : array[0..3] of boolean;
label
  yli;
begin
  { p„ivit„ kaikki haamut }
  for n:= 1 to 4 do begin
    { pist„ edellinen merkki taulukkoon }
    pl[hy[n],hx[n]]:=entinen[n];
    case suunta[n] of
      0 : tulosuunta:=1;
      1 : tulosuunta:=0;
      2 : tulosuunta:=3;
      3 : tulosuunta:=2;
    end;
    { tarkista kaikki muut suunnat paitsi se mist„ TULTIIN }
    suunta[n]:=5;
    for dummy:=0 to 3 do
      ac[dummy]:=false;

    { ensimm„inen suunta kohti PACMANIA }
    if hy[n]<y then { suunta alas }
      news:=1
    else
      news:=0;
    if hx[n]>x then { suunta vasemmalle }
      news:=3
    else
      news:=2;
    case news of
      0 : if hi(pl[hy[n]-1,hx[n]])= 3 then suunta[n]:=news;
      1 : if hi(pl[hy[n]+1,hx[n]])= 3 then suunta[n]:=news;
      2 : if hi(pl[hy[n],hx[n]+1])= 3 then suunta[n]:=news;
      3 : if hi(pl[hy[n],hx[n]-1])= 3 then suunta[n]:=news;
    end;
    if (suunta[n]<5) and (news<>tulosuunta) then
      goto yli;

    repeat
      news:=random(4);
      ac[news]:=true;
      if news<>tulosuunta then
        case news of
          0 : if hi(pl[hy[n]-1,hx[n]])= 3 then suunta[n]:=news;
          1 : if hi(pl[hy[n]+1,hx[n]])= 3 then suunta[n]:=news;
          2 : if hi(pl[hy[n],hx[n]+1])= 3 then suunta[n]:=news;
          3 : if hi(pl[hy[n],hx[n]-1])= 3 then suunta[n]:=news;
        end;
    until ac[0] and ac[1] and ac[2] and ac[3];
    { k„„nny takaisin jos ei muuta suuntaa l”ytynyt}
    if suunta[n]=5 then
      suunta[n]:=tulosuunta;
yli:
    { mene minne suunta m„„r„„ }
    case suunta[n] of
      0 : dec(hy[n]);
      1 : inc(hy[n]);
      2 : inc(hx[n]);
      3 : dec(hx[n]);
    end;

    { on siirrytty uuteen ruutuun joka on sallittu !!}
    if pl[hy[n],hx[n]] = PACMAN then
      game_over:=true;
    entinen[n]:=pl[hy[n],hx[n]];
    pl[hy[n],hx[n]]:=HAAMU;
  end; { for }
end; { interrupt }

procedure loadpl(fn:str80);
label
  loppu;
var
  l,k,hn : byte;
  source : text;
  line   : str80;
begin
  hn:=1;
  x:=1;
  y:=1;
  maxpoints:=0;
  {t„yt„ tyhj„ll„}
  for k:=1 to 25 do
    for l:=1 to 80 do
      pl[k,l]:=BLOCKED;

  assign(source,fn);
  reset(source);
  for l:=1 to 25 do begin
    if eof(source) then goto loppu;
    readln(source,line);
    for k:=1 to length(line) do
      case upcase(line[k]) of
        ' ' : pl[l,k]:=BLOCKED;
        'ù' : begin inc(maxpoints);pl[l,k]:=ESINE end;
        '-' : pl[l,k]:=SPACE;
        'P' : begin pl[l,k]:=PACMAN;y:=l;x:=k end;
        'H' : begin
                pl[l,k]:=HAAMU;
                hy[hn]:=l;
                hx[hn]:=k;
                entinen[hn]:=SPACE;
                inc(hn);
              end;
        else  pl[l,k]:= (MUUATR shl 8) + ord(line[k]);
      end;
  end;
loppu:
  close(source);
  ty:=y;
  tx:=x;
end;
{
procedure graceful_death;
begin
   setintvec($1c,clktck);
end;
}
procedure game;
begin
  loadpl('PACMAN1.DAT');
  game_over:=false;
  pacsuunta:=0;
  pacnewsuunta:=0;
  points:=0;
  textattr:=brown;
  gotoxy(4,25);
  write('READY !!!');
  repeat until keypressed;
  gotoxy(4,25);
  write('Points: 0');

  setintvec($1c,@haamut);
  repeat
    if keypressed then begin
      merkki:=readkey;
      if merkki=#0 then
        merkki:=readkey;
	case merkki of
	  'G' : pacnewsuunta:=0; {home}
	  'H' : pacnewsuunta:=1; {yl”s}
	  'P' : pacnewsuunta:=2; {alas}
	  'M' : pacnewsuunta:=3; {oik}
	  'K' : pacnewsuunta:=4; {vas}
	  'D' : game_over:=true; {F10}
	end;
    end;
    ye:=y;
    xe:=x;
    ty:=y;
    tx:=x;
    case pacnewsuunta of
      1 : dec(ty);
      2 : inc(ty);
      3 : inc(tx);
      4 : dec(tx);
    end;
    if (pl[ty,tx]=SPACE) or (pl[ty,tx]=ESINE) then
      pacsuunta:=pacnewsuunta;
    if pacnewsuunta=0 then
      pacsuunta:=0;
    case pacsuunta of
      1 : dec(y);
      2 : inc(y);
      3 : inc(x);
      4 : dec(x);
    end;

    case pl[y,x] of
      ESINE : begin
                inc(points);
		if points=maxpoints then
		  game_over:=true;
		gotoxy(12,25);
		write(points);
              end;
      SPACE :;
      else begin
             y:=ye;
	     x:=xe;
           end;
    end;
    pl[ye,xe]:=SPACE;
    pl[y,x]:=PACMAN;
    delay(50);
  until game_over;

  setintvec($1c,clktck);
  pl[y,x]:=DEADPAC;
end;

begin
  randomize;
  getintvec($1c,clktck);
{	exitproc:=@graceful_death;}
  repeat
    game;
    gotoxy(40,25);
    write('New game (Y/N) ?');
    repeat
      merkki:=readkey;
    until upcase(merkki) in ['Y','N'];
  until upcase(merkki) = 'N';
  clrscr;
{  setintvec($1c,clktck);}

end.