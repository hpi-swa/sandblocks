as yet unclassified
comment: aString active: aNumber do: aCollection

	comment contents: aString.
	"previousBlockColor := aBlock valueOfProperty: #sandblockBlockColor."
	aCollection withIndexDo: [:block :index |
		self addMorphBack: (self buildRowFor: block active: index = aNumber)].
	self updateSelected