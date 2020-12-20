as yet unclassified
mouseDown: anEvent

	self sandblockEditor do: (((self owner isSandblock not or: [self owner containingArtefact isNil])
		ifTrue: [SBDeleteCommand newNonEdit]
		ifFalse: [	SBDeleteCommand newFor: self owner containingArtefact]) target: self)