as yet unclassified
for: aMorph root: aRootMorph copyIn: anEditor

	| around replacer |
	replacer := self new.
	around := aMorph.
	around replaceBy: replacer.
	anEditor copyBuffer: aRootMorph.
	replacer replaceBy: around.
	^ replacer