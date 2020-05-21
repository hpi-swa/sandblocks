Class {
	#name : #SBTextColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMethod ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> centerAlignSymbols [

	^ false
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> colorForBlock: aBlock [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isMessageSend ifTrue: [^ Color blue].
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
SBTextColorPolicy >> symbolsForArray: aBlock [

	^ #('{' '}')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForAssignment: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	^ (parent notNil and: [parent isMessageSend]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBlock: aBlock [

	^ #('[' ']')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBlockDeclaration: aBlock [

	^ aBlock owner lastSubmorph = aBlock
		ifTrue: [#(':' ' |')]
		ifFalse: [#(':' nil)]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForLiteralArray: aBlock [

	^ #('#(' ')')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForMessageSend: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	parent ifNil: [^ #(nil nil)].
	
	(parent isCascade and: [aBlock ~= parent lastSubmorph]) ifTrue: [
		 ^ aBlock = parent firstSubmorph
			ifTrue: [aBlock precedence > 1 ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]]
			ifFalse: [#(nil ';')]].
	
	^ (parent isMessageSend and: [parent precedence < aBlock precedence]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForString: aBlock [

	^ #('''' '''')
]
