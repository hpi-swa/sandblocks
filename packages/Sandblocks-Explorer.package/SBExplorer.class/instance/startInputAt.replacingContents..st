as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| new |
	new := [self object printString parseAsSandblockWithoutSubstitution] on: SyntaxErrorNotification do: [:error | 
		SBUnknown new].
	self sandblockEditor do: ((SBReplaceCommand newFor: self)
		target: self label;
		replacer: new;
		shouldMergeWithNext: true).
	self sandblockEditor replaceInput: new.
	^ new startInputAt: aNumber replacingContents: false