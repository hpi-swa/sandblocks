as yet unclassified
addCommandRequest

	| cmd arg |
	self isBinary ifTrue: [^ nil].
	arg := SBUnknown new.
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingMethod)
		previousSelector: self selector;
		previousArguments: self arguments;
		newArguments: self arguments, {arg};
		messageSend: self;
		select: self parentSandblock;
		editInputIndex: self arguments size + 1.
	
	self isUnary ifTrue: [cmd newSelector: self selector, ':'].
	self isKeyword ifTrue: [cmd newSelector: self selector, ':'].
	^ cmd