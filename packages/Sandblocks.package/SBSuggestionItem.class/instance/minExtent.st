as yet unclassified
minExtent

	| font |
	font := self fontToUse.
	^ (font widthOfString: selector) @ font height + (self layoutInset * 2) + (self cellInset @ 0) + ((font widthOfString: label) @ 0)