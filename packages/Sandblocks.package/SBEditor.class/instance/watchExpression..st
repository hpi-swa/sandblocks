actions
watchExpression: aBlock

	self do: (SBWrapCommand new
		outer: SBWatch new newIdentifier;
		inner: aBlock;
		wrap: [:outer :inner | outer expression: inner])