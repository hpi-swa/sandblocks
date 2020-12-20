as yet unclassified
layoutMorphsOf: aMorph

	^ Array streamContents: [:stream |
		self layoutMorphsOf: aMorph do: [:m | stream nextPut: m]]