actions
watchExpression: aBlock with: aWatchClass

	self selection isExpression ifFalse: [^ self].
	
	self selection isWatch
		ifTrue: [^ self do: ((SBReplaceCommand newFor: self method) target: self selection; replacer: self selection childSandblocks first)].
	
	self selection parentSandblock isWatch ifTrue: [^ self deleteAroundSelection].
	
	self do: ((SBWrapCommand newFor: self method)
			outer: aWatchClass new newIdentifier;
			inner: aBlock;
			wrap: [:outer :inner | outer expression: inner])