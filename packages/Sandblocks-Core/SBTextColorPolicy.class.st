Class {
	#name : #SBTextColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> borderWidthForBlock: aBlock [

	^ 0
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
SBTextColorPolicy >> layoutInset [

	^ 1 @ 0
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForArray: aBlock [

	^ #('{' '}')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForBlock: aBlock [

	^ #('[' ']')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForLiteralArray: aBlock [

	^ #('#(' ')')
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForMessageSend: aBlock [

	| parent |
	parent := aBlock parentSandblock.
	^ (parent notNil and: [parent isMessageSend and: [parent precedence <= aBlock precedence]]) ifTrue: [#('(' ')')] ifFalse: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBTextColorPolicy >> symbolsForString: aBlock [

	^ #('''' '''')
]
