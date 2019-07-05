as yet unclassified
shortcut: aString label: anotherString

	^ SBRow new
		cellInset: 6 * self scalingFactor;
		addMorphBack: (StringMorph new contents: aString; emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (StringMorph new contents: anotherString);
		yourself