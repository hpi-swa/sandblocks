as yet unclassified
deleteCommandFor: aBlock

	^ aBlock = self firstSubmorph
		ifTrue: [
			(SBMutatePropertyCommand newFor: self containingArtefact)
				target: self firstSubmorph;
				selector: #contents;
				value: '']
		ifFalse: [
			(SBDeleteCommand newFor: self containingArtefact)
				target: aBlock owner]