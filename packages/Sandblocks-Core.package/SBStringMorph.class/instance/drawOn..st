drawing
drawOn: aCanvas
	" overriden so we can override color "

	aCanvas drawString: contents in: self layoutBounds font: self fontToUse color: self color