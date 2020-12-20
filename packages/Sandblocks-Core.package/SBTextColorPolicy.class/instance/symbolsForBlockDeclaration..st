as yet unclassified
symbolsForBlockDeclaration: aBlock

	^ self symbolsCheckStatement: aBlock for: (aBlock owner lastSubmorph = aBlock
		ifTrue: [#(':' ' |')]
		ifFalse: [#(':' nil)])