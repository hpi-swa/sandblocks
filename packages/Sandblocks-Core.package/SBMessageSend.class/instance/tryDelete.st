as yet unclassified
tryDelete

	| receiver |
	receiver := self receiver.
	^ self sandblockEditor
		endInput;
		do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: receiver);
		startInput: receiver at: 9e8 replacingContents: false