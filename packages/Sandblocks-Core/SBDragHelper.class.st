Class {
	#name : #SBDragHelper,
	#superclass : #Object,
	#instVars : [
		'editor',
		'currentDropLocation',
		'morph',
		'onLeave',
		'blockBounds'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDragHelper class >> for: anEvent in: anEditor [

	^ self new
		editor: anEditor;
		morph: anEvent hand firstSubmorph
]

{ #category : #'as yet unclassified' }
SBDragHelper >> blockAtPoint: aPoint [

	| best bestArea |
	best := nil.
	bestArea := 900000000.
	
	blockBounds keysAndValuesDo: [:block :bounds |
		((bounds containsPoint: aPoint) and: [bounds area < bestArea]) ifTrue: [
			best := block.
			bestArea := bounds area]].
	
	^ best ifNotNil: #containingSandblock
]

{ #category : #'as yet unclassified' }
SBDragHelper >> boundsOf: aMorph [

	^ blockBounds at: aMorph
]

{ #category : #'as yet unclassified' }
SBDragHelper >> closestAdjacentTo: aPoint in: aMorph do: aBlock [

	^ self submorphOf: aMorph closestTo: aPoint do: [:candidate :before |
		aBlock
			value: (candidate ifNotNil: [ | block |
				block := candidate containingSandblock.
				block = aMorph ifTrue: [nil] ifFalse: [block]])
			value: before]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> delete [

	self dropLocation: #(#none nil)
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocation: dropLocation [

	currentDropLocation ifNotNil: [
		onLeave ifNotNil: [
			onLeave value.
			onLeave := nil]].
	
	currentDropLocation := dropLocation.
	dropLocation ifNotNil: [
		dropLocation first = #insert ifTrue: [
			self hintInsertWith: (currentDropLocation second
				insertCommandRequest: morph
				near: dropLocation third
				before: dropLocation fourth)].
		dropLocation first = #replace ifTrue: [self hintReplaceOf: dropLocation second]]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> editor: anEditor [

	editor := anEditor.
	
	blockBounds := Dictionary new.
	anEditor allMorphsDo: [:morph | morph ~= anEditor ifTrue: [blockBounds at: morph put: morph boundsInWorld]]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintInsertWith: aCommand [

	aCommand do.
	onLeave := [aCommand undo]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintReplaceOf: aMorph [

	aMorph attachDecorator: (SBDropPreviewDecorator new outline: true).
	onLeave := [aMorph detachDecorators: SBDropPreviewDecorator]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> initialize [

	currentDropLocation := #(#none nil)
]

{ #category : #'as yet unclassified' }
SBDragHelper >> morph: aMorph [

	morph := aMorph unpackSelection veryDeepCopy.
	morph isSandblock ifTrue: [
		morph allBlocksDo: [:block | block attachDecorator: SBDropPreviewDecorator new]]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> mouseMove: anEvent [

	| blockAtCursor dropLocation |
	blockAtCursor := self blockAtPoint: anEvent position.
	
	dropLocation := blockAtCursor
		ifNotNil: [
			blockAtCursor fixedNumberOfChildren
				ifTrue: [{#replace. blockAtCursor}]
				ifFalse: [
					self
						closestAdjacentTo: anEvent position
						in: blockAtCursor
						do: [:adjacent :before | {#insert. blockAtCursor. adjacent. before}]]]
		ifNil: [#(#none nil)].
	
	(currentDropLocation hasEqualElements: dropLocation) ifFalse: [self dropLocation: dropLocation]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> submorphOf: aMorph closestTo: aPoint do: aBlock [

	| before best bestDistance |
	before := false.
	best := nil.
	bestDistance := 900000000.
	
	aMorph submorphs do: [:morph | | distance |
		blockBounds at: morph ifPresent: [:bounds |
			distance := bounds topLeft dist: aPoint.
			distance < bestDistance ifTrue: [
				best := morph.
				before := true.
				bestDistance := distance].
			
			distance := bounds bottomRight dist: aPoint.
			distance < bestDistance ifTrue: [
				best := morph.
				before := false.
				bestDistance := distance]]].
	
	^ aBlock value: best value: before
]
