as yet unclassified
addCommandRequest

	^ SBInsertCommand new
		index: self submorphCount + 1;
		container: self;
		morph: SBUnknown new;
		shouldMergeWithNext: true;
		yourself