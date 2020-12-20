as yet unclassified
reportValue: anObject

	hadValue ifFalse: [hadValue := true].
	
	(currentRepresentation notNil and: [currentRepresentation matches: anObject])
		ifTrue: [display replace: anObject]
		ifFalse: [self useDisplay: (anObject anyRepresentationThat: self representationTypes)].

	count contents: (count contents asInteger + 1) asString.
	lastValue := anObject