as yet unclassified
unhandledEvent: anEvent in: anEditor didHandle: aBlock

	(anEvent keyCharacter isAlphaNumeric and: [anEditor selection notNil]) ifTrue: [
		"anEditor startInput: anEditor selection at: 0 replacingContents: true."
		anEditor selection changeToUnknown.
		anEditor selection keyStroke: anEvent.
		^ aBlock value]