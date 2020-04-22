as yet unclassified
getOrCreateLocalBinding: aString

	^ bindings submorphs
		detect: [:block | block contents = aString]
		ifNone: [self createBinding: aString]