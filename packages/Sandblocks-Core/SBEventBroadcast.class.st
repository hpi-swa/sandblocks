"
A SBMoveDecorator will allow dragging a morph (without lifting it). If preventOcclusion is set to true, it will also step to ensure that no other sibling morphs overlap its morph.
"
Class {
	#name : #SBEventBroadcast,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'lastDragPosition',
		'velocity',
		'preventOcclusion'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'event handling' }
SBEventBroadcast >> doubleClick: anEvent fromMorph: aMorph [

	self triggerEvent: #doubleClick with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> doubleClickTimeout: anEvent fromMorph: aMorph [

	self triggerEvent: #doubleClickTimeout with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesClickOrDrag: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesGestureStart: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesKeyboard: anEvent [

	^ false
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseMove: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseOverDragging: anEvent [

	^ false
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseStillDown: anEvent [

	^ false
]

{ #category : #'event handling' }
SBEventBroadcast >> handlesMouseWheel: anEvent [

	^ false
]

{ #category : #'event handling' }
SBEventBroadcast >> keyStroke: anEvent fromMorph: aMorph [

	self triggerEvent: #keyStroke with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> mouseDown: anEvent fromMorph: aMorph [

	self triggerEvent: #mouseDown with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> mouseEnter: anEvent fromMorph: aMorph [

	self triggerEvent: #mouseEnter with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> mouseLeave: anEvent fromMorph: aMorph [

	self triggerEvent: #mouseLeave with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> mouseMove: anEvent fromMorph: aMorph [

	self triggerEvent: #mouseMove with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> mouseUp: anEvent fromMorph: aMorph [

	self triggerEvent: #mouseUp with: anEvent
]

{ #category : #'event handling' }
SBEventBroadcast >> startDrag: anEvent fromMorph: aMorph [

	self triggerEvent: #startDrag with: anEvent
]
