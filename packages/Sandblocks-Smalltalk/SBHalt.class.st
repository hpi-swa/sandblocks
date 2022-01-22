Class {
	#name : #SBHalt,
	#superclass : #SBStSubstitution,
	#instVars : [
		'activeIcon',
		'active'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBHalt class >> deactivated [

	" marker "
]

{ #category : #suggestions }
SBHalt class >> instanceSuggestion [

	^ [self new]
]

{ #category : #testing }
SBHalt class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock selector = 'sandblocksHalt' and: [aBlock receiver notNil]) or: [(aBlock receiver satisfies: #(#notNil #isName)) and: [aBlock receiver contents = 'SBHalt' and: [aBlock selector = #deactivated]]]
]

{ #category : #'instance creation' }
SBHalt class >> newFor: aBlock [

	^ self new active: aBlock selector ~= #deactivated
]

{ #category : #'as yet unclassified' }
SBHalt >> active [

	^ active
]

{ #category : #'as yet unclassified' }
SBHalt >> active: aBoolean [

	active := aBoolean.
	activeIcon color: (aBoolean ifTrue: [Color red lighter] ifFalse: [Color white alpha: 0.7])
]

{ #category : #'as yet unclassified' }
SBHalt >> doubleClick: anEvent [

	super doubleClick: anEvent.
	self toggleActive
]

{ #category : #'as yet unclassified' }
SBHalt >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBHalt >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 10 @ 4;
		addMorphBack: (activeIcon := SBIcon iconBug);
		active: true
]

{ #category : #'as yet unclassified' }
SBHalt >> toggleActive [

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #active;
		value: active not)
]

{ #category : #'as yet unclassified' }
SBHalt >> writeSourceOn: aStream [

	active
		ifTrue: [aStream nextPutAll: 'self sandblocksHalt']
		ifFalse: [aStream nextPutAll: 'SBHalt deactivated']
]
