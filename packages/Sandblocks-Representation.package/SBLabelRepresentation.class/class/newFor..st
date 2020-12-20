as yet unclassified
newFor: anObject

	^ SBMultilineOwnTextMorph new contents: (anObject printStringLimitedTo: 120)