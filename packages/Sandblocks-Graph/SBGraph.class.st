Class {
	#name : #SBGraph,
	#superclass : #PasteUpMorph,
	#instVars : [
		'cuttingMoving'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBGraph class >> forMethod: aMethod [

	| ast constructor |
	ast := aMethod methodClass newParser parse: aMethod getSourceFromFile class: aMethod methodClass.
	
	constructor := SBGraphConstructor new.
	ast accept: constructor.
	^ constructor graph autoPlace
]

{ #category : #'as yet unclassified' }
SBGraph >> autoPlace [

	| root min max |
	root := self nodes detect: [:morph | morph hasFlowIn not and: [morph outputSockets first connectedLinks isEmpty]].
	
	root autoPlaceFlow.
	
	min := 0 @ 0.
	self nodes do: [:morph |
		morph left < min x ifTrue: [min := morph left @ min y].
		morph top < min ifTrue: [min := min x @ morph top]].
	self nodes do: [:morph |
		morph position: self position + morph position + min negated].
	
	max  := 0 @ 0.
	self nodes do: [:morph |
		morph left > max x ifTrue: [max := morph left @ max y].
		morph top > max y ifTrue: [max := max x @ morph top]].
	self extent: max
]

{ #category : #'as yet unclassified' }
SBGraph >> links [

	^ self submorphs select: #isLink
]

{ #category : #'as yet unclassified' }
SBGraph >> mouseDown: anEvent [

	anEvent yellowButtonPressed
		ifTrue: [cuttingMoving := true]
		ifFalse: [super mouseDown: anEvent]
]

{ #category : #'as yet unclassified' }
SBGraph >> mouseMove: anEvent [

	cuttingMoving
		ifTrue: [self links do: [:link |
				(link source center
					to: link target center
					intersects: anEvent startPoint
					to: anEvent endPoint) ifTrue: [link delete]]]
		ifFalse: [super mouseMove: anEvent]
]

{ #category : #'as yet unclassified' }
SBGraph >> mouseUp: anEvent [

	cuttingMoving := false.
	super mouseUp: anEvent
]

{ #category : #'as yet unclassified' }
SBGraph >> nodes [

	^ self submorphs select: #isNode
]
