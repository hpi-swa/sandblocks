Class {
	#name : #SBColorMinimalPolicy,
	#superclass : #SBDefaultColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMethod ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> layoutInsetFor: aBlock [

	((aBlock isKindOf: SBLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 1].
	^ (aBlock isMessageSend or: [aBlock isAssignment or: [aBlock isReturn]]) ifTrue: [2 @ 0] ifFalse: [2 @ 2]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> lineGap [

	^ 2
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> selectionBorderWidth [

	^ 2
]
