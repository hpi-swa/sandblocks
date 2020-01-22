as yet unclassified
addCommandRequest

	| case |
	case := (SBMorphExampleCase new name: '' caseBlock: (SBBlockBody emptyWithDeclarations: {'m'}))
		when: #run send: #runCase: to: self.
	
	^ (SBInsertCommand newFor: self containingArtefact)
		index: cases submorphCount + 1;
		container: cases;
		morph: case;
		yourself