Class {
	#name : #SBInlineBlockRepeat,
	#superclass : #SBInlineBlock,
	#instVars : [
		'multiple',
		'required',
		'element'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> advanceParseFrom: aCursor index: aNumber [

	aNumber > 1 ifTrue: [aCursor gotoNextSibling].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> allElementsDo: aBlock [

	element allElementsDo: aBlock.
	aBlock value: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildCopy [

	| copy |
	copy := self buildEmpty.
	self submorphsDo: [:m | copy addMorphBack: m buildCopy].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	required ifTrue: [self addMorphBack: self element instantiate]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildEmpty [

	^ self class new
		multiple: multiple required: required element: element;
		factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildWithFields: aStream alternatives: aDictionary [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> childrenForQueryDo: aBlock [

	self submorphsDo: [:m | m childrenForQueryDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> childrenIn: anExplore [

	| index |
	anExplore isNil ifTrue: [^ {self element}].
	
	index := anExplore indexFor: self.
	^ Array streamContents: [:stream | (required ifTrue: [index] ifFalse: [index - 1]) timesRepeat: [stream nextPut: self element]]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> cursorPositionsDo: aBlock [

	| buildInsert |
	buildInsert := [:adjacent :before |
		aBlock value: (SBCursorInsert new
			command: (SBTSRelInsertCommand new near: adjacent before: before in: self morph: element);
			before: before;
			adjacent: adjacent;
			container: self)].
	
	self inline ifFalse: [aBlock value: (SBCursorSelect new block: self)].
	
	(multiple or: [self hasSubmorphs not]) ifTrue: [buildInsert value: nil value: true].
	self submorphsDo: [:morph |
		multiple ifTrue: [buildInsert value: morph value: true].
		morph cursorPositionsDo: aBlock.
		multiple ifTrue: [buildInsert value: morph value: false]].
	(multiple or: [self hasSubmorphs not]) ifTrue: [buildInsert value: nil value: false]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> deleteTargetFor: aBlock [

	^ (required not or: [self submorphCount > 1])
		ifTrue: [aBlock]
		ifFalse: [self owner deleteTargetFor: self]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> element [

	^ element
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class ~= aMorph class ifTrue: [^ aBlock value: self value: aMorph].
	self submorphCount ~= aMorph submorphCount ifTrue: [^ aBlock value: self value: aMorph].
	(self element hasSameStructureAs: aMorph element) ifFalse: [^ aBlock value: self value: aMorph].
	self submorphs
		with: aMorph submorphs
		do: [:mine :their | mine firstDifferingBlocksWith: their do: [:a :b | ^ aBlock value: a value: b]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> hasSameContentsAs: aBlock [

	(super hasSameContentsAs: aBlock) ifFalse: [^ false].
	self submorphCount = aBlock submorphCount ifFalse: [^ false].
	
	self submorphs
		with: aBlock submorphs
		do: [:a :b | (a hasSameContentsAs: b) ifFalse: [^ false]].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> hasSameStructureAs: aBlock [

	(super hasSameStructureAs: aBlock) ifFalse: [^ false].
	(self element hasSameStructureAs: aBlock element) ifFalse: [^ false].
	(self required ~= aBlock required or: [self multiple ~= aBlock multiple]) ifTrue: [^ false].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> inline [

	^ SBToggledCode
		comment: ''
		active: 1
		do: {[self owner notNil and: [self owner isInlineBlock]]. [self inlineIfPossible]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ SBTSRelInsertCommand new
		near: (aBlock ifNotNil: [
			aBlock orOwnerSuchThat: [:o | o owner = self]])
		before: aBoolean
		in: self
		morph: aMorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> isTemplate [

	^ required and: [self hasSubmorphs not]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (Array streamContents: [:stream |
			self submorphs withIndexDo: [:morph :index |
				stream nextPut: morph layoutCommands.
				index ~= self submorphCount ifTrue: [
					stream nextPut: (((self factory hardLineBreakMatcher value: morph) or: [self containingSandblock isStatementContainer])
						ifTrue: [SBAlgebraCommand hardLine]
						ifFalse: [SBAlgebraCommand softLineOrGap])]]])
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> multiple [

	^ multiple
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> multiple: aBoolean required: anotherBoolean element: aMorph [

	multiple := aBoolean.
	required := anotherBoolean.
	element := aMorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> newEmptyChildNear: aBlock before: aBoolean [

	^ element instantiate
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> nonInlinedChildren [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> numAlternativesIn: anExplore [

	anExplore streamContainsBlock ifTrue: [^ anExplore stream size + (required ifTrue: [0] ifFalse: [1])].
	^ required ifTrue: [1] ifFalse: [2]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> ownerWithColor [

	^ self owner ifNotNil: [:o | o ownerWithColor]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> printTitleOn: aStream [

	element printTitleOn: aStream.
	(multiple and: [required]) ifTrue: [^ aStream nextPut: $+].
	(multiple and: [required not]) ifTrue: [^ aStream nextPut: $*].
	aStream nextPut: $?
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> repeaterChild [

	^ self multiple ifTrue: [self] ifFalse: [super repeaterChild]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> required [

	^ required
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> takeParseFrom: aCursor [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> takeParsedFrom: aCursor [

	| count copy abort restore |
	count := 0.
	copy := self buildEmpty.
	abort := false.
	[abort not and: [aCursor atEnd not and: [count = 0 or: [self multiple]]]] whileTrue: [
		restore := aCursor position.
		(element takeParsedFrom: aCursor)
			ifNotNil: [:m |
				copy addMorphBack: m.
				count := count + 1]
			ifNil: [
				aCursor position: restore.
				abort := true]].
	
	^ (count > 0 or: [required not]) ifTrue: [copy] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> takeStreamFrom: anObject [

	self flag: #fixme.
	" need to consider optionals and repeating "
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> writeSourceOn: aStream [

	self submorphs
		do: [:element | element writeSourceOn: aStream]
		separatedBy: [aStream space]
]
