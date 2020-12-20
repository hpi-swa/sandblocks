as yet unclassified
exampleFinished: anExample

	| slider |
	slider := examples at: anExample ifAbsentPut: [ | s |
		s := SBExampleSlider new.
		self addMorphBack: s.
		s].
	slider exampleFinished: anExample.
	self allWatchesDo: [:watch |
		(watch valuesForExample: anExample) ifNotNil: [:display | slider example: anExample watch: display]]