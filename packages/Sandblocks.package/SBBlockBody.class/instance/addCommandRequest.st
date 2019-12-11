as yet unclassified
addCommandRequest

	^ (SBInsertCommand newFor: self containingMethod)
		index: bindings submorphCount + 1;
		container: bindings;
		morph: SBDeclarationForBlock new;
		shouldMergeWithNext: true;
		yourself