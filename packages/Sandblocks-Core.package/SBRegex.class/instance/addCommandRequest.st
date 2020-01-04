as yet unclassified
addCommandRequest

	examples owner ifNil: [self toggleExamples].
	
	^ (SBInsertCommand newFor: self containingMethod)
		container: examples;
		index: (examples submorphCount max: 1);
		morph: (self createExample: '');
		shouldMergeWithNext: true