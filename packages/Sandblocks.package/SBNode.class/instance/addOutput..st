as yet unclassified
addOutput: aString

	| label socket |
	label := self newTextMorph contents: aString.
	socket := SBNodeSocket new
			type: #output;
			when: #connected send: #maybeRemoveFlowIn to: self.
	outputs addMorphBack: (SBRow new
		cellGap: 2 * self scalingFactor;
		addMorphBack: label;
		addMorphBack: socket).
	^ socket