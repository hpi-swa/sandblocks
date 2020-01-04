as yet unclassified
addArgumentAndEditAfter: aMorph focusKeyword: aTextMorph

	| new |
	new := SBUnknown new.
	self addMorph: new after: aMorph.
	
	aTextMorph
		ifNil: [
			self containingSandblock sandblockEditor
				endInput;
				startInput: new at: 0 replacingContents: false]
		ifNotNil: [
			self moveFocusToPart: aTextMorph]