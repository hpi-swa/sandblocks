as yet unclassified
contents: aString

	| font |
	contents := aString.
	font := TextStyle defaultFont.
	self extent: (font widthOfString: aString) @ font height + (self bounds extent - self layoutBounds extent)