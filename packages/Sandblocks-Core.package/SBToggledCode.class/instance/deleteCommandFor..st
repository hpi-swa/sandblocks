as yet unclassified
deleteCommandFor: aBlock

	^ aBlock = self firstSubmorph
		ifTrue: [
			(SBMutatePropertyCommand newFor: self containingMethod)
				target: self firstSubmorph;
				selector: #contents;
				value: '']
		ifFalse: [
			(SBDeleteCommand newFor: self containingMethod)
				target: aBlock owner]