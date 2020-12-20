as yet unclassified
previousWithoutMessageSend: aBlock

	^ aBlock isMessageSend
		ifTrue: [ | adjacent |
			adjacent := aBlock adjacentBlock: -1.
			self previousWithoutMessageSend: (adjacent ifNotNil: [adjacent lastDeepChild] ifNil: [aBlock parentSandblock])]
		ifFalse: [aBlock]