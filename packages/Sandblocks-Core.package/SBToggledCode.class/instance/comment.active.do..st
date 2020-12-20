as yet unclassified
comment: aString active: aNumber do: aCollection
	
	self optionRows copy do: #delete.
	
	comment contents: aString.
	aString ifNotEmpty: [self addMorphFront: comment] ifEmpty: [comment delete].
	
	"previousBlockColor := aBlock valueOfProperty: #sandblockBlockColor."
	aCollection withIndexDo: [:block :index |
		self addMorphBack: (self buildRowFor: block active: index = aNumber)].
	self updateSelected