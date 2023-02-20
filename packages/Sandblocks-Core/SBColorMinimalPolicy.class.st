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
	
	self enlarge ifTrue: [^ 1 sbScaled].
	
	^ (aBlock floating or: [(self drawnColorOfOpaque: aBlock) luminance > 0.9])
		ifTrue: [1 sbScaled]
		ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> cornerRadius [

	^ 4 sbScaled
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> layoutInsetFor: aBlock [

	self enlarge ifTrue: [
		aBlock isArtefact ifTrue: [^ 6 sbScaled].
		^ aBlock submorphCount > 1 ifTrue: [4 sbScaled] ifFalse: [(4 @ 2) sbScaled]].
	(aBlock isUnknown or: [(aBlock isKindOf: SBStLiteral) or: [aBlock isBlockBody]]) ifTrue: [^ (2 @ 1) sbScaled].
	(aBlock isMessageSend and: [aBlock messageParts size > 1]) ifTrue: [^ 4 sbScaled].
	^ aBlock wantsExtraSpace ifTrue: [(2 @ 1) sbScaled] ifFalse: [(2 @ 0) sbScaled]
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> lineGap [

	^ 2 sbScaled
]

{ #category : #'as yet unclassified' }
SBColorMinimalPolicy >> selectionBorderWidth [

	^ 2 sbScaled
]
