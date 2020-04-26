as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| new |
	new := SBUnknown new.
	self sandblockEditor do: ((SBReplaceCommand newFor: self)
		target: self label;
		replacer: new;
		shouldMergeWithNext: true).
	^ new startInputAt: aNumber replacingContents: aBoolean