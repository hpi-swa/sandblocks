as yet unclassified
reportValue: anObject

	anObject isNumber
		ifTrue: [(display isKindOf: SBStringMorph) ifTrue: [self switchToNumberDisplay]]
		ifFalse: [(display isKindOf: ECSGraphPlot) ifTrue: [self switchToPrintDisplay]].
	
	display reportValue: anObject