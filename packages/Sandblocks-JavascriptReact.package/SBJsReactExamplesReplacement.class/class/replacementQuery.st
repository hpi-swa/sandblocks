inline-replacement
replacementQuery

	| query |
	query := (self class >> #matchComponentExamples:do:) pragmas first arguments second copy.
	^ query at: (query findString: ' @example_array_declaration' startingAt: 0 caseSensitive: true) put: $?;
		yourself