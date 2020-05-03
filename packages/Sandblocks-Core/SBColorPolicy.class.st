Class {
	#name : #SBColorPolicy,
	#superclass : #Object,
	#classVars : [
		'BoldMessageSends',
		'UsePango'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColorPolicy class >> boldMessageSends [

	^ BoldMessageSends ifNil: [true]
]

{ #category : #'as yet unclassified' }
SBColorPolicy class >> usePango [

	^ UsePango ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> borderColorForBlock: aBlock [

	^ (self foregroundColorForBlock: aBlock) alpha: 0.2
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMethod ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> colorForBlock: aBlock [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForBlock: aBlock [

	^ self foregroundColorForColor: aBlock drawnColor
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForColor: aColor [

	^ aColor luminance > 0.6 ifTrue: [Color black] ifFalse: [Color white]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> layoutInset [

	^ 2
]
