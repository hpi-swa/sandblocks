Class {
	#name : #SBLessBorderColorPolicy,
	#superclass : #SBColorMinimalPolicy,
	#instVars : [
		'nameColorCache'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> borderColorForBlock: aBlock [

	(aBlock isBlockBody and: [aBlock parentSandblock isMethod]) ifTrue: [^ Color white].
	
	^ aBlock isBlockBody ifTrue: [Color black] ifFalse: [Color black alpha: 0.2]
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> borderWidthForBlock: aBlock [

	aBlock prefersNoBorder ifTrue: [^ 0].
	aBlock isMessagePart ifTrue: [^ 0].
	^ aBlock isBlockBody ifTrue: [1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> colorForBlock: aBlock [

	"(aBlock childSandblocks isEmpty and: [aBlock prefersNoBorder not]) ifTrue: [^ Color gray: 0.9]."
	^ aBlock height > 100
		ifTrue: [Color white]
		ifFalse: [Color gray: 0.95]
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isLiteralBlock ifTrue: [^ Color r: 0.8 g: 0 b: 0].
	aBlock isName ifTrue: [^ Color r: 0.263 g: 0.263 b: 0.941].
	
	^ self foregroundColorForColor: aBlock drawnColor
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> layoutInsetFor: aBlock [

	^ super layoutInsetFor: aBlock
	"| parent |
	aBlock isMessageSend ifFalse: [^ 2 @ 0].
	parent := aBlock parentSandblock.
	^ (parent isMessageSend and: [
			aBlock precedence > parent precedence or: [parent precedence = 3 and: [aBlock precedence = 3]]]) ifTrue: [2 @ 2] ifFalse: [2 @ 0]"
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> randomColor [

	^ Color random adjustBrightness: -0.3
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> selectionBorderWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> selectionColorForBlock: aBlock [

	^ Color red
]
