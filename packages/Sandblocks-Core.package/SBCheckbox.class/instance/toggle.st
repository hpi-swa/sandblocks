as yet unclassified
toggle

	self sandblockEditor do: ((self nonEdit
		ifTrue: [SBMutatePropertyCommand newNonEdit]
		ifFalse: [
			SBMutatePropertyCommand newFor: self containingArtefact])
		target: self;
		selector: #value;
		mutateSelector: #changeValue:;
		value: self value not).