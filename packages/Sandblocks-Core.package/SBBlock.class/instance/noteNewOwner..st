testing
noteNewOwner: aMorph

	super noteNewOwner: aMorph.
	
	self allBlocksDo: [:block | block layoutChanged].
	" recheck name blocks "
	self allBlocksDo: [:block | block isName ifTrue: [block noteNewOwner: block owner]]