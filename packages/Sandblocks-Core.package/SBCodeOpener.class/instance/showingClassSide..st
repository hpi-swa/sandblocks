as yet unclassified
showingClassSide: aBoolean

	showingClassSide := aBoolean.
	self changed: #methods.
	self selectedMethodIndex: (self methods notEmpty ifTrue: [1] ifFalse: [0]) moved: false