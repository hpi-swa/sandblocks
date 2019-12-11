actions
wrapInBlock

	self do: ((SBWrapCommand newFor: self method)
		outer: SBBlockBody new;
		inner: self selection;
		wrap: [:outer :inner | outer statements: {inner}];
		yourself)