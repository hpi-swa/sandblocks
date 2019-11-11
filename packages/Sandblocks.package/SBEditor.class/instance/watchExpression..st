actions
watchExpression: aBlock

	self selection isExpression ifFalse: [^ self].
	
	self selection isWatch
		ifTrue: [^ self do: (SBReplaceCommand target: self selection replacer: self selection childSandblocks first)].
	
	self selection parentSandblock isWatch ifTrue: [^ self deleteAroundSelection].
	
	self do: (SBWrapCommand new
			outer: SBExampleWatch new newIdentifier;
			inner: aBlock;
			wrap: [:outer :inner | outer expression: inner])