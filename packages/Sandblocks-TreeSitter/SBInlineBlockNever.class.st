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
SBInlineBlockNever >> buildEmpty [

	^ self class new
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> buildIn: aMorph info: anObject [

	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlockNever >> childrenIn: anExplore [

	^ #()
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
