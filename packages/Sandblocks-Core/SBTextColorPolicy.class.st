Class {
	#name : #SBTextColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> borderWidthForBlock: aBlock [

	(aBlock isKindOf: SBStateMachineEditor) ifTrue: [^ 1].
	
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

	aBlock isMessageSend ifTrue: [^ Color blue].
	aBlock isMessagePart ifTrue: [^ Color blue].
	aBlock isPragma ifTrue: [^ Color green].
	aBlock isLiteralBlock ifTrue: [^ Color red muchDarker].
	^ Color black
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> layoutInsetFor: aBlock [

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

	^ (aBlock isStatement and: [aBlock isLastChild not])
		ifTrue: [
			aCollection last
				ifNil: [{aCollection first. self statementSeparator}]
				ifNotNil: [
					{aCollection first. (aCollection last, self statementSeparator)}]]
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

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]
