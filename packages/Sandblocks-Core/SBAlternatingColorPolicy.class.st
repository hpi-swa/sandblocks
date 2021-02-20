Class {
	#name : #SBAlternatingColorPolicy,
	#superclass : #SBColorPolicy,
	#instVars : [
		'nameColorCache'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> borderColorForBlock: aBlock [

	(aBlock isBlockBody and: [aBlock owner isMethod not]) ifTrue: [^ self colors third].
	^ Color black alpha: 0.2
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> borderWidthForBlock: aBlock [

	aBlock prefersNoBorder ifTrue: [^ 0].
	^ aBlock isBlockBody ifTrue: [1] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> colorForBlock: aBlock [

	aBlock isArtefact ifTrue: [^ Color white].
	^ (aBlock parentSandblock ifNil: [^ self colors first]) drawnColor = self colors first ifTrue: [self colors second] ifFalse: [self colors first]
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> colors [

	^ {Color white. Color gray: 0.95. Color blue}
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> foregroundColorForBlock: aBlock [

	"aBlock isLiteral ifTrue: [^ Color r: 0.6 g: 0 b: 0]."
	aBlock isName ifTrue: [^ nameColorCache at: aBlock contents ifAbsentPut: [self randomColor]].
	
	^ self foregroundColorForColor: aBlock drawnColor
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> initialize [

	super initialize.
	
	nameColorCache := Dictionary new
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> layoutInsetFor: aBlock [

	((aBlock isKindOf: SBStLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 1].
	^ aBlock wantsExtraSpace ifTrue: [2 @ 2] ifFalse: [2 @ 0]
]

{ #category : #'as yet unclassified' }
SBAlternatingColorPolicy >> randomColor [

	^ Color random adjustBrightness: -0.3
]
