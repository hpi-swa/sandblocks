as yet unclassified
addCommandRequest

	^ SBInsertCommand new
		index: bindings submorphCount + 1;
		container: bindings;
		morph: SBDeclarationForBlock new;
		shouldMergeWithNext: true;
		yourself