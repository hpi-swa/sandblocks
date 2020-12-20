as yet unclassified
addedMorph: aMorph

	aMorph isSandblock ifTrue: [
		aMorph allBlocksDo: [:block |
			block
				detachDecorators: SBSelectionDecorator;
				detachDecorators: SBMultiSelectionDecorator]]