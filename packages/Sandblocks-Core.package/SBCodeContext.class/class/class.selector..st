as yet unclassified
class: aClass selector: aSymbol

	^ self new
		methodClass: aClass;
		selector: aSymbol;
		stringRepresentation: aClass name, ' >> #', aSymbol;
		yourself