as yet unclassified
newFor: aCollection

	| accordion |
	accordion := self new.
	aCollection do: [:method | accordion addMorphBack: method asSandblock].
	^ accordion