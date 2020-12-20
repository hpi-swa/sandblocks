as yet unclassified
class: aClass selector: aSymbol ifValid: aBlock

	(aClass methodDict includesKey: aSymbol) ifTrue: [
		^ aBlock value: (self class: aClass selector: aSymbol)]