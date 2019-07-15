as yet unclassified
drawBlockValuesOn: aCanvas

	| font |
	font := self fontToUse.
	blockValues keysAndValuesDo: [:block :value | | str |
		str := value printString.
		aCanvas fillRectangle: (block topRight extent: (font widthOfString: str) @ font height) color: Color black.
		aCanvas drawString: str at: block topRight font: font color: Color white]