Class {
	#name : #SBInputBroadcaster,
	#superclass : #SBBlock,
	#instVars : [
		'listeners',
		'mice',
		'miceContainers'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #input }
SBInputBroadcaster >> absorbsInput: anEvent [

	^ true
]

{ #category : #accessing }
SBInputBroadcaster >> addListener: aMorph [

	self listeners add: aMorph.
	self mice add: CircleMorph newPin.
	
	"adding mice as our own morphs will cause rattling"
	self containers add: (Morph new 
		color: Color transparent;
		extent: aMorph extent).
	self containers last addMorph: aMorph.
	self containers last addMorph: mice last.
	
	^ self containers last
	
]

{ #category : #accessing }
SBInputBroadcaster >> containers [
	
	^ miceContainers
]

{ #category : #events }
SBInputBroadcaster >> filterEvent: anEvent for: aMorph [

	self listeners withIndexDo: [:aListener :i | | targetPosition newEvent |
		targetPosition := self translatedPositionOf: anEvent from: aMorph to: aListener.
		newEvent := anEvent copy.
		
		anEvent isDropEvent 
			ifTrue: [newEvent translateTo: targetPosition]
			ifFalse: [newEvent translateBy: targetPosition - anEvent position].
		
		aListener processEvent: newEvent.
		(self mice at: i) position: targetPosition.
		
		(aListener containsPoint: targetPosition) 
			ifTrue: [(self mice at: i) show]
			ifFalse: [(self mice at: i) hide]].
	
	^ anEvent
]

{ #category : #'events-processing' }
SBInputBroadcaster >> handleMouseOver: anEvent [

	super handleMouseOver: anEvent.
	anEvent hand newKeyboardFocus: self.
	self sandblockEditor selectNoInput: self.
]

{ #category : #'event handling' }
SBInputBroadcaster >> handlesKeyboard: evt [
	
	^ true

]

{ #category : #initialization }
SBInputBroadcaster >> initialize [ 

	super initialize.
	
	listeners := OrderedCollection new.
	mice := OrderedCollection new.
	miceContainers := OrderedCollection new.
	
	self 
		addEventCaptureFilter: self;
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		canDrag: false;
		color: Color veryLightGray
		
]

{ #category : #accessing }
SBInputBroadcaster >> listeners [
	
	^ listeners
]

{ #category : #accessing }
SBInputBroadcaster >> mice [

	^ mice
]

{ #category : #'events-processing' }
SBInputBroadcaster >> mouseEnter: anEvent [

	super mouseEnter: anEvent.
	anEvent hand newKeyboardFocus: self.
]

{ #category : #events }
SBInputBroadcaster >> translatedPositionOf: anEvent from: anOriginMorph to: aTargetMorph [ 

	| localAbsPoint localRelPoint targetAbsPoint |
	localAbsPoint := anEvent position - anOriginMorph position.
	localRelPoint := localAbsPoint / anOriginMorph extent.
	targetAbsPoint := (localRelPoint * aTargetMorph extent) + aTargetMorph position.
	
	^ targetAbsPoint rounded
]

{ #category : #'event handling' }
SBInputBroadcaster >> wantsKeyboardFocus [

	^ true
]
