as yet unclassified
promptChangeValue

	| index |
	index := UIManager default chooseFrom: self values.
	index > 0 ifTrue: [ 
		self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
			target: self;
			selector: #object;
			value: (self values at: index))]