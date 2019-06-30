as yet unclassified
addCommandRequest

	| cmd arg |
	self isBinary ifTrue: [^ nil].
	arg := SBUnknown new.
	cmd := SBInputMessageCommand new
		previousSelector: self selector;
		previousArguments: self arguments;
		newArguments: self arguments, {arg};
		messageSend: self;
		select: arg;
		shouldMergeWithNext: true.
	
	self isUnary ifTrue: [cmd newSelector: self selector, ':'].
	self isKeyword ifTrue: [cmd newSelector: self selector, ':'].
	^ cmd