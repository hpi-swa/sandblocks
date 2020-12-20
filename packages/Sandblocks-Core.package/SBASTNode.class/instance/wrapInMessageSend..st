actions
wrapInMessageSend: aString

	| msg |
	msg := SBMessageSend new
		receiver: SBUnknown new
		selector: aString
		arguments: (aString numArgs > 0 ifTrue: [
			(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()]).
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: msg;
		inner: self;
		shouldMergeWithNext: true;
		wrap: [:outer :inner | outer receiver: inner];
		yourself).
	self sandblockEditor startInput: msg at: 900000000 replacingContents: false.
	^ msg