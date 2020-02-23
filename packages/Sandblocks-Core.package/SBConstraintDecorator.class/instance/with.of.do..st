as yet unclassified
with: aSymbol of: anObject do: aBlock

	anObject addDependent: self.
	aSymbol when: #positionChanged send: #check to: self.
	target := anObject.
	selector := aSymbol.
	action := aBlock.
	self check