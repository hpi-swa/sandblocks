as yet unclassified
allUsagesDo: aBlock

	^ self scope do: [:scope |
		scope ifNotNil: [
			scope allBlocksDo: [:block |
				(block isBinding and: [block behavior resolveBinding = self block]) ifTrue: [aBlock value: block]]]]