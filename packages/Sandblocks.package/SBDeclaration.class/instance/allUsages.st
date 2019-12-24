as yet unclassified
allUsages

	^ Array streamContents: [:stream |
		self scope do: [:scope |
			scope allBlocksDo: [:block |
				(block isBinding and: [block resolveBinding = self]) ifTrue: [stream nextPut: block]]]]