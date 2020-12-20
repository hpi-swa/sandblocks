as yet unclassified
example: anExample watch: aWatch

	| newHashes |
	example := anExample.
	
	newHashes := aWatch probedValues
		select: [:probedValue |
			probedValue hadMethodOnStack: self containingArtefact object block: self owner firstSubmorph startPC key]
		thenCollect: [:probedValue |
			probedValue contextIdentityHashFor: self owner firstSubmorph startPC key].
	
	contextIdentityHashes := (contextIdentityHashes, newHashes) withoutDuplicates.
	self lastSubmorph maximumValue: contextIdentityHashes size