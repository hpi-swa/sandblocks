Class {
	#name : #SBResizableDecorator,
	#superclass : #SBBlockDecorator,
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
SBResizableDecorator >> mouseDown: anEvent [

	(self relevantPosition: anEvent) ifTrue: [ | startExtent startPosition handle |
		anEvent hand future resetClickState.
		startExtent := self morph extent.
		startPosition := self morph pointInWorld: anEvent position.
		handle := HandleMorph new forEachPointDo: [:newPoint | self morph extent: startExtent + (newPoint - startPosition)].
		anEvent hand attachMorph: handle.
		handle startStepping]
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> mouseLeave: anEvent [

	Cursor normal show
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> mouseMove: anEvent [

	(self relevantPosition: anEvent) ifTrue: [Cursor resizeBottomRight show] ifFalse: [Cursor normal show]
]

{ #category : #'as yet unclassified' }
SBResizableDecorator >> relevantPosition: anEvent [

	^ (self morph bottomRight - self clickSize extent: self clickSize) containsPoint: anEvent position
]
