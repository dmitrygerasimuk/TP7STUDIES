{*****************************************************************************}
{*                                                                           *}
{*                               COLLIDE                                     *}
{*                                v 1.0                                      *}
{*                                                                           *}
{*                          (C) 1995 M.Mackey.                               *}
{*                                                                           *}
{*  I present here some sample code for very fast pixel-precision collision  *}
{*  detection. This code should be easy to add to any existing sprite engine *}
{*  that uses bounding-box collision detection. The one limitation is that   *}
{*  sprites are assumed to be of less than 32 pixels in width (although it   *}
{*  would be reasonably easy to extend the code to allow 64-pixel wide       *}
{*  sprites). See the file COLLIDE.DOC for more information.                 *}
{*                                                                           *}
{*                                                                           *}
{*****************************************************************************}

unit collide;

interface
const MaxSpriteHeight=24; {No hard limit: set to whatever your maximum
                           height actually is}
type masktype=array[0..MaxSpriteHeight-1] of longint;
                          {holds the mask}
     maskptr=^masktype;
     longarray=array[1..60000] of byte;
                          {A kludge used for accessing random bytes in
                           dynamically allocated variables}

function CollideBitmaps(mask1:masktype;height1,x1,y1:integer;
                         mask2:masktype;height2,x2,y2:integer):boolean;
procedure MakeMask(var p:longarray;var mask:maskptr);

implementation

{*****************************************************************************
 Function CollideBitmaps(mask1:masktype;height1,x1,y1:integer;
                         mask2:masktype;height2,x2,y2:integer):boolean;

 Checks bitmap collisions.

 Mask1:   The mask for sprite 1
 Height1: The height of sprite 1
 x1, y1:  The screen coordinates of the top left corner of sprite 1
 Mask1:   The mask for sprite 2
 Height1: The height of sprite 2
 x1, y1:  The screen coordinates of the top left corner of sprite 2

 Sprite 1 must be to the left of sprite 2,and the bounding boxes _must_
 have collided
 ie x1<=x2, 0<=(x2-x1)<=31 are assumed, and the y extents of the two
 sprites must overlap.

 Use an initial bounding box check to set this up
 eg (from the XQuest code, assuming short-cut boolean evaluation $B-)

  for i:=NumEnemies downto 1 do
  with enemy[i] do
  begin
    if (xbr>=ship.x) and (ybr>=ship.y) and
       (x<=ship.xbr) and (y<=ship.ybr) then
       if ((ship.x<=x) and
          CollideBitmaps(ship.mask^,ship.height,ship.x,ship.y,mask^,height,x,y))
         or ((x<ship.x) and
          CollideBitmaps(mask^,height,x,y,ship.mask^,ship.height,ship.x,ship.y))
       then they have collided....

    where x and y are the coords of the top left hand corner and xbr and ybr
    the coords of the bottom right hand corner of the sprite.

    Such a bounding box check is very fast, and the more computationally
    expensive mask check is thus called only rarely  (and hence does not
    need to be optimised _too_ much...)

*****************************************************************************}

function CollideBitmaps(mask1:masktype;height1,x1,y1:integer;
                        mask2:masktype;height2,x2,y2:integer):boolean;assembler;
asm
        push    ds
        mov     cx,x2
        sub     cx,x1         {0<=cx<=31, difference in x-coords}

        mov     ax,word ptr [height1]   {loop counter}

        lds     si,mask1
        les     di,mask2      {ds:si and es:di point to the two masks}
        mov     ax,[y2]
        sub     ax,[y1]       {ax is set to the difference in the y coords}
        jl      @Mask2Upper   {which sprite has a lower y coord?}

{Mask 1 uppermost:}
        mov     dx,[height1]
        sub     dx,ax         {# of dwords of overlap of first mask with second}
                              {  ie number of rows to be compared}
        cmp     dx,[height2]  {will this run below the end of the second sprite?}
        jle     @HeightOK1
        mov     dx,[height2]  {Yes, set number of rows to be compared to the height of sprite 2}
@HeightOK1:
        shl     ax,2          {# of dwords to skip in first mask}
        add     si,ax         {si now points to top of overlap of 1st mask
                               with second}

@OverlayLoop:
        db      $66
        mov     ax,word ptr ds:[si]   {mov eax, dword ptr ds:[si]}
                              {Get mask entry for 1st sprite}
        db      $66
        shl     ax,cl         {shl eax, cl}
                              {Shift left by amount of overlap}
        db      66h
        and     ax,word ptr es:[di]   {and eax, dword ptr es:[di]}
                              {Compare with 2nd sprite mask entry}
        jnz     @collision    {If non-zero then the sprites collided}


        add     si,4
        add     di,4          {otherwise, check the next mask entries}
        dec     dx            {Any more rows to be checked?}
        jnz     @overlayloop
        jmp     @nocollision  {No, report no collision}

@Mask2Upper:                  {Mask 2 is uppermost}
        neg     ax
        mov     dx,[height2]
        sub     dx,ax         {# of dwords of overlap of second mask with first}
                              {  ie number of rows to be compared}
        cmp     dx,[height1]  {will this run below the end of the first sprite?}
        jle     @HeightOK2
        mov     dx,[height1]  {Yes, set number of rows to be compared to the height of sprite 1}
@HeightOK2:
        shl     ax,2          {# of dwords to skip in second mask}
        add     di,ax         {di now points to top of overlap of 2nd mask
                               with first}
        jmp     @OverlayLoop

@Collision:
        mov    ax,1           {Yes, collision detected. Return TRUE}
        jmp    @finished

@NoCollision:
        mov    ax,0           {No collision detected, return FALSE}
@finished:
        pop    ds
end;

{*****************************************************************************
procedure MakeMask(var p:longarray;var mask:maskptr);

  Makes a mask for a sprite from a XBM (Xlib linear bitmap).
  Format: height (1 byte)
          width (1 byte)
          bitmap data (width*height bytes)

  p holds a sprite with the above structure
  mask should not be pre-allocated
*****************************************************************************}

procedure makemask(var p:longarray;var mask:maskptr);
var i,j,Height,Width:integer;
const bits:array[0..31] of longint=
  ($8000,$4000,$2000,$1000,$800,$400,$200,$100,$80,$40,$20,$10,$8,$4,$2,$1,
   $80000000,$40000000,$20000000,$10000000,$8000000,$4000000,$2000000,
   $1000000,$800000,$400000,$200000,$100000,$80000,$40000,$20000,$10000);
 {mask for the 32 bits in a dword. Note the word order in a dword on the
  PC!}

begin
  Width:=p[1];
  Height:=p[2];
  getmem(mask,Height*4);   {get memory for mask}
  for i:=0 to (Height-1) do
  begin
    j:=1;
    mask^[i]:=0;
    for j:=1 to Width do
     if (p[i*Width+j+2]<>0) then
        mask^[i]:=mask^[i] or (bits[j]);
  end;
end;

end.
