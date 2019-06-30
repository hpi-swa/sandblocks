actions
wrapInBlock

	self do: (SBWrapCommand new
		outer: SBBlockBody new;
		inner: self selection;
		wrap: [:outer :inner | outer statements: {inner}];
		yourself)