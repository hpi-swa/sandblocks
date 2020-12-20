as yet unclassified
validDisplaysFor: anObject

	^ self class watchTypes select: [:display | anObject isNil or: [display matches: anObject]]