actions
changeSelection

	| new |
	self setCopyBuffer: self selection.
	new := SBUnknown new.
	
	self do: ((SBReplaceCommand newFor: self method)
		target: self selection;
		replacer: new;
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: new at: 0 replacingContents: false