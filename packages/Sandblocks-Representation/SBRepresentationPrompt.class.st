Class {
	#name : #SBRepresentationPrompt,
	#superclass : #SBBlock,
	#instVars : [
		'options',
		'target',
		'currentRepresentation'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> childSandblocksDo: aBlock [

	self submorphs allButFirstDo: aBlock
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> initialize [

	super initialize.
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4;
		layoutInset: 4;
		addDropShadow;
		addMorphBack: (SBStringMorph new
			contents: 'Change Repr:';
			bold)
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> mouseEnter: anEvent [

	self removeAlarm: #delete
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> mouseLeave: anEvent [

	self addAlarm: #delete after: 1 seconds asMilliSeconds
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> options: aCollection target: anObject current: aRepresentation [

	SBExample
		self: [SBRepresentationPrompt new]
		args: [
			{(5 representationsThat: #isToplevelMorph). 5. nil}]
		label: 'example'.
	
	options := aCollection.
	currentRepresentation := aRepresentation.
	target := anObject.
	options do: [:option |
		self addMorphBack: (SBTextBubble new
			contents: option prettyName;
			when: #selected send: #useRepresentation: to: self with: option)].
	
	Project current addDeferredUIMessage: [
		self addAlarm: #delete after: 2 seconds asMilliSeconds]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> useRepresentation: aRepresentation [

	| newRepresentation |
	newRepresentation := aRepresentation newFor: target.
	newRepresentation position: newRepresentation position.
	
	currentRepresentation sandblockEditor do: ((SBReplaceCommand newNonEdit) target: currentRepresentation; replacer: newRepresentation).
	
	self flag: #todo. " use mutate command "
	currentRepresentation := newRepresentation
]
