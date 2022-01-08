Class {
	#name : #SBColorMinimalPolicy,
	#superclass : #SBDefaultColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> borderColorForBlock: aBlock [

	^ Color black alpha: 0.25
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> borderWidthForBlock: aBlock [

	aBlock prefersNoBorder ifTrue: [^ 0].
	
	self enlarge ifTrue: [^ 1].
	
	^ (aBlock floating or: [(self drawnColorOfOpaque: aBlock) luminance > 0.9])
		ifTrue: [1]
		ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> cornerRadius [

	^ 4
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> layoutInsetFor: aBlock [

	self enlarge ifTrue: [
		aBlock isArtefact ifTrue: [^ 2].
		^ 4].
	(aBlock isUnknown or: [(aBlock isKindOf: SBStLiteral) or: [aBlock isBlockBody]]) ifTrue: [^ 2 @ 1].
	(aBlock isMessageSend and: [aBlock messageParts size > 1]) ifTrue: [^ 4].
	^ aBlock wantsExtraSpace ifTrue: [2 @ 1] ifFalse: [2 @ 0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> lineGap [

	^ 2
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> selectionBorderWidth [

	^ 2
]
