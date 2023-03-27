"
I am a HandMorph that supports simply simulated control.
"
Class {
	#name : #SBHandMorph,
	#superclass : #HandMorph,
	#instVars : [
		'eventQueue'
	],
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #private }
SBHandMorph >> activateWithEvent: anEvent during: aBlock [

	thisContext
		wrap: [:block | self world becomeActiveDuring: block];
		wrap: [:block | self becomeActiveDuring: block];
		wrap: [:block | anEvent becomeActiveDuring: block].
	^ aBlock value
]

{ #category : #'event queue' }
SBHandMorph >> dequeueEvent [

	^ eventQueue removeFirst
]

{ #category : #'event queue' }
SBHandMorph >> hasQueuedEvents [

	^ eventQueue notEmpty
]

{ #category : #initialization }
SBHandMorph >> initialize [

	super initialize.
	eventQueue := OrderedCollection new.
]

{ #category : #initialization }
SBHandMorph >> owner: aMorph [

	self privateOwner: aMorph.
]

{ #category : #'event simulation' }
SBHandMorph >> processEvent: anEvent in: aMorph [

	| result |
	self activateWithEvent: anEvent during: [
		result := aMorph processEvent: anEvent].
	^ result == #rejected ifTrue: [anEvent] ifFalse: [result "filtered event"]
]

{ #category : #'event handling' }
SBHandMorph >> processEvents [
	"Process user input events from the local input devices. Copied from base class, but we don't use EventSensor but our own event query. Also, we don't update z-order here if ActiveEvent is present." <flag: #ct "Is this a problem?">

	| evt hadAny |
	hadAny := false.
	[self hasQueuedEvents] whileTrue: 
			[evt := self dequeueEvent.	"for unknown event types"
			self handleEvent: evt.
			hadAny := true.
			"For better user feedback, return immediately after a mouse event has been processed."
			evt isMouse ifTrue: [^ self]].
	"note: if we come here we didn't have any mouse events"
	mouseClickState notNil 
		ifTrue: 
			["No mouse events during this cycle. Make sure click states time out accordingly"
			mouseClickState handleEvent: lastMouseEvent asMouseMove from: self].
	hadAny 
		ifFalse: 
			["No pending events. Make sure z-order is up to date"
			self mouseOverHandler processMouseOver: lastMouseEvent]
]

{ #category : #'event simulation' }
SBHandMorph >> processNewEvent: anEvent [

	self queueEvent: anEvent.
	self processEvents.
]

{ #category : #'event queue' }
SBHandMorph >> queueEvent: anEvent [

	^ eventQueue addLast: anEvent
]

{ #category : #private }
SBHandMorph >> sendFocusEvent: anEvent to: focusHolder clear: aBlock [
	"Send the event to the morph currently holding the focus"

	self activateWithEvent: anEvent during: [
		^ focusHolder processFocusEvent:
			(anEvent transformedBy: (focusHolder transformedFrom: self))]
]
