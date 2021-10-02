Class {
	#name : #SBInlineBlockText,
	#superclass : #SBInlineBlock,
	#instVars : [
		'regexString',
		'regex'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockText >> advanceParseFrom: aCursor index: aNumber [

	^ aCursor gotoFirstChild not
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> allElementsDo: aBlock [

	aBlock value: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildCopy [

	^ self buildEmpty contents: self contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildEmpty [

	^ self class new
		regexString: self regexString;
		factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> buildWithFields: aStream alternatives: aDictionary [

	aStream peek second isString ifFalse: [^ false].
	self contents: aStream next second.
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> childrenForQuery [

	^ #()
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> childrenForQueryDo: aBlock [

	aBlock value: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> childrenIn: anExplore [

	^ {}
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> contents: aString [

	self firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> cursorPositionsDo: aBlock [

	self inline not ifTrue: [aBlock value: (SBCursorSelect new block: self)].
	
	self containingSandblock startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: self containingSandblock;
			currentCommand: command)]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> hasSameContentsAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self contents = aBlock contents]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> hasSameStructureAs: aBlock [

	^ (super hasSameStructureAs: aBlock) and: [self regexString = aBlock regexString]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> initialize [

	super initialize.
	
	self addMorphBack: (SBOwnTextMorph new
		contents: '';
		vResizing: #shrinkWrap)
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {SBAlgebraCommand morph data: self firstSubmorph}
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> lengthOfLeftMostPath [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> ownerWithColor [

	^ highlight ifNil: [self owner ifNotNil: [:o | o ownerWithColor]] ifNotNil: [self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> printTitleOn: aStream [

	aStream nextPutAll: regexString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> regex [

	^ regex
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> regexString [

	^ regexString
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> regexString: aString [

	regexString := aString.
	regex := aString asRegex
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> takeParseFrom: aCursor [

	self contents: aCursor text.
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> takeParsedFrom: aCursor [

	| copy |
	copy := self buildEmpty.
	copy contents: aCursor text.
	aCursor gotoNextSibling.
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> takeStreamFrom: anObject [

	| start |
	" does this make sense? "
	self flag: #fixme.
	(anObject matchFullToken and: [anObject stringIsLabel]) ifTrue: [^ false].
	
	start := anObject stream position + 1.
	^ (self regex matchesStreamPrefix: anObject stream)
		ifTrue: [
			self contents: (anObject stream originalContents
				copyFrom: start
				to: anObject stream position).
			true]
		ifFalse: [false]
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> valid [

	^ regex matches: self contents
]

{ #category : #'as yet unclassified' }
SBInlineBlockText >> writeSourceOn: aStream [

	aStream nextPutAll: self contents
]
