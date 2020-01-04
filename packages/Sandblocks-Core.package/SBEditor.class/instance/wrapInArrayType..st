actions
wrapInArrayType: aSymbol

	self do: ((SBWrapCommand newFor: self method)
		outer: SBArray new;
		inner: self selection;
		wrap: [:outer :inner | outer type: aSymbol contents: {inner}];
		yourself)