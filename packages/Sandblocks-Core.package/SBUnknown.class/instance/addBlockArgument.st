as yet unclassified
addBlockArgument

	self sandblockEditor
		endInput;
		do: (self parentSandblock addCommandRequest);
		startInput: self sandblockEditor selection at: 0 replacingContents: false