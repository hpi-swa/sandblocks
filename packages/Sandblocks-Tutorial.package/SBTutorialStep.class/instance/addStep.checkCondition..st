as yet unclassified
addStep: aString checkCondition: aBlock

	steps addMorphBack: (SBRow new
		cellGap: 8;
		addMorphBack: (SBCheckbox new
			setProperty: #checkBlock toValue: aBlock;
			value: (self class checkIsComplete: selector index: steps submorphCount + 1);
			yourself);
		addMorphBack: (SBMultilineOwnTextMorph new
			contents: aString;
			maxWidth: self maxTextWidth))