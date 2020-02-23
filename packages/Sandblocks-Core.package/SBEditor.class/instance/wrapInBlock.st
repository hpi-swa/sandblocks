actions
wrapInBlock

	self doMultiSelection: [:statements |
		self flag: #todo. " inner needs to support an array :/ "
		(SBWrapCommand newFor: self method)
			outer: SBBlockBody new;
			inner: self selection;
			wrap: [:outer :inner | outer statements: statements];
			yourself]