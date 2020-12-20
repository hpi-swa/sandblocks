as yet unclassified
insertUnknownAfterAndInput: aBoolean

	| new |
	self owner arguments size > 0 ifTrue: [^ self].
	
	new := SBUnknown new.
	self sandblockEditor currentInputCommand shouldMergeWithNext: true.
	
	self sandblockEditor
		endInput;
		do: ((SBInsertCommand newFor: self containingArtefact)
			morph: new;
			container: self owner;
			shouldMergeWithNext: aBoolean;
			index: self childIndex + 1).
	self sandblockEditor startInput: (aBoolean ifTrue: [new] ifFalse: [self]) at: 9e8 replacingContents: false.
	
	" inform our symbols that we now #hasColon "
	self layoutChanged