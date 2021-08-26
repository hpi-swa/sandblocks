Class {
	#name : #SBInlineBlockLabel,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildCopy [

	^ self buildEmpty
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildEmpty [

	^ self class new label: self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	^ (aBoolean
		ifTrue: [aStream nextMatchAll: self label]
		ifFalse: [aStream nextMatchAll: (self label first: (aStream size - aStream position min: self label size))])
		ifTrue: [self veryDeepCopy]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> buildPartial: anOptions with: aString [

	^ self veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> childrenIn: anExplore [

	^ {}
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> contents [

	^ self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class ~= aMorph class ifTrue: [^ aBlock value: self value: aMorph].
	self label ~= aMorph label ifTrue: [^ aBlock value: self value: aMorph]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> hasSameContentsAs: aBlock [

	^ (super hasSameContentsAs: aBlock) and: [self label = aBlock label]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> hasSameStructureAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self label = aBlock label]
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
SBInlineBlockLabel >> lengthOfLeftMostPath [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> printTitleOn: aStream [

	aStream nextPutAll: self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> takeStreamFrom: option [

	^ option matchFullToken
		ifTrue: [option stream nextMatchAll: self label]
		ifFalse: [option stream nextMatchAll: (self label first: (option stream size - option stream position min: self label size))]
]
