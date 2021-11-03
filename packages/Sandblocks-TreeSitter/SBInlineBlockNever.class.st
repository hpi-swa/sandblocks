Class {
	#name : #SBInlineBlockNever,
	#superclass : #SBInlineBlock,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> buildCopy [

	^ self shouldNotImplement
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> buildDefaultIn: anExplore [

	super buildDefaultIn: anExplore.
	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> buildEmpty [

	^ self class new factory: factory
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> childrenForQueryDo: aBlock [

	^ self shouldNotImplement
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> childrenIn: anExplore [

	(anExplore isNil or: [(anExplore indexFor: self) = 1]) ifTrue: [^ #()].
	self halt.
	^ {anExplore results}
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> firstDifferingBlocksWith: aMorph do: aBlock [

	^ aBlock value: self value: aMorph
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> hasSameContentsAs: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> hasSameStructureAs: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> isTemplate [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> layoutCommands [

	^ SBAlgebraCommand morph data: self
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> numAlternativesIn: anExplore [

	^ 1
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> printTitleOn: aStream [

	aStream nextPutAll: '<never>'
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> takeParsedFrom: aCursor [

	^ self shouldNotImplement
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> takeStreamFrom: anObject [

	^ false
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> writeSourceOn: aStream [

	self shouldNotImplement
]
