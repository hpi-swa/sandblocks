Class {
	#name : #SBInputBroadcaster,
	#superclass : #SBBlock,
	#instVars : [
		'listeners',
		'mice',
		'miceContainers',
		'stateHands'
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
	self mice add: CircleMorph newPin hide.
	self stateHands add: HandMorph new.
	
	"adding mice as our own morphs will cause rattling"
	self containers add: (Morph new 
		color: Color transparent;
		extent: aMorph extent;
		setProperty: #sbListener toValue: aMorph;
		yourself).
	self containers last addAllMorphsBack: {mice last. aMorph.}.
	
	^ self containers last
	
]

{ #category : #accessing }
SBInputBroadcaster >> containers [
	
	^ miceContainers
]

{ #category : #events }
SBInputBroadcaster >> eventProcessMouse: aMouse goingTo: aPosition in: aMorph [
		
	aMouse position: aPosition.
	(aMorph containsPoint: aPosition) 
		ifTrue: [aMouse show]
		ifFalse: [aMouse hide]
]

{ #category : #events }
SBInputBroadcaster >> filterEvent: anEvent for: aMorph [


	self listeners withIndexDo: [:aListener :i | 
		| localTarget newEvent delta |
		localTarget := self translatedPositionOf: anEvent from: aMorph to: aListener.
		delta := localTarget - anEvent position.
		newEvent := anEvent copy translateBy: delta.

		(self needsHandHandling: newEvent)
				ifTrue: [
					self simulateGlobalHand: (self stateHands at: i) 
						for: newEvent 
						in: aListener 
						pos: self activeHand position +  delta.]
				ifFalse: [aListener processEvent: newEvent.].
		
		self eventProcessMouse: (self mice at: i) 
			goingTo: localTarget 
			in: aListener.].
	
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
	stateHands := OrderedCollection new.
	
	self 
		addEventCaptureFilter: self;
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		canDrag: false;
		color: Color veryLightGray
		
]

{ #category : #accessing }
SBInputBroadcaster >> insertListener: aListener into: aContainer [

	| index |
	index := self containers indexOf: aContainer ifAbsent: [^ self].
	
	(self containers at: index) 
		addMorphBack: aListener;
		extent: aListener extent;
		setProperty: #sbListener toValue: aListener.
	
	aListener topLeft: (self containers at: index) topLeft.
	self listeners at: index put: aListener.
	
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
SBInputBroadcaster >> needsHandHandling: anEvent [

	^ anEvent isMouse 
			and: [anEvent isMouseDown or: [anEvent isMouseUp]]
			and: [(SBPreferences rightClickContextMenu and: [anEvent yellowButtonPressed]) not]
]

{ #category : #accessing }
SBInputBroadcaster >> replaceListener: oldListener with: newListener [

	| index |
	index := self listeners indexOf: oldListener ifAbsent: [^ self].
	
	(self containers at: index) 
		replaceSubmorph: (self listeners at: index) 
		by: newListener;
		extent: newListener extent;
	 	setProperty: #sbListener toValue: newListener. 
	self listeners at: index put: newListener.
]

{ #category : #events }
SBInputBroadcaster >> simulateGlobalHand: aHand for: anEvent in: aMorph pos: aPosition [

	aMorph owner ifNotNil: [:theOwner | theOwner addMorphBack: aHand].
	
	anEvent 
		position: aPosition;
		setHand: aHand.
	aHand handleEvent: anEvent.
	
	aHand delete.
]

{ #category : #accessing }
SBInputBroadcaster >> stateHands [

	^ stateHands
]

{ #category : #events }
SBInputBroadcaster >> translatedPositionOf: anEvent from: anOriginMorph to: aTargetMorph [ 

	| localAbsPoint localRelPoint targetAbsPoint |
	localAbsPoint := anEvent position - anOriginMorph position.
	localRelPoint := localAbsPoint / anOriginMorph extent.
	localRelPoint := (localRelPoint x clampLow: 0 high: 1)@(localRelPoint y clampLow: 0 high: 1).	
	targetAbsPoint := (localRelPoint * aTargetMorph extent) + aTargetMorph position.
	
	^ targetAbsPoint rounded
]

{ #category : #'event handling' }
SBInputBroadcaster >> wantsKeyboardFocus [

	^ true
]
