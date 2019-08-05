as yet unclassified
addOutput: aString

	| label |
	label := StringMorph new contents: aString.
	outputs addMorphBack: (SBRow new
		cellInset: 6 * self scalingFactor;
		addMorphBack: label;
		addMorphBack: (SBNodeSocket new color: Color red))