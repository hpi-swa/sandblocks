Class {
	#name : #SBTextColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> borderWidthForBlock: aBlock [

	(aBlock isKindOf: SBStSubstitution) ifTrue: [^ 1].
	
	^ aBlock isMethod ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> centerAlignSymbols [

	^ false
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> colorForBlock: aBlock [

	(aBlock isKindOf: SBStateMachineState) ifTrue: [^ Color gray: 0.9].
	
	^ Color white
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isMessageSend ifTrue: [^ Color blue muchDarker].
	(aBlock isMessagePart and: [aBlock messageSend isMethod]) ifTrue: [^ Color black].
	aBlock isMessagePart ifTrue: [^ Color blue muchDarker].
	aBlock isPragma ifTrue: [^ Color green].
	aBlock isLiteralBlock ifTrue: [^ Color red muchDarker].
	(aBlock isName and: [aBlock contents = 'self']) ifTrue: [^ Color red muchDarker].
	(aBlock isName and: [aBlock isTemporaryVariable]) ifTrue: [^ Color gray muchDarker].
	(aBlock isName and: [aBlock isBinding and: [aBlock resolveBinding ifNotNil: #isTemporaryVariable ifNil: [false]]]) ifTrue: [^ Color gray muchDarker].
	(aBlock isKindOf: SBLabel) ifTrue: [^ Color green muchDarker].
	^ super foregroundColorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> layoutInsetFor: aBlock [

	(aBlock isBlockBody and: [aBlock isSmalltalk and: [aBlock isMethodBody]]) ifTrue: [^ SBEdgeInsets left: 16 right: 0 top: 12 bottom: 0].
	^ 1 @ 0
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> lineGap [

	^ 4
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> selectionBorderWidth [

	^ 2
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> statementSeparator [

	^ '.'
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsCheckStatement: aBlock for: aCollection [

	^ ((aBlock isStatement and: [aBlock isLastChild not]) or: [
		aBlock parentSandblock
			ifNotNil: [:p | p isArrayBlock and: [p type = #dynamic]]
			ifNil: [false]])
		ifTrue: [
			aCollection last
				ifNil: [{aCollection first. self statementSeparator}]
				ifNotNil: [{aCollection first. aCollection last, self statementSeparator}]]
		ifFalse: [aCollection]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForArray: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('{' '}')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForAssignment: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	^ self symbolsCheckStatement: aBlock for: ((parent notNil and: [parent isMessageSend]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)])
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBinding: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBlock: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('[' ']')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBlockDeclaration: aBlock [

	^ self symbolsCheckStatement: aBlock for: (aBlock owner lastSubmorph = aBlock
		ifTrue: [#(':' ' |')]
		ifFalse: [#(':' nil)])
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBoolean: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForLiteralArray: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('#(' ')')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForMessageSend: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	parent ifNil: [^ self symbolsCheckStatement: aBlock for: #(nil nil)].
	
	(parent isCascade and: [aBlock ~= parent lastSubmorph]) ifTrue: [
		^ self
			symbolsCheckStatement: aBlock
			for: (aBlock = parent firstSubmorph ifTrue: [
				aBlock precedence > 1 ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]] ifFalse: [#(nil ';')])].
	
	^ self
		symbolsCheckStatement: aBlock
		for: ((parent isMessageSend and: [
			aBlock precedence > parent precedence or: [parent precedence = 3 and: [aBlock precedence = 3]]]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)])
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForMethodArgumentDeclaration: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForNumber: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForPragma: aBlock [

	^ #('<' '>')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForString: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('''' '''')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForUnknown: aBlock [

	^ #(nil nil)
]
