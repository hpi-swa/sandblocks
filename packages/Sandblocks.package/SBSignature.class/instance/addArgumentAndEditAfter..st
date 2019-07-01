as yet unclassified
addArgumentAndEditAfter: aMorph

	| new |
	new := SBUnknown new.
	self addMorph: new after: aMorph.
	self containingSandblock sandblockEditor
		endInput;
		startInput: new at: 0 replacingContents: false