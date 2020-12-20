as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	| index |
	examples owner ifNil: [self toggleExamples].
	index := aBlock = text
		ifTrue: [1]
		ifFalse: [((examples submorphIndexOf: aBlock) ifNil: [1]) + (anAfterBoolean ifTrue: [1] ifFalse: [0])].
	
	^ (SBInsertCommand newFor: self containingArtefact)
		container: examples;
		index: index;
		morph: (self createExample: '');
		shouldMergeWithNext: true