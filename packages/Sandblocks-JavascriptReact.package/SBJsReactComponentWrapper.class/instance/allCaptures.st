accessing
allCaptures

	self reactComponent allBlocksDo: [:block |
		SBTSQuery new
			execute: SBJsReactExamplesReplacement replacementQuery
			against: block
			capturesDo: [:captures :success | success ifTrue: [^ captures]]].
	^ nil