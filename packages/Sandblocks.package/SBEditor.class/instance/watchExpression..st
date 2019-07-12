actions
watchExpression: aBlock

	self selection isExpression ifFalse: [^ self].
	
	self do: (SBWrapCommand new
		outer: SBWatch new newIdentifier;
		inner: aBlock;
		wrap: [:outer :inner | outer expression: inner])