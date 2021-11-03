Class {
	#name : #SBInlineBlockChoice,
	#superclass : #SBInlineBlock,
	#instVars : [
		'alternatives'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> advanceParseFrom: aCursor index: aNumber [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> allElementsDo: aBlock [

	self alternatives do: [:alt | alt allElementsDo: aBlock].
	aBlock value: self
]

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
				ifFalse: [^ SBTSUnknown new template: self]]
		ifNil: [^ SBTSUnknown new template: self])
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildEmpty [

	^ self class new
		alternatives: self alternatives;
		factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildWithFields: aStream alternatives: aDictionary [

	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> changeToUnknown [
	<action>

	| new |
	new := self buildCopy
		removeAllMorphs;
		buildDefault.
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: new).
	new startInputAtEnd
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> childrenForQueryDo: aBlock [

	self firstSubmorph childrenForQueryDo: aBlock
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> childrenIn: anExplore [

	| index |
	anExplore ifNil: [^ self alternatives].
	
	index := anExplore indexFor: self.
	(anExplore hasOptionOnStack: (self alternatives at: index)) ifTrue: [
		index := index + 1.
		anExplore skipOptionIn: self].
	^ {
		index > self alternatives size
			ifTrue: [SBInlineBlockNever new]
			ifFalse: [self alternatives at: index]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> deleteTargetFor: aBlock [

	self owner isInlineBlock not ifTrue: [^ self].
	
	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> firstDifferingBlocksWith: aMorph do: aBlock [

	self class ~= aMorph class ifTrue: [^ aBlock value: self value: aMorph].
	self alternatives size = aMorph alternatives size ifFalse: [^ aBlock value: self value: aMorph].
	self alternatives
		with: aMorph alternatives
		do: [:mine :their | (mine hasSameStructureAs: their) ifFalse: [^ aBlock value: self value: aMorph]].
	self submorphs
		with: aMorph submorphs
		do: [:mine :their | mine firstDifferingBlocksWith: their do: [:a :b | ^ aBlock value: a value: b]].
	^ nil
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
SBInlineBlockChoice >> isTemplate [

	^ self hasSubmorphs not
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> numAlternativesIn: anExplore [

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
SBInlineBlockChoice >> takeParseFrom: aCursor [

	^ true
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
