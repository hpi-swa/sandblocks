as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	^ (aBlock isName and: [aBlock isBlockBinding and: [self isMethodBody not]])
		ifTrue: [
			(SBInsertCommand newFor: self containingArtefact)
				index: (bindings submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
				container: bindings;
				morph: SBDeclarationForBlock new;
				shouldMergeWithNext: true;
				yourself]
		ifFalse: [
			(SBInsertCommand newFor: self containingArtefact)
				index: (self childSandblocks indexOf: aBlock) + 1 + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
				container: self;
				morph: SBUnknown new;
				shouldMergeWithNext: true;
				yourself]