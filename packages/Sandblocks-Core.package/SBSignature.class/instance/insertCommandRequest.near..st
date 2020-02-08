as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	| cmd index |
	self isBinary ifTrue: [^ nil].
	index := (self arguments indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]).
	index < 1 ifTrue: [^ nil].
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		 previousSelector: self selector;
		 previousArguments: self arguments;
		 newArguments: (self arguments withInsert: SBUnknown new at: index);
		 messageSend: self;
		 select: self parentSandblock;
		 editInputIndex: index;
		 newSelector: (self selector keywords withInsert: ':' at: index) join;
		 yourself.
	^ cmd