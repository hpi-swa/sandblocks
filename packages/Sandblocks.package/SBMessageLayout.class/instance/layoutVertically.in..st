as yet unclassified
layoutVertically: aMorph in: aRectangle

	| y |
	y := aRectangle top.
	aMorph submorphs pairsDo: [:messagePart :value |
		messagePart layoutInBounds: (aRectangle left @ y extent: messagePart extent).
		value layoutInBounds: (messagePart right + aMorph cellGap @ y extent: value extent).
		y := y + (messagePart height max: value height)]