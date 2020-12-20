as yet unclassified
containingArtefact

	^ self isArtefact
		ifTrue: [self]
		ifFalse: [self parentSandblock ifNotNil: [:b | b containingArtefact]]