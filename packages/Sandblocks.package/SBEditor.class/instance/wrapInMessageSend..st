actions
wrapInMessageSend: aString

	| msg |
	self selection isExpression ifFalse: [^ self].
	
	msg := SBMessageSend new.
	self do: (SBWrapCommand new
		outer: msg;
		inner: self selection;
		shouldMergeWithNext: true;
		wrap: [:outer :inner |
			outer
				receiver: inner
				selector: aString
				arguments: (aString numArgs > 0 ifTrue: [(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()])];
		yourself).
	
	self startInput: msg at: 9e8 replacingContents: false