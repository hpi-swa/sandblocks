as yet unclassified
forAll: aCollection root: aRootMorph copyIn: anEditor
	" requires aCollection to be a consecutive list of morphs "

	| replacer |
	replacer := self new.
	aCollection first replaceBy: replacer.
	aCollection do: #delete.
	anEditor copyBuffer: aRootMorph.
	replacer replaceBy: aCollection first.
	aCollection first owner addAllMorphs: aCollection allButFirst behind: aCollection first.
	^ replacer