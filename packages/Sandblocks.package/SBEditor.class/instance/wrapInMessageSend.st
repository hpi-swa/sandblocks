actions
wrapInMessageSend

	| msg |
	msg := SBMessageSend new.
	self do: (SBWrapCommand new
		outer: msg;
		inner: self selection;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner selector: #'' arguments: #()];
		yourself).
	
	self startInput: msg at: 1 replacingContents: false