as yet unclassified
addCommandRequest

	^ (SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: addType new;
		shouldMergeWithNext: true;
		yourself