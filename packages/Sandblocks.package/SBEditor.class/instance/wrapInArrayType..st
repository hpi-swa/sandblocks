actions
wrapInArrayType: aSymbol

	self do: (SBWrapCommand new
		outer: SBArray new;
		inner: self selection;
		wrap: [:outer :inner | outer type: aSymbol contents: {inner}];
		yourself)