as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	(aBlock notNil and: [
		aBlock isName and: [aBlock isBlockBinding and: [self isMethodBody not]]]) ifTrue: [
		^ (SBInsertCommand newFor: self containingArtefact)
			index: (bindings submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
			container: bindings;
			morph: SBName new;
			shouldMergeWithNext: true;
			yourself].
	
	(aBlock notNil and: [aBlock isName and: [aBlock isTemporaryVariable]]) ifTrue: [
		^ (SBInsertCommand newFor: self containingArtefact)
			index: (temporaries submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
			container: temporaries;
			morph: SBName new;
			shouldMergeWithNext: true;
			yourself].
	
	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self statements indexOf: aBlock) + (anAfterBoolean ifTrue: [2] ifFalse: [1]);
		container: self;
		morph: SBUnknown new;
		shouldMergeWithNext: true;
		yourself