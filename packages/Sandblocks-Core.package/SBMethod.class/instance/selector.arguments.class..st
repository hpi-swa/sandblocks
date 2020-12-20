as yet unclassified
selector: aSymbol arguments: aCollection class: aClass

	super selector: aSymbol arguments: aCollection class: aClass.
	signature selector: aSymbol arguments: aCollection.
	classPrefix object: aClass.
	self savedMethodHasComments ifTrue: [
		self firstSubmorph
			addMorphBack: (Morph new
				color: Color transparent;
				extent: 12 @ 0);
			addMorphBack: (SBIcon iconWarning balloonText: 'Method has comments that cannot be saved')]