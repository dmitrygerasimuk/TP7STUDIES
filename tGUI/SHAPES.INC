{ Some useful pointer shapes - not state-of-the-art, but looks almost alike
  objects they represent :) }

const


	SandClockANDMask : array[0..15] of Byte = ($FF,$00,$00,$81,$81,$81,$81,$C3,$C3,$81,$81,$81,$81,$00,$FF,$FF);
	SandClockORMask  : array[0..15] of Byte = ($00,$00,$FF,$42,$42,$7E,$7E,$3C,$24,$42,$5A,$7E,$7E,$FF,$00,$00);

	ClockANDMask	 : array[0..15] of Byte = ($FF,$FF,$00,$00,$00,$00,$00,$00,$00,$7E,$00,$00,$FF,$FF,$FF,$FF);
	ClockORMask	 : array[0..15] of Byte = ($00,$00,$00,$FF,$C3,$81,$9D,$91,$E3,$3C,$FF,$00,$00,$00,$00,$00);

