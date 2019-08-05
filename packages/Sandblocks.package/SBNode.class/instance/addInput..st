as yet unclassified
addInput: aString

	| label |
	label := StringMorph new contents: aString.
	inputs addMorphBack: (SBRow new
		cellInset: 6 * self scalingFactor;
		addMorphBack: (SBNodeSocket new color: Color red);
		addMorphBack: label)