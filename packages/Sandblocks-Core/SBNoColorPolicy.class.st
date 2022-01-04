Class {
	#name : #SBNoColorPolicy,
	#superclass : #SBColorMinimalPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #colors }
SBNoColorPolicy >> background [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> borderColorForBlock: aBlock [

	((aBlock isBlockBody and: [aBlock containingBlock notNil]) or: [aBlock isArtefact]) ifTrue: [^ self default alpha: (self dark ifTrue: [0.7] ifFalse: [0.4])].
	^ self default alpha: (self dark ifTrue: [0.28] ifFalse: [self enlarge ifTrue: [0.35] ifFalse: [0.1]])
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> borderColorForButton: aButton [

	^ self default alpha: 0.4
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> borderWidthForBlock: aBlock [

	aBlock prefersNoBorder ifTrue: [^ 0].
	SBToggledCode comment: '' active: 0 do: {[aBlock isArtefact ifTrue: [^ 2]]}.
	^ 1
]

{ #category : #colors }
SBNoColorPolicy >> builtIn [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> colorForBlock: aBlock [

	(aBlock isBlockBody and: [aBlock parentSandblock isArtefact not and: [aBlock isArtefact not]]) ifTrue: [^ (self colorForBlock: aBlock parentSandblock) adjustBrightness: (self dark ifTrue: [0.03] ifFalse: [-0.03])].
	
	^ aBlock isArtefact ifTrue: [self background] ifFalse: [
		aBlock parentSandblock
			ifNotNil: [:p |
				(self shouldDarken: aBlock parent: p)
					ifTrue: [(self colorForBlock: p) adjustBrightness: (self dark ifTrue: [0.05] ifFalse: [-0.05])]
					ifFalse: [self colorForBlock: p]]
			ifNil: [self background]]
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> colorForButton: aButton [

	^ self darkerBackground
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> colorForEditor [

	^ self background
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> colorForEditor: anEditor [

	^ anEditor isSingleArtefactView
		ifTrue: [self background]
		ifFalse: [self editor]
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> cornerRadius [

	^ 4
]

{ #category : #colors }
SBNoColorPolicy >> dark [

	^ false
]

{ #category : #colors }
SBNoColorPolicy >> darkerBackground [

	^ Color white adjustBrightness: -0.07
]

{ #category : #colors }
SBNoColorPolicy >> default [

	^ Color black
]

{ #category : #colors }
SBNoColorPolicy >> defaultInverted [

	^ Color white
]

{ #category : #colors }
SBNoColorPolicy >> defaultLight [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> dropMarkerColorFor: aMorph [

	^ self important
]

{ #category : #colors }
SBNoColorPolicy >> editor [

	^ self background
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> emphasisForMessagePart: aBlock [

	(aBlock parentSandblock notNil and: [aBlock parentSandblock isMethod]) ifTrue: [^ TextEmphasis bold].
	^ TextEmphasis normal
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> foregroundColorForBlock: aBlock [

	| color |
	color := aBlock preferredColorIn: self.
	(self requiresInvertedForeground: aBlock shownColor) ifTrue: [^ self defaultInverted].
	^ color
]

{ #category : #colors }
SBNoColorPolicy >> identifier [

	^ Color black
]

{ #category : #colors }
SBNoColorPolicy >> important [

	^ Color black
]

{ #category : #colors }
SBNoColorPolicy >> keyword [

	^ Color black
]

{ #category : #colors }
SBNoColorPolicy >> literal [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> requiresInvertedForeground: aColor [

	^ self dark ifTrue: [aColor luminance > 0.7] ifFalse: [aColor luminance < 0.4]
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> selectionColorForBlock: aBlock [

	^ (aBlock shownColor luminance - self default luminance) abs < 0.2
		ifTrue: [self defaultInverted]
		ifFalse: [self default]
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> shouldDarken: aBlock parent: aParentBlock [

	^ aParentBlock childSandblocks anySatisfy: [:b | b childSandblocks size > 2 and: [(b height - aParentBlock height) abs < 2 and: [b bounds area < 10000]]]
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> toolColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBNoColorPolicy >> toolColorFor: aBlock [

	^ self toolColor
]
