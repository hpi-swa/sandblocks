as yet unclassified
drawOn: aCanvas

	| font cursorX colorToUse |
	font := self fontToUse.
	colorToUse := self color.
	self drawString: self contents on: aCanvas at: self position font: font color: colorToUse.
	
	suffix ifNotEmpty: [
		self drawString: self suffix on: aCanvas at: self position x + (font widthOfString: self contents) @ self position y font: font color: colorToUse].
	
	cursor > 0 ifTrue: [
		aCanvas clipBy: self bounds during: [:c |
			cursorX := (font widthOfString: self contents from: 1 to: cursor - 1) + self left.
			c line: cursorX @ self top to: cursorX @ self bottom width: 2 color: Color red]]