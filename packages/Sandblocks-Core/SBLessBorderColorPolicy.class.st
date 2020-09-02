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

	aBlock isMessagePart ifTrue: [^ 0].
	^ aBlock isBlockBody ifTrue: [1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> colorForBlock: aBlock [

	^ Color white"aBlock isBlockBody
		ifTrue: [Color white]
		ifFalse: [
			aBlock parentSandblock ifNotNil: [:p | p color adjustBrightness: -0.15] ifNil: [Color white]]"
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isLiteralBlock ifTrue: [^ Color r: 0.8 g: 0 b: 0].
	aBlock isName ifTrue: [^ Color r: 0.263 g: 0.263 b: 0.941].
	
	^ self foregroundColorForColor: aBlock drawnColor
]

{ #category : #'as yet unclassified' }
SBLessBorderColorPolicy >> layoutInsetFor: aBlock [

	^ 2
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
