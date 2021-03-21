Class {
	#name : #SBResizableDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'edge'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBResizableDecorator >> attached: aMorph [

	super attached: aMorph.
	(self installEventBroadcasterFor: aMorph)
		when: #mouseMove send: #mouseMove: to: self;
		when: #mouseDown send: #mouseDown: to: self;
		when: #mouseLeave send: #mouseLeave: to: self
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> clickSize [

	^ 10
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> edge: aSymbol [

	edge := aSymbol
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> mouseDown: anEvent [

	(self relevantPosition: anEvent) ifTrue: [ | startExtent startPosition handle |
		anEvent hand future resetClickState.
		startExtent := self morph extent.
		startPosition := self morph pointInWorld: anEvent position.
		handle := HandleMorph new forEachPointDo: [:newPoint |
			self morph extent: (startExtent + (newPoint - startPosition) max: self morph minimumExtent)].
		anEvent hand attachMorph: handle.
		handle startStepping]
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> mouseLeave: anEvent [

	Cursor normal show
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> mouseMove: anEvent [

	((self relevantPosition: anEvent)
		ifTrue: [
			edge
				ifNotNil: [Cursor perform: ('resize', edge capitalized) asSymbol]
				ifNil: [Cursor resizeBottomRight]]
		ifFalse: [Cursor normal]) show
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> relevantPosition: anEvent [

	(self morph morphsAt: anEvent position) first ~= self morph ifTrue: [^ false].

	edge ifNotNil: [ | distance |
		distance := (((anEvent position extent: 0 @ 0) perform: edge) - (self morph perform: edge)) abs.
		^ distance < self clickSize].

	^ (self morph bottomRight - self clickSize extent: self clickSize) containsPoint: anEvent position
]
