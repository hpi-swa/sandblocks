callbacks
insertCommandRequest: anAfterBoolean near: aBlock

	| index case |
	index := (cases submorphIndexOf: aBlock) ifNil: [1] ifNotNil: [:i | i   + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	case := (SBMorphExampleCase new name: '' caseBlock: (SBBlockBody emptyWithDeclarations: {'m'}))
		when: #run send: #runCase: to: self.
	
	^ (SBInsertCommand newFor: self containingArtefact)
		index: index;
		container: cases;
		morph: case;
		yourself