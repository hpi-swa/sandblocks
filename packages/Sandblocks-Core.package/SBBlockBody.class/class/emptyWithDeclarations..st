as yet unclassified
emptyWithDeclarations: aCollectionOfStrings

	^ SBBlockBody new
		statements: {SBUnknown new};
		temporaries: {};
		bindings: (aCollectionOfStrings collect: [:s | SBName contents: s]);
		yourself