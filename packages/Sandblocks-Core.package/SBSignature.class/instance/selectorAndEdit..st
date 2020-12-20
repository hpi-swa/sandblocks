as yet unclassified
selectorAndEdit: aString

	" end the current input and pretend it never happened so that we can override with the suggestion "
	| current |
	current := self containingSandblock sandblockEditor currentInputCommand.
	current oldMorph contents: current previousText.
	self containingSandblock sandblockEditor endInput.
	
	self sandblockEditor do: ((SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		messageSend: self containingSandblock;
		previousArguments: self arguments;
		previousSelector: self selector;
		newSelector: aString;
		newArguments: ((1 to: (self numArguments: aString)) collect: [:index | self arguments at: index ifAbsent: [SBUnknown new]]);
		shouldMergeWithNext: true;
		yourself).
	
	self arguments
		detect: #isUnknown
		ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false]
		ifNone: [
			self sandblockEditor do: ((SBDoItCommand newFor: self containingSandblock containingArtefact) do: [self messageParts last select])]