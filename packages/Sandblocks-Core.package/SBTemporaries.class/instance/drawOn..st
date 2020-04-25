as yet unclassified
drawOn: aCanvas

	self submorphCount > 0 ifTrue: [ | inset fixWidth font color |
		color := self parentSandblock foregroundColor.
		inset := self layoutInset // 2.
		font := self fontToUse.
		fixWidth := ((font widthOf: $|) // 2) rounded.
		aCanvas drawString: '|' at: (self position + inset) - (fixWidth @ 0) font: nil color: color.
		aCanvas
			drawString: '|'
			at: (self position + (self width @ 0)) + ((inset x negated - fixWidth) @ inset y)
			font: nil
			color: color]