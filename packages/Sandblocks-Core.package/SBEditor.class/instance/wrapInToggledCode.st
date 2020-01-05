actions
wrapInToggledCode

	self do: ((SBWrapCommand newFor: self method)
		outer: SBToggledCode new;
		inner: self selection;
		wrap: [:outer :inner | outer comment: '' active: 0 do: {SBBlockBody new statements: {inner}}];
		yourself)