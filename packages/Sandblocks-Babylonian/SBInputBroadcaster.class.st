Class {
	#name : #SBInputBroadcaster,
	#superclass : #Morph,
	#instVars : [
		'listeners'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #events }
SBInputBroadcaster >> filterEvent: anEvent for: aMorph [

	self flag: #todo. "Die Position im Morph in den listener transformieren"
	self listeners do: [:aListener | aListener processEvent: (anEvent copy position: aListener position)].
	^ anEvent
]

{ #category : #'events-processing' }
SBInputBroadcaster >> handleMouseOver: anEvent [

	super handleMouseOver: anEvent.
	anEvent hand newKeyboardFocus: self.

]

{ #category : #'event handling' }
SBInputBroadcaster >> handlesKeyboard: evt [
	
	^ true

]

{ #category : #initialization }
SBInputBroadcaster >> initialize [ 

	super initialize.
	
	listeners := OrderedCollection new.
	
	self 
		addKeyboardCaptureFilter: self;
		"addMouseCaptureFilter: self;"
		extent: 300@200;
		color: Color veryLightGray;
		changeTableLayout;
		listDirection: #topToBottom;
		wrapCentering: #center;
		listCentering: #center;
		addMorph: (StringMorph new 
			contents: 'Enter Input here';
			color: Color white;
			yourself)
		
]

{ #category : #accessing }
SBInputBroadcaster >> listeners [
	
	^ listeners
]

{ #category : #accessing }
SBInputBroadcaster >> listeners: aCollectionOfMorphs [

	listeners := aCollectionOfMorphs.
]
