accessing
existingExamples

	^ self reactComponent access body children
		detect: [:member | member element class = SBJsReactExamplesReplacement]
		ifNone: [nil]