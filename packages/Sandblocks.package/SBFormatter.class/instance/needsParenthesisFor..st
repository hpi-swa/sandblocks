as yet unclassified
needsParenthesisFor: aNode 
	aNode isLeaf
		ifTrue: [^ false].
	(aNode isKindOf: ReturnNode)
		ifTrue: [^ false].
	aNode isBlockNode
		ifTrue: [^ false].
	(self precedenceOf: aNode)
			< (self
					precedenceOf: (self parentFor: aNode))
		ifTrue: [^ false].
	(self parentFor: aNode) isBlockNode
		ifTrue: [^ false].
	(aNode isMessage
			and: [aNode originalSelector isUnary])
		ifTrue: [^ false].
	^ true