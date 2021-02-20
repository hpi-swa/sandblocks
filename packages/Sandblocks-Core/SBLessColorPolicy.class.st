Class {
	#name : #SBLessColorPolicy,
	#superclass : #SBColorMinimalPolicy,
	#instVars : [
		'nameColorCache'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLessColorPolicy >> colorForBlock: aBlock [

	^ aBlock isBlockBody
		ifTrue: [Color gray: 1]
		ifFalse: [
			aBlock parentSandblock ifNotNil: [:p | p color adjustBrightness: -0.09] ifNil: [Color white]]
]

{ #category : #'as yet unclassified' }
SBLessColorPolicy >> foregroundColorForBlock: aBlock [

	aBlock isLiteralBlock ifTrue: [ | c |
		c := Color r: 1 g: 0.748 b: 0.748.
		aBlock drawnColor luminance > 0.7 ifTrue: [c := Color r: 0.718 g: 0.39 b: 0.39].
		^ c].
	aBlock isName ifTrue: [ | c |
		c := Color r: 0.731 g: 0.826 b: 1.
		aBlock drawnColor luminance > 0.6 ifTrue: [c := Color r: 0.263 g: 0.263 b: 0.941].
		^ c].
	^ self foregroundColorForColor: aBlock drawnColor
]

{ #category : #'as yet unclassified' }
SBLessColorPolicy >> layoutInsetFor: aBlock [

	^ super layoutInsetFor: aBlock
	"aBlock isBlockBody ifTrue: [^ 2 @ 1].
	aBlock isMessageSend ifFalse: [^ 2 @ 0].
	aBlock childSandblocksDo: [:child |
		(child isMessageSend and: [child precedence > aBlock precedence or: [aBlock precedence = 3 and: [child precedence = 3]]]) ifTrue: [^ 2 @ 10]].
	^ 2 @ 0"
]

{ #category : #'as yet unclassified' }
SBLessColorPolicy >> randomColor [

	^ Color random adjustBrightness: -0.3
]
