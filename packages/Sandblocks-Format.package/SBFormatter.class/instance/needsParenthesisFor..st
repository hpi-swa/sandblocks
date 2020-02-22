as yet unclassified
needsParenthesisFor: aNode

	SBExample
		self: [SBFormatter new]
		args: [
			{
				(Parser new parse: '(self assert: 2) ifNotNil: 3' class: nil class noPattern: true notifying: nil ifFail: nil) body statements first expr receiver
			}]
		label: 'simple'.
	aNode isLeaf ifTrue: [^ false].
	(aNode isKindOf: ReturnNode) ifTrue: [^ false].
	aNode isBlockNode ifTrue: [^ false].
	(self parentFor: aNode) isBlockNode ifTrue: [^ false].
	(aNode isMessage and: [aNode originalSelector isUnary]) ifTrue: [^ false].
	(((self parentFor: aNode) isKindOf: CascadeNode)
		and: [aNode isMessage and: [aNode originalSelector isUnary not and: [(self parentFor: aNode) originalReceiver = aNode]]]) ifTrue: [^ true].
	(self precedenceOf: aNode) < (self precedenceOf: (self parentFor: aNode)) ifTrue: [^ false].
	^ true