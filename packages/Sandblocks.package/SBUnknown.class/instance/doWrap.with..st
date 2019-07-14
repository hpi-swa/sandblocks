as yet unclassified
doWrap: aBlock with: aNode

	self sandblockEditor
		endInput;
		do: (SBWrapCommand new
			inner: self;
			outer: aNode;
			shouldMergeWithNext: true;
			wrap: aBlock);
		startInput: self at: 0 replacingContents: false