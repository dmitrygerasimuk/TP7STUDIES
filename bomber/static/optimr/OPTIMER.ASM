cli             ;Disable interrupts
mov  dx,$20     ;Address PIC ocw3
mov  al,$0A     ;Ask to read irr
out  dx,al
mov  al,$00     ;Latch timer 0
out  $43,al
in   al,dx      ;Read irr
mov  di,ax      ;Save it in DI
in   al,$40     ;Counter --> bx
mov  bl,al      ;LSB in BL
in   al,$40
mov  bh,al      ;MSB in BH
not  bx         ;Need ascending counter
in   al,$21     ;Read PIC imr
mov  si,ax      ;Save it in SI
mov  al,$0FF    ;Mask all interrupts
out  $21,al
mov  ax,$40     ;read low word of time
mov  es,ax      ;from BIOS data area
es:
mov  dx,[$6C]
mov  ax,si      ;Restore imr from SI
out  $21,al
sti             ;Enable interrupts
mov  ax,di      ;Retrieve old irr
test al,$01     ;Counter hit 0?
jz   done       ;Jump if not
cmp  bx,$FF     ;Counter > $FF?
ja   done       ;Done if so
inc  dx         ;Else count int req.
done:
mov [bp-4],bx   ;set function result
mov [bp-2],dx
