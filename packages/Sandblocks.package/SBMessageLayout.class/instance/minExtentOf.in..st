as yet unclassified
minExtentOf: aMorph in: aRectangle

	| x y |
	minExtentCache ifNotNil: [^ minExtentCache].
	aMorph hasSubmorphs ifFalse: [^ 0 @ 0].
	
	x := 0.
	y := 0.
	aMorph submorphCount < 3
		ifTrue: [aMorph submorphsDo: [:m | x := x + m width. y := y max: m height]]
		ifFalse: [
			aMorph submorphs pairsDo: [:m1 :m2 |
				x := x max: m1 width + aMorph cellInset + m2 width.
				y := y + (m1 height max: m2 height)]].
	^ minExtentCache := x @ y