as yet unclassified
isMyArgument: aBlock

	self argumentsDo: [:b | aBlock = b ifTrue: [^ true]].
	^ false