as yet unclassified
comment: aString active: aBoolean do: aBlock

	active parsedContents: aBoolean.
	comment contents: aString.
	previousBlockColor := aBlock valueOfProperty: #sandblockBlockColor.
	self addMorphBack: aBlock.
	self update