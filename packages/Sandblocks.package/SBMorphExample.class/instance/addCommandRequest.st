as yet unclassified
addCommandRequest

	| case |
	case := SBMorphExampleCase new name: '' caseBlock: (SBBlockBody emptyWithDeclarations: {'m'}).
	
	^ SBInsertCommand new
		index: cases submorphCount + 1;
		container: cases;
		morph: case;
		yourself