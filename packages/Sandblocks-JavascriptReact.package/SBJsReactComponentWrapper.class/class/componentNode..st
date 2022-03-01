constructor
componentNode: aSBInlineBlockSymbolForClassDeclaration

	aSBInlineBlockSymbolForClassDeclaration type ~= 'class_declaration' ifTrue: [
		self signal: 'Expecting a class declaration that can be wrapped.'.
		^ nil].
	^ self new reactComponent: aSBInlineBlockSymbolForClassDeclaration