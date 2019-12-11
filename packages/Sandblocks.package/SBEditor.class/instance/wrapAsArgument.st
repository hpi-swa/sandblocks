actions
wrapAsArgument

	| msg |
	msg := SBMessageSend new.
	self do: ((SBWrapCommand newFor: self method)
		outer: msg;
		inner: self selection;
		shouldMergeWithNext: true;
		wrap: [:outer :inner |
			outer
				receiver: SBUnknown new
				selector: ':'
				arguments: {inner}];
		yourself).
	
	self startInput: msg at: 0 replacingContents: false