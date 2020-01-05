as yet unclassified
addCommandRequest

	^ self isMethodBody
		ifTrue: [nil]
		ifFalse: [
			(SBInsertCommand newFor: self containingArtefact)
				index: bindings submorphCount + 1;
				container: bindings;
				morph: SBDeclarationForBlock new;
				shouldMergeWithNext: true;
				yourself]