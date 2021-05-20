"
A SBMorphDecorator will add some functionality to the morph it is attached to. This may include drawing before or after the morph, stepping with the morph, or listening for events.
"
Class {
	#name : #SBBlockDecorator,
	#superclass : #Object,
	#instVars : [
		'morph'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #callbacks }
SBBlockDecorator >> attached: aMorph [

	morph := aMorph
]

{ #category : #'change reporting' }
SBBlockDecorator >> changed [

	self morph changed
]

{ #category : #actions }
SBBlockDecorator >> detach [

	self morph ifNotNil: [:m | m detachDecorator: self]
]

{ #category : #callbacks }
SBBlockDecorator >> detached: aMorph [

	morph := nil
]

{ #category : #stepping }
SBBlockDecorator >> installEventBroadcasterFor: aMorph [

	aMorph eventHandler
		ifNotNil: [self assert: (aMorph eventHandler isKindOf: SBEventBroadcast)]
		ifNil: [aMorph eventHandler: SBEventBroadcast new].
	
	^ aMorph eventHandler
]

{ #category : #accessing }
SBBlockDecorator >> morph [

	^ morph
]

{ #category : #accessing }
SBBlockDecorator >> mouseCursorAt: anEvent [

	^ nil
]

{ #category : #drawing }
SBBlockDecorator >> postDrawOn: aCanvas [

	
]

{ #category : #'as yet unclassified' }
SBBlockDecorator >> postDrawSelfOn: aCanvas [

	
]

{ #category : #drawing }
SBBlockDecorator >> preDrawOn: aCanvas [

	
]

{ #category : #stepping }
SBBlockDecorator >> shouldGetStepsFrom: aWorld [

	^ morph notNil and: [morph world == aWorld]
]

{ #category : #stepping }
SBBlockDecorator >> step [
]

{ #category : #stepping }
SBBlockDecorator >> stepTime [
	" return >= 0 if you want to get regular steps sent "

	^ -1
]

{ #category : #stepping }
SBBlockDecorator >> uninstallEventBroadcaster [

	self morph eventHandler removeActionsWithReceiver: self
]

{ #category : #drawing }
SBBlockDecorator >> world [

	^ self morph ifNotNil: [:m | m world]
]
