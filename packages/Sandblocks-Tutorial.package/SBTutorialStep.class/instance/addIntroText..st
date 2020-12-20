as yet unclassified
addIntroText: aString

	self
		addMorph: (SBMultilineOwnTextMorph new
			contents: aString;
			maxWidth: self maxTextWidth)
		asElementNumber: 2