as yet unclassified
postDrawOn: aCanvas

	| font origin |
	shown ifFalse: [^ self].
	
	aCanvas
		frameRectangle: (self morph bounds expandBy: 2) width: self morph frameSize
		color: Color yellow.
	
	label ifNotNil: [
		font := TextStyle defaultFont.
		origin := self morph topRight - ((font widthOfString: label) @ 0)" + (0 @ font height negated)".
		aCanvas fillRectangle: (origin extent: (font widthOfString: label) + 2 @ font height) color: Color yellow.
		aCanvas drawString: label at: origin + (1 @ 0)]