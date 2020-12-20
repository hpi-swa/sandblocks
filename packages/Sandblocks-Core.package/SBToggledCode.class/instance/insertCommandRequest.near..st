as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	| block index |
	index := (self submorphIndexOf: aBlock owner) ifNil: [2] ifNotNil: [:i | i   + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	block := SBBlockBody empty.
	^ (SBInsertCommand newFor: self containingArtefact)
		index: index;
		container: self;
		morph: (self buildRowFor: block active: false);
		select: block statements first;
		shouldMergeWithNext: true;
		yourself