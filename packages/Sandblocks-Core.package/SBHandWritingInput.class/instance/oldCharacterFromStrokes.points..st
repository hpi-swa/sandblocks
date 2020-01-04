as yet unclassified
oldCharacterFromStrokes: aCollection points: aPointCollection

	aCollection = #(right) ifTrue: [^ Character space].
	aCollection = #(left) ifTrue: [^ Character backspace].
	
	aCollection = #(up down) ifTrue: [^ $A].
	aCollection = #(down up right down left right down left) ifTrue: [^ $B].
	aCollection = #(left down right) ifTrue: [^ $C].
	aCollection = #(down up right down left) ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.7 of: aPointCollection) ifTrue: [$P] ifFalse: [$D]].
	aCollection = #(left down right left down right) ifTrue: [^ $E].
	aCollection = #(left down) ifTrue: [^ $F].
	aCollection = #(left down right up left right) ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.1 of: aPointCollection) ifTrue: [$Q] ifFalse: [$G]].
	aCollection = #(down up right down) ifTrue: [^ $H].
	aCollection = #(down) ifTrue: [^ $I].
	aCollection = #(down left) ifTrue: [^ $J].
	aCollection = #(down left up right down) ifTrue: [^ $K].
	aCollection = #(down right) ifTrue: [
		^ (aPointCollection last y > (self height * 0.6)) ifTrue: [$L] ifFalse: [$4]]. " potentially wonky, maybe relative? "
	aCollection = #(up right down up right down) ifTrue: [^ $M].
	aCollection = #(up right down right up) ifTrue: [^ $N].
	aCollection = #(left down right up left) ifTrue: [^ $O].
	aCollection = #(down up right down left down) ifTrue: [^ $R].
	aCollection = #(left down right down left) ifTrue: [^ $S].
	aCollection = #(right down) ifTrue: [
		^ (self point: aPointCollection last inLeft: 0.7 of: aPointCollection) ifTrue: [$7] ifFalse: [$T]].
	aCollection = #(down right up) ifTrue: [^ $U].
	aCollection = #(down up right) ifTrue: [^ $V].
	aCollection = #(down up down up) ifTrue: [^ $W].
	aCollection = #(down left up) ifTrue: [^ $X].
	aCollection = #(down right up down left up right) ifTrue: [^ $Y].
	aCollection = #(right down right) ifTrue: [^ $Z]. "wonky"
	
	aCollection = #(right down left up right) ifTrue: [^ $0].
	aCollection = #(up) ifTrue: [^ $1].
	aCollection = #(up right down right) ifTrue: [^ $2].
	aCollection = #(right down left right down left) ifTrue: [^ $3].
	aCollection = #(left down right down left up) ifTrue: [^ $5].
	aCollection = #(left down right up left) ifTrue: [^ $6].
	aCollection = #(left down right down left up right up) ifTrue: [^ $8].
	aCollection = #(left down right up down) ifTrue: [^ $9].
	
	^ nil