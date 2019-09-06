as yet unclassified
addInput: aString

	| label socket |
	label := self newTextMorph contents: aString.
	socket := SBNodeSocket new type: #input.
	inputs addMorphBack: (SBRow new
		cellInset: 2 * self scalingFactor;
		addMorphBack: socket;
		addMorphBack: label).
	^ socket