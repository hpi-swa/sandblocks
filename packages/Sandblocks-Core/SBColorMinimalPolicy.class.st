Class {
	#name : #SBColorMinimalPolicy,
	#superclass : #SBDefaultColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> borderWidthForBlock: aBlock [

	^ (aBlock isArtefact or: [(self colorForBlock: aBlock) luminance > 0.9 and: [aBlock prefersNoBorder not]]) ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> layoutInsetFor: aBlock [

	((aBlock isKindOf: SBStLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 1].
	^ aBlock wantsExtraSpace ifTrue: [2 @ 2] ifFalse: [2 @ 0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> lineGap [

	^ 2
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> selectionBorderWidth [

	^ 2
]
