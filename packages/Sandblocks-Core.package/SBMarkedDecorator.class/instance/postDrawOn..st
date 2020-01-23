as yet unclassified
postDrawOn: aCanvas

	| font origin |
	aCanvas
		frameRectangle: (self morph bounds expandBy: 2) width: self morph frameSize
		color: Color yellow.
	
	letter ifNotNil: [
		font := TextStyle defaultFont.
		origin := self morph topRight - ((font widthOf: self letter) @ 0) + (4 @ -4).
		aCanvas fillRectangle: (origin extent: (font widthOf: self letter) + 2 @ font height) color: Color yellow.
		aCanvas drawString: self letter asString at: origin + (1 @ 0)]