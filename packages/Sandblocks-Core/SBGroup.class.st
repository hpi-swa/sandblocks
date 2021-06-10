Class {
	#name : #SBGroup,
	#superclass : #PolygonMorph,
	#instVars : [
		'blocks',
		'indicator'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGroup class >> newFor: aForceMoveDecorator [

	^ self new addBlocksConnectedTo: aForceMoveDecorator; yourself
]

{ #category : #'as yet unclassified' }
SBGroup >> add: aForceMoveDecorator [

	self blocks add: aForceMoveDecorator morph.
	aForceMoveDecorator group: self.
	aForceMoveDecorator morph when: #positionChanged send: #computeVertices to: self.
	self computeVertices.
	self indicator ifNil: [
		self indicator: (SBOffscreenBlockIndicator newFor: self).
		aForceMoveDecorator morph sandblockEditor openMorphInOverlay: self indicator]
]

{ #category : #'as yet unclassified' }
SBGroup >> addBlocksConnectedTo: aForceMoveDecorator [

	self add: aForceMoveDecorator.
	aForceMoveDecorator additionalForces do: [:force |
		force to withDecorator: SBForceMoveDecorator do: [:decorator | self add: decorator].
		force from withDecorator: SBForceMoveDecorator do: [:decorator | self add: decorator]]
]

{ #category : #accessing }
SBGroup >> blocks [

	^ blocks
]

{ #category : #accessing }
SBGroup >> blocks: anObject [

	blocks := anObject.
]

{ #category : #nil }
SBGroup >> computeVertices [
	
	| verticalEdges newVertices comingBlockTops seenBlockTops comingBlockBottoms seenBlockBottoms expandBy |
	verticalEdges := OrderedCollection new.
	
	expandBy := 10@10.
	
	self blocks do: [:aBlock |
		verticalEdges add: {(aBlock bounds expandBy: expandBy) left. #left . aBlock}.
		verticalEdges add: {(aBlock bounds expandBy: expandBy) right. #right . aBlock}].
	
	verticalEdges sort: [:a :b | a first < b first].
	
	newVertices := OrderedCollection new.
	comingBlockTops := self blocks collect: [:aBlock | (aBlock bounds expandBy: expandBy) top] as: SortedCollection.
	seenBlockTops := SortedCollection new.
	
	verticalEdges do: [:edge |
		| aBlock |
		aBlock := edge third.				
		edge second == #left
			ifTrue: [seenBlockTops add: (aBlock bounds expandBy: expandBy) top].
			
		comingBlockTops
			ifEmpty: [newVertices add: edge first @ seenBlockTops first]
			ifNotEmpty: [
				seenBlockTops
					ifEmpty: [newVertices add: edge first @ comingBlockTops first]
					ifNotEmpty: [newVertices add: edge first @ (comingBlockTops first max: seenBlockTops first)]].
				
		edge second == #left
			ifFalse: [comingBlockTops remove: (aBlock bounds expandBy: expandBy) top]].
		
	comingBlockBottoms := self blocks collect: [:aBlock | (aBlock bounds expandBy: expandBy) bottom] as: SortedCollection.
	seenBlockBottoms := SortedCollection new.
	
	verticalEdges reverseDo: [:edge |
		| aBlock |
		aBlock := edge third.
				
		edge second == #right
			ifTrue: [seenBlockBottoms add: (aBlock bounds expandBy: expandBy) bottom].
			
		comingBlockBottoms
			ifEmpty: [newVertices add: edge first @ seenBlockBottoms last]
			ifNotEmpty: [
				seenBlockBottoms
					ifEmpty: [newVertices add: edge first @ comingBlockBottoms last]
					ifNotEmpty: [newVertices add: edge first @ (comingBlockBottoms last min: seenBlockBottoms last)]].
				
		edge second == #right
			ifFalse: [comingBlockBottoms remove: (aBlock bounds expandBy: expandBy) bottom]].
	
	self setVertices: newVertices.
]

{ #category : #nil }
SBGroup >> computeVerticesOld [
	
	| verticalEdges newVertices activeBlockBottoms activeBlockTops |
	verticalEdges := OrderedCollection new.
	self blocks do: [:aBlock |
		verticalEdges add: {aBlock left. #left . aBlock}.
		verticalEdges add: {aBlock right. #right . aBlock}].
	
	verticalEdges sort: [:a :b | a first < b first].
	
	newVertices := OrderedCollection new.
	activeBlockTops := SortedCollection new.
	verticalEdges do: [:edge |
		| aBlock |
		aBlock := edge third.
		edge second == #left
			ifTrue: [activeBlockTops add: aBlock top].
		newVertices add: edge first @ activeBlockTops first.
		edge second == #left
			ifFalse: [activeBlockTops remove: aBlock top]].
	
	activeBlockBottoms := SortedCollection new.
	verticalEdges reverseDo: [:edge |
		| aBlock |
		aBlock := edge third.
		edge second == #right
			ifTrue: [activeBlockBottoms add: aBlock bottom].
		newVertices add: edge first @ activeBlockBottoms last.
		edge second == #right
			ifFalse: [activeBlockBottoms remove: aBlock bottom]].
	
	self setVertices: newVertices.
]

{ #category : #nil }
SBGroup >> computeVerticesRectangle [
	
	| newBounds |
	newBounds := nil. 
	self blocks do: [:aBlock | newBounds
		ifNil: [newBounds := aBlock bounds]
		ifNotNil:[newBounds := newBounds merge: aBlock bounds]].
	
	self bounds: newBounds
]

{ #category : #accessing }
SBGroup >> indicator [

	^ indicator
]

{ #category : #accessing }
SBGroup >> indicator: aMorph [

	indicator := aMorph.
]

{ #category : #nil }
SBGroup >> initialize [

	super initialize.
	self blocks: Set new.
	self indicator: nil.
]

{ #category : #nil }
SBGroup >> textContents [

	^  'Group'
]
