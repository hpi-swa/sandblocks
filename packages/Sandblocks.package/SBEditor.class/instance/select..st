as yet unclassified
select: aBlock

	| previousSelection |
	previousSelection := selection.
	aBlock == previousSelection
		ifTrue: [
			selection := nil.
			previousSelection ifNotNil: #changed]
		ifFalse: [
			selection := aBlock.
			previousSelection ifNotNil: #changed.
			selection changed]