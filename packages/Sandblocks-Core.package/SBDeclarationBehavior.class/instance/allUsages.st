as yet unclassified
allUsages

	^ Array streamContents: [:stream |
		self scope do: [:scope |
			scope allBlocksDo: [:block |
				(block isBinding and: [block behavior resolveBinding = self block]) ifTrue: [stream nextPut: block]]]]