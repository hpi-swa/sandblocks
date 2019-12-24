as yet unclassified
codeActions

	^ {
		SBCodeAction labeled: 'Change View Mode' for: self do: #chooseViewMode.
		SBCodeAction labeled: 'Explore Value' for: self do: #exploreLastValue.
		SBCodeAction labeled: 'Store as Example' for: self do: #storeAsExample.
	}, super codeActions