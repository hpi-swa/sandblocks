as yet unclassified
insertCommandRequest: anAfterBoolean near: aBlock

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBMethodCategory new class: self firstSubmorph object category: 'untitled' collapsed: false);
		shouldMergeWithNext: true;
		yourself