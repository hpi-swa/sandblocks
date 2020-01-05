as yet unclassified
addCommandRequest

	^ (SBInsertCommand newFor: self containingArtefact)
		index: self submorphCount + 1;
		container: self;
		morph: SBUnknown new;
		shouldMergeWithNext: true;
		yourself