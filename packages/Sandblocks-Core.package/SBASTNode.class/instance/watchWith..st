actions
watchWith: aWatchClass

	self isExpression ifFalse: [^ self].
	
	self isWatch
		ifTrue: [^ self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) target: self; replacer: self childSandblocks first)].
	
	self parentSandblock isWatch ifTrue: [^ self deleteAround].
	
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
			outer: aWatchClass new newIdentifier;
			inner: self;
			wrap: [:outer :inner | outer expression: inner])