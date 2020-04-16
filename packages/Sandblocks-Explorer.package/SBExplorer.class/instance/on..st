as yet unclassified
on: anObject

	inspector := anObject inspectorClass on: anObject.
	object := anObject.
	
	self addMorphBack: (SBStringMorph new contents: anObject printString)