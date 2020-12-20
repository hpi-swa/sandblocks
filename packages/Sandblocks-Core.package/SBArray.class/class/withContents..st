as yet unclassified
withContents: aCollection

	| array |
	array := self new.
	aCollection do: [:m | array addMorphBack: m].
	^ array