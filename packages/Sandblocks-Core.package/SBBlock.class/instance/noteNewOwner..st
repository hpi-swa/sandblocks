testing
noteNewOwner: aMorph

	" recheck name blocks "
	self allBlocksDo: [:block | block isName ifTrue: [block noteNewOwner: block owner]]