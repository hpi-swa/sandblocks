actions
changeSelection

	| new |
	new := SBUnknown new.
	
	self do: (SBReplaceCommand new
		target: self selection;
		replacer: new;
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: new at: 0 replacingContents: false