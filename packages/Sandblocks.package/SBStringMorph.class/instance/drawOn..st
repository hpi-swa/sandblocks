as yet unclassified
drawOn: aCanvas
	" overriden so we can override color "

	aCanvas drawString: contents in: bounds font: self fontToUse color: self color