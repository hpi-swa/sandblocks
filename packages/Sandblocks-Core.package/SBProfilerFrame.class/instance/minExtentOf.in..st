as yet unclassified
minExtentOf: aMorph in: aRectangle

	aMorph submorphCount = 1 ifTrue: [^ 0 @ aMorph fontToUse height].
	
	^ 0 @ (aMorph fontToUse height + (aMorph submorphs viewAllButFirst inject: 0 into: [:max :morph | morph minExtent y max: max]))