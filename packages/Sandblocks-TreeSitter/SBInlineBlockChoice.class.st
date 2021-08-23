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
SBInlineBlockChoice >> buildDefaultIn: anExplore [

	self addMorphBack: (anExplore
		ifNotNil: [
			(anExplore hasSeenChoice: self)
				ifTrue: [(self alternatives at: (anExplore indexFor: self)) veryDeepCopy]
				ifFalse: [SBTSUnknown new template: self]]
		ifNil: [SBTSUnknown new template: self])
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildEmpty [

	^ self class new alternatives: self alternatives
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildFor: aStream matchFullToken: aBoolean options: anOptions [

	| index |
	index := anOptions optionAt: self ifAbsentPut: [1].
	^ ((alternatives at: index)
		buildFor: aStream
		matchFullToken: aBoolean
		options: anOptions) ifNotNil: [:result | self veryDeepCopy removeAllMorphs addMorphBack: result]
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildIn: aMorph info: anObject [

	^ self
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> buildPartial: anOptions with: aString [

	^ (alternatives at: anOptions index)
		buildPartial: anOptions children first
		with: aString
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
SBInlineBlockChoice >> childrenIn: anExplore [

	^ {self alternatives at: (anExplore indexFor: self)}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> deleteTargetFor: aBlock [

	^ self owner deleteTargetFor: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> duplicateCleanTree [

	^ self veryDeepCopy removeAllMorphs
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
	self alternatives
		with: aBlock alternatives
		do: [:a :b | (a hasSameStructureAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> inline [

	^ SBToggledCode comment: '' active: 1 do: {
		[self owner notNil and: [self owner isInlineBlock]].
		[
			self inlineIfPossible and: [
				SBToggledCode
					comment: ''
					active: 1
					do: {[true]. [(self owner isKindOf: SBInlineBlockChoice) not]}]].
		[true]}
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> isUnambiguous [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockChoice >> printTitleOn: aStream [

	alternatives do: [:m | m printTitleOn: aStream] separatedBy: [aStream nextPutAll: ' | ']
]
