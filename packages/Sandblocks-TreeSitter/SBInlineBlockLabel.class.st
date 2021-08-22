Class {
	#name : #SBInlineBlockLabel,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	^ (aBoolean
		ifTrue: [aStream nextMatchAll: self label]
		ifFalse: [aStream nextMatchAll: (self label first: (aStream size - aStream position min: self label size))])
		ifTrue: [self veryDeepCopy]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildIn: aMorph info: anObject [

	(anObject matchFullToken
		ifTrue: [anObject stream nextMatchAll: self label]
		ifFalse: [anObject stream nextMatchAll: (self label first: (anObject stream size - anObject stream position min: self label size))])
		ifTrue: [aMorph addMorphBack: self veryDeepCopy]
		ifFalse: [anObject cancel]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildPartial: anOptions with: aString [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> contents [

	^ self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> initialize [

	super initialize.
	
	self addMorphBack: (SBStringMorph new contents: '')
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> isUnambiguous [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> label [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> label: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> printTitleOn: aStream [

	aStream nextPutAll: self label
]
