as yet unclassified
options: aCollection target: anObject at: aPoint from: aSourceMorph

	SBExample
		self: [SBRepresentationPrompt new]
		args: [{5 representationsThat: #isToplevelMorph. 5. nil}]
		label: 'example'.
	target := anObject.
	position := aPoint.
	sourceMorph := aSourceMorph.
	
	self options: aCollection target: anObject current: nil