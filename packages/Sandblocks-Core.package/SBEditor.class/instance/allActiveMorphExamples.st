accessing
allActiveMorphExamples

	^ Array streamContents: [:stream |
		self allBlocksDo: [:b | (b isMorphExample and: [b visible]) ifTrue: [stream nextPut: b]]]