Class {
	#name : #SBInlineBlockLabel,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> advanceParseFrom: aCursor index: aNumber [

	^ aCursor gotoFirstChild not
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> allElementsDo: aBlock [

	aBlock value: self
]

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
SBInlineBlockLabel >> buildWithFields: aStream alternatives: aDictionary [

	aStream atEnd ifTrue: [^ false].
	
	^ aStream peek second = self label
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]
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
	self label ~= aMorph label ifTrue: [^ aBlock value: self value: aMorph].
	^ nil
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
SBInlineBlockLabel >> isTemplate [

	^ false
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
SBInlineBlockLabel >> labelDifferenceOf: aMorph do: aBlock [

	^ self label = aMorph label
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
SBInlineBlockLabel >> streamHasWord: aStream [

	| start ret |
	start := aStream position.
	ret := self factory wordRule matchesStreamPrefix: aStream.
	aStream position: start.
	^ ret
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> takeParseFrom: aCursor [

	self contents: aCursor text.
	^ true
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

	^ option atEnd not and: [
		(self factory notNil and: [self factory wordRule notNil and: [self streamHasWord: option]])
			ifTrue: [ | start nextWord |
				start := option position + 1.
				
				self factory wordRule matchesStreamPrefix: option.
				nextWord := option originalContents copyFrom: start to: option position.
				^ (option matchFullToken
					ifTrue: [self label = nextWord]
					ifFalse: [nextWord = (self label first: (nextWord size min: self label size))])
					ifTrue: [true]
					ifFalse: [
						option position: start - 1.
						false]]
			ifFalse: [
				option matchFullToken
					ifTrue: [option nextMatchAll: self label]
					ifFalse: [option nextMatchAll: (self label first: (option size - option position min: self label size))]]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockLabel >> writeSourceOn: aStream [

	aStream nextPutAll: self label
]
