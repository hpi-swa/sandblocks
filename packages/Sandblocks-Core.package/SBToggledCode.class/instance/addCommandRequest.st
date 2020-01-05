as yet unclassified
addCommandRequest

	| block |
	block := SBBlockBody empty.
	^ (SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: (self buildRowFor: block active: false);
		select: block statements first;
		shouldMergeWithNext: true;
		yourself