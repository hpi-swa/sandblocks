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

	^ self class new
		label: self label;
		factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> childrenForQuery [

	^ #()
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> childrenForQueryDo: aBlock [

	aBlock value: self
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
SBInlineBlockLabel >> label [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> label: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {SBAlgebraCommand morph data: self firstSubmorph}
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> lengthOfLeftMostPath [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> ownerWithColor [

	^ highlight ifNil: [self owner ifNotNil: [:o | o ownerWithColor]] ifNotNil: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> printTitleOn: aStream [

	aStream nextPutAll: self label
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> takeParsedFrom: aCursor [

	^ aCursor text withBlanksTrimmed = self label
		ifTrue: [
			aCursor gotoNextSibling.
			self buildEmpty]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> takeStreamFrom: option [

	^ option stream atEnd not and: [option matchFullToken
		ifTrue: [option stream nextMatchAll: self label]
		ifFalse: [option stream nextMatchAll: (self label first: (option stream size - option stream position min: self label size))]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> writeSourceOn: aStream [

	aStream nextPutAll: self label
]
