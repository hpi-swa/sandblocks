Class {
	#name : #SBCTextColorPolicy,
	#superclass : #SBTextColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isReturn ifTrue: [^ Color red].
	^ super foregroundColorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> messageCellGap [

	^ 0
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> statementSeparator [

	^ ';'
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsCheckStatement: aBlock for: aCollection [

	((aBlock parentSandblock isMessageSend and: [aBlock isFirstChild not]) or:
		[aBlock isName and: [aBlock isMethodArgument]]) ifTrue: [
		^ {
			aCollection first ifNil: ['('] ifNotNil: ['(', aCollection first].
			aCollection second ifNil: [')'] ifNotNil: [aCollection second, ')']
		}].
	
	^ aBlock isStatement
		ifTrue: [
			aCollection last
				ifNil: [{aCollection first. self statementSeparator}]
				ifNotNil: [
					{aCollection first. (aCollection last, self statementSeparator)}]]
		ifFalse: [aCollection]
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForArray: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('[]{' '}')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForBlock: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('[]{ ' ' }')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForCharacter: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('''' '''')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForKeywordBinding: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForMessagePart: aBlock [

	| first |
	first := aBlock childIndex = 2 ifTrue: ['.'] ifFalse: [aBlock childIndex = 1 ifTrue: ['..'] ifFalse: [nil]].
	^ aBlock isUnary ifTrue: [{first. '()'}] ifFalse: [{first. nil}]
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForMessageSend: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	parent ifNil: [^ self symbolsCheckStatement: aBlock for: #(nil nil)].
	
	^ self
		symbolsCheckStatement: aBlock
		for: ((parent isMessageSend and: [
			aBlock precedence > parent precedence or: [parent precedence = 3 and: [aBlock precedence = 3]]]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)])
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForName: aBlock [

	^ self symbolsCheckStatement: aBlock for: #(nil nil)
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForReturn: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('return ' nil)
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForString: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('"' '"')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForSymbol: aBlock [

	^ self symbolsCheckStatement: aBlock for: #('#' nil)
]
