as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBMethod new
			selector: ''
			arguments: #()
			class: class;
			body: (SBBlockBody new statements: {SBUnknown new}));
		shouldMergeWithNext: true;
		yourself