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

	^ self class new multiple: multiple required: required element: element
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildFor: aString matchFullToken: aBoolean options: anOptions [
	" FIXME: consider actually repeating "

	^ element buildFor: aString matchFullToken: aBoolean options: anOptions
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> buildPartial: anOptions with: aString [

	^ element buildPartial: anOptions with: aString
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> childrenIn: anExplore [

	^ {self element}
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
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> element [

	^ element
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class ~= aMorph class ifTrue: [^ aBlock value: self value: aMorph].
	self submorphCount ~= aMorph submorphCount ifTrue: [^ aBlock value: self value: aMorph].
	self submorphs
		with: aMorph submorphs
		do: [:mine :their | mine firstDifferingBlocksWith: their do: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> hasSameContentsAs: aBlock [

	(super hasSameContentsAs: aBlock) ifFalse: [^ false].
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

	^ self inlineIfPossible
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
SBInlineBlockRepeat >> nonInlinedChildren [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> printTitleOn: aStream [

	element printTitleOn: aStream
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> required [

	^ required
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> takeStreamFrom: anObject [

	self flag: #fixme.
	" need to consider optionals and repeating "
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockRepeat >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ element triggersFor: aString matchFullToken: aBoolean options: anOptions
]
