as yet unclassified
drawSymbolsOn: aCanvas

	| symbols fg font space y centerAlign |
	centerAlign := self colorPolicy centerAlignSymbols and: [self centerAlignSymbols].
	symbols := self symbols.
	space := self spaceForSymbols.
	font := self fontToUse.
	fg := self sandblockForegroundColor.
	y := centerAlign ifTrue: [
		((self layoutBounds height / 2) - (font height / 2)) rounded] ifFalse: [0].
	symbols first ifNotNil: [
		aCanvas
			drawString: symbols first
			at: self layoutBounds origin + (space first negated rounded @ y)
			font: font
			color: (fg alpha: 0.7)].
	symbols second ifNotNil: [
		aCanvas
			drawString: symbols second
			at: self layoutBounds topRight + (0 @ (centerAlign ifTrue: [y] ifFalse: [self layoutBounds height - font height]))
			font: font
			color: (fg alpha: 0.7)]