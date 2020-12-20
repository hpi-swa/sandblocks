as yet unclassified
value: anObject context: aContext

	value := anObject.
	frames := (aContext stackOfSize: 10) collect: [:frame |
		SBStackFrameIdentifier new context: frame]