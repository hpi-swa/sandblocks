as yet unclassified
layoutVertically: aMorph in: aRectangle

	| y |
	y := aRectangle top.
	aMorph submorphs pairsDo: [:messagePart :value |
		messagePart bounds: (aRectangle left @ y extent: messagePart extent).
		value bounds: (messagePart right + aMorph cellInset @ y extent: value extent).
		y := y + (messagePart height max: value height)]