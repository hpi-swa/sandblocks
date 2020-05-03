Class {
	#name : #SBHalt,
	#superclass : #SBSubstitution,
	#instVars : [
		'activeIcon',
		'active'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHalt class >> deactivated [

	" marker "
]

{ #category : #'as yet unclassified' }
SBHalt class >> matches: aBlock [

	^ aBlock selector = 'halt' or: [aBlock receiver isName and: [aBlock receiver contents = 'SBHalt' and: [aBlock selector = #deactivated]]]
]

{ #category : #'as yet unclassified' }
SBHalt class >> newFrom: aBlock [

	^ self new active: (aBlock selector ~= #deactivated)
]

{ #category : #'as yet unclassified' }
SBHalt class >> suggestion [

	^ [:block | block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
		target: block;
		replacer: SBHalt new)]
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
SBHalt >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBHalt >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBHalt >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: (10 @ 4) withScalingFactor;
		addMorphBack: (activeIcon := SBIcon iconBug);
		on: #doubleClick send: #toggleActive to: self;
		active: true
]

{ #category : #'as yet unclassified' }
SBHalt >> textContents [

	^ 'halt'
]

{ #category : #'as yet unclassified' }
SBHalt >> toggleActive [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #active;
		value: active not)
]

{ #category : #'as yet unclassified' }
SBHalt >> writeSourceOn: aStream [

	active
		ifTrue: [aStream nextPutAll: '(self halt)']
		ifFalse: [aStream nextPutAll: 'SBHalt deactivated']
]
