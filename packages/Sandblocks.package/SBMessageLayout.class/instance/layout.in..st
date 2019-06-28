as yet unclassified
layout: aMorph in: aRectangle

	aMorph hasSubmorphs ifFalse: [^ self].
	
	aMorph submorphCount < 3 ifTrue: [^ self layoutHorizontally: aMorph in: aRectangle].
	
	^ self layoutVertically: aMorph in: aRectangle