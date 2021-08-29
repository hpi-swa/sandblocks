Class {
	#name : #SBInlineBlockChoice,
	#superclass : #SBInlineBlock,
	#instVars : [
		'alternatives'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> alternatives [

	^ alternatives
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> alternatives: aCollection [

	alternatives := aCollection
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildCopy [

	| copy |
	copy := self buildEmpty.
	self hasSubmorphs ifTrue: [
		copy addMorphBack: self firstSubmorph buildCopy].
	^ copy
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	self addMorphBack: (anExplore
		ifNotNil: [
			(anExplore hasSeenChoice: self)
				ifTrue: [(self alternatives at: (anExplore indexFor: self)) instantiate]
				ifFalse: [SBTSUnknown new template: self]]
		ifNil: [SBTSUnknown new template: self])
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildEmpty [

	^ self class new
		alternatives: self alternatives;
		factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> changeToUnknown [
	<action>

	self
		removeAllMorphs;
		buildDefault;
		startInputAtEnd
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> childrenForQueryDo: aBlock [

	self firstSubmorph childrenForQueryDo: aBlock
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> childrenIn: anExplore [

	anExplore ifNil: [^ self alternatives].
	^ {self alternatives at: (anExplore indexFor: self)}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> deleteTargetFor: aBlock [

	self owner isInlineBlock not ifTrue: [^ self].
	
	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class ~= aMorph class ifTrue: [^ aBlock value: self value: aMorph].
	(self alternatives hasEqualElements: aMorph alternatives) ifTrue: [^ aBlock value: self value: aMorph].
	self submorphs
		with: aMorph submorphs
		do: [:mine :their | mine firstDifferingBlocksWith: their do: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> hasSameContentsAs: aBlock [

	^ (super hasSameContentsAs: aBlock) and: [self firstSubmorph hasSameContentsAs: aBlock firstSubmorph]
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> hasSameStructureAs: aBlock [

	(super hasSameStructureAs: aBlock) ifFalse: [^ false].
	self alternatives size = aBlock alternatives size ifFalse: [^ false].
	self alternatives
		with: aBlock alternatives
		do: [:a :b | (a hasSameStructureAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> inline [

	^ SBToggledCode comment: '' active: 3 do: {
		[self owner notNil and: [self owner isInlineBlock and: [(self owner submorphs count: [:m | (m isKindOf: SBInlineBlockLabel) not]) = 1]]].
		[
			self inlineIfPossible and: [
				SBToggledCode
					comment: ''
					active: 1
					do: {[true]. [(self owner isKindOf: SBInlineBlockChoice) not]}]].
		[self owner notNil and: [self owner isInlineBlock]]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> numAlternatives [

	^ self alternatives size
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> ownerWithColor [

	^ self owner ifNotNil: [:o | o ownerWithColor]
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> printTitleOn: aStream [

	SBToggledCode comment: '' active: 0 do: {
		[(self hasSubmorphs and: [self firstSubmorph isUnknown not]) ifTrue: [^ self firstSubmorph printTitleOn: aStream]]}.
	alternatives
		do: [:m | | current |
			current := self hasSubmorphs and: [m hasSameStructureAs: self firstSubmorph].
			current ifTrue: [aStream nextPut: $[].
			m printTitleOn: aStream.
			current ifTrue: [aStream nextPut: $]]]
		separatedBy: [aStream nextPutAll: ' | ']
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> takeParsedFrom: aCursor [

	| copy |
	copy := self buildEmpty.
	self alternatives do: [:choice | | restore |
		restore := aCursor position.
		(choice takeParsedFrom: aCursor)
			ifNotNil: [:m |
				copy addMorphBack: m.
				^ copy]
			ifNil: [aCursor position: restore]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> takeStreamFrom: aMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
