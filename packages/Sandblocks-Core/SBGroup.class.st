Class {
	#name : #SBGroup,
	#superclass : #PolygonMorph,
	#instVars : [
		'blocks',
		'indicator',
		'lastDragPosition'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGroup >> addBlock: aMorph [

	aMorph withDecorator: SBForceMoveDecorator do: [:decorator | self addViaDecorator: decorator].
	
	
]

{ #category : #'as yet unclassified' }
SBGroup >> addBlockWithoutForce: aBlock [

	aBlock withDecorator: SBForceMoveDecorator do: [:aDecorator | self addViaDecoratorWithoutForce: aDecorator]
]

{ #category : #'as yet unclassified' }
SBGroup >> addBlocksConnectedTo: aForceMoveDecorator [

	self addViaDecorator: aForceMoveDecorator.
	aForceMoveDecorator additionalForces do: [:force |
		force to group ifNil: [self addBlock: force to].
		force from group ifNil: [self addBlock: force from]]
]

{ #category : #'as yet unclassified' }
SBGroup >> addVerticesTo: newVertices from: verticalEdges side: aSide [
	
	| comingBlockSides firstEdgeSide numberOfActiveBlocks seenBlockSides sideMultiplier edgeBlock |
	aSide = #bottom
		ifTrue: [
			sideMultiplier := -1.
			firstEdgeSide := #right]
		ifFalse: [
			sideMultiplier := 1.
			firstEdgeSide := #left].
	
	comingBlockSides := verticalEdges collect: [:anEdge | (anEdge expandedBounds perform: aSide) * sideMultiplier] as: SortedCollection.
	seenBlockSides := SortedCollection new.
	numberOfActiveBlocks := 0.
	
	edgeBlock := [:edge |
		| newVertex y |
		y := (edge expandedBounds perform: aSide) * sideMultiplier.
				
		seenBlockSides add: y.
			
		newVertex := comingBlockSides
			ifEmpty: [edge position @ seenBlockSides last]
			ifNotEmpty: [
				seenBlockSides
					ifEmpty: [edge position @ comingBlockSides first]
					ifNotEmpty: [edge position @ (comingBlockSides first max: seenBlockSides first)]].
		
		newVertex := newVertex * (1 @ sideMultiplier).
		
		seenBlockSides size > 1 ifTrue: [ | x lastVertex |
			lastVertex := newVertices last.
			x  := (newVertex y * sideMultiplier) < (lastVertex y * sideMultiplier)
				ifTrue: [numberOfActiveBlocks = 0 ifTrue: [(2 * lastVertex x + newVertex x) / 3.0] ifFalse: [newVertex x]]
				ifFalse:[numberOfActiveBlocks = 0 ifTrue: [(2 * newVertex x + lastVertex x) / 3.0] ifFalse: [lastVertex x]].
			newVertices add: x @ lastVertex y.
			newVertices add: x @ newVertex y].
		newVertices add: newVertex.
				
		comingBlockSides remove: y.
			
		numberOfActiveBlocks := numberOfActiveBlocks + (edge side = firstEdgeSide ifTrue: [1] ifFalse: [-1])].
	
	aSide = #bottom
		ifTrue: [verticalEdges reverseDo: edgeBlock]
		ifFalse: [verticalEdges do: edgeBlock].
]

{ #category : #'as yet unclassified' }
SBGroup >> addViaDecorator: aForceMoveDecorator [

	self addViaDecoratorWithoutForce: aForceMoveDecorator.
	self createMissingForcesFor: aForceMoveDecorator
]

{ #category : #'as yet unclassified' }
SBGroup >> addViaDecoratorWithoutForce: aForceMoveDecorator [

	self createMissingForcesFor: aForceMoveDecorator.
	self blocks add: aForceMoveDecorator morph.
	aForceMoveDecorator group: self.
	aForceMoveDecorator morph when: #positionChanged send: #computeVertices to: self.
	aForceMoveDecorator morph when: #extentChanged send: #computeVertices to: self.
	self computeVertices.
	aForceMoveDecorator morph
		when: #delete
		send: #remove:
		to: self
		with: aForceMoveDecorator morph.
	aForceMoveDecorator morph
		when: #insert
		send: #addViaDecorator:
		to: self
		with: aForceMoveDecorator.
	self indicator updateLabel
]

{ #category : #accessing }
SBGroup >> blocks [

	^ blocks
]

{ #category : #accessing }
SBGroup >> blocks: aCollection [

	blocks := aCollection.
]

{ #category : #'as yet unclassified' }
SBGroup >> computeVerticalEdges [
	
	| verticalEdges |
	verticalEdges := Array streamContents: [:stream |
		self blocks do: [:aBlock |
			stream 
				nextPut: (SBGroupBlockEdge leftEdgeOf: aBlock);
				nextPut: (SBGroupBlockEdge rightEdgeOf: aBlock)
		]].
	
	verticalEdges sort: [:a :b | a position < b position].
	
	^ verticalEdges
]

{ #category : #'as yet unclassified' }
SBGroup >> computeVertices [

	| verticalEdges newVertices |
	verticalEdges := self computeVerticalEdges.
	newVertices := OrderedCollection new.
	
	self
		addVerticesTo: newVertices from: verticalEdges side: #top;
		addVerticesTo: newVertices from: verticalEdges side: #bottom;
		setVertices: newVertices
]

{ #category : #'as yet unclassified' }
SBGroup >> createMissingForcesFor: aForceMoveDecorator [

	| missingConnectionsTo |
	missingConnectionsTo := self blocks copy.
	aForceMoveDecorator additionalForces do: [:aForce |
		missingConnectionsTo remove: aForce to ifAbsent: [].
		missingConnectionsTo remove: aForce from ifAbsent: [].
		
		].
	missingConnectionsTo do: [:aBlock | self sandblockEditor ifNotNil: [:editor | editor openMorph: (SBForceConnector connect: aForceMoveDecorator morph to: aBlock forceScale: 0.5)]]
]

{ #category : #'as yet unclassified' }
SBGroup >> handlesMouseDown: evt [

	^ evt redButtonPressed
]

{ #category : #'as yet unclassified' }
SBGroup >> handlesMouseMove: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'as yet unclassified' }
SBGroup >> handlesMouseOverDragging: evt [

	^ evt redButtonPressed
]

{ #category : #accessing }
SBGroup >> indicator [

	^ indicator
]

{ #category : #accessing }
SBGroup >> indicator: aMorph [

	indicator := aMorph.
]

{ #category : #'as yet unclassified' }
SBGroup >> initialize [

	super initialize.
	self blocks: Set new.
	self color: (Color random alpha: 0.5).
	self indicator: (SBOffscreenBlockIndicator newFor: self)
]

{ #category : #'as yet unclassified' }
SBGroup >> isArtefact [

	^ true
]

{ #category : #accessing }
SBGroup >> morphicLayerNumber [

	^ 101
]

{ #category : #'as yet unclassified' }
SBGroup >> mouseDown: anEvent [

	lastDragPosition := anEvent position
]

{ #category : #'as yet unclassified' }
SBGroup >> mouseMove: anEvent [
	
	lastDragPosition ifNotNil: [
		self position: self position + (anEvent position - lastDragPosition).
		self blocks do: [:aBlock |
			aBlock position: aBlock position + (anEvent position - lastDragPosition)].
		lastDragPosition := anEvent position]
]

{ #category : #'as yet unclassified' }
SBGroup >> mouseUp: anEvent [

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]
]

{ #category : #'as yet unclassified' }
SBGroup >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self sandblockEditor openMorphInOverlay: self indicator
]

{ #category : #'as yet unclassified' }
SBGroup >> outOfWorld: aWorld [

	self triggerEvent: #delete.
	super outOfWorld: aWorld
]

{ #category : #'as yet unclassified' }
SBGroup >> remove: aMorph [

	self blocks remove: aMorph ifAbsent: [^ self].
	aMorph withDecorator: SBForceMoveDecorator do: [:decorator | decorator group: nil].
	self blocks size < 2
		ifTrue: [
			self blocks do: [:block |
				block removeActionsWithReceiver: self.
				block withDecorator: SBForceMoveDecorator do: [:decorator | decorator group: nil]].
			self abandon]
		ifFalse: [self computeVertices].
	self indicator updateLabel
]

{ #category : #'as yet unclassified' }
SBGroup >> saveString [

	^ String streamContents: [:stream |
		stream
			nextPutAll: self className;
			nextPutAll: ' new '.
		self blocks do: [:aBlock |
			stream nextPutAll: ' addBlockWithoutForce: '.
			aBlock printIdentityStringOn: stream.
			stream nextPutAll: ';'].
		stream nextPutAll: ' color: '.
		self color storeOn: stream]
]

{ #category : #'as yet unclassified' }
SBGroup >> textContents [

	self blocks ifEmpty: [^ 'Empty Group'].
	^ 'Group of ', self blocks anyOne textContents, ' and ', (self blocks size - 1), (' other' asPluralBasedOn: self blocks)
]

{ #category : #'as yet unclassified' }
SBGroup >> withDecorator: aDecorator do: aBlock ifAbsent: anotherBlock [
	"Indicators may ask us whether we have a group"

	^ anotherBlock value
]
