Class {
	#name : #SBInlineBlockSequence,
	#superclass : #SBInlineBlock,
	#instVars : [
		'elements'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> addedMorph: aMorph [

	super addedMorph: aMorph
	"(self hasSubmorphs and: [(self firstSubmorph isKindOf: SBInlineBlockLabel) and: [self firstSubmorph label = '.']]) ifTrue: [self halt].
	((aMorph isKindOf: SBInlineBlockLabel) and: [aMorph label = '.' and: [aMorph submorphIndex = 1]]) ifTrue: [self halt]"
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildCopy [

	| copy |
	copy := self buildEmpty.
	self submorphsDo: [:m | copy addMorphBack: m buildCopy].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	self elements do: [:element | self addMorphBack: element instantiate]
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildEmpty [

	^ self class new elements: self elements
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| copy |
	copy := self veryDeepCopy removeAllMorphs.
	elements withIndexDo: [:element :index |
		(element buildFor: aStream matchFullToken: aBoolean options: anOptions)
			ifNotNil: [:morph | copy addMorphBack: morph]
			ifNil: [^ nil].
		aStream atEnd ifTrue: [
			index + 1
				to: self submorphCount
				do: [:next | copy addMorphBack: (elements at: next) veryDeepCopy].
			^ copy]].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> buildPartial: anOptions with: aString [

	^ SBInlineBlockSequence new elements: {elements first buildPartial: anOptions with: aString}, (elements viewAllButFirst collect: [:element | element veryDeepCopy])
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> childrenIn: anExplore [

	^ self elements
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> elements [

	^ elements
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> elements: aCollection [

	elements := aCollection
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> hasSameContentsAs: aBlock [

	(super hasSameContentsAs: aBlock) ifFalse: [^ false].
	self submorphs
		with: aBlock submorphs
		do: [:a :b | (a hasSameContentsAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> hasSameStructureAs: aBlock [

	(super hasSameStructureAs: aBlock) ifFalse: [^ false].
	self submorphCount = aBlock submorphCount ifFalse: [^ false].
	self submorphs
		with: aBlock submorphs
		do: [:a :b | (a hasSameStructureAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> inline [

	^ self inlineIfPossible
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: [:morph | morph layoutCommands])
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> printTitleOn: aStream [

	elements do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> takeParsedFrom: aCursor [

	| copy |
	copy := self buildEmpty.
	self elements do: [:element |
		(element takeParsedFrom: aCursor)
			ifNotNil: [:m | copy addMorphBack: m]
			ifNil: [^ nil]].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> takeStreamFrom: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> triggersFor: aStream matchFullToken: aBoolean options: anOptions [

	elements do: [:element |
		(element triggersFor: aStream matchFullToken: aBoolean options: anOptions) ifFalse: [^ false].
		aStream atEnd ifTrue: [^ true]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockSequence >> writeSourceOn: aStream [

	self submorphs
		do: [:element | element writeSourceOn: aStream]
		separatedBy: [aStream space]
]
