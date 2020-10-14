Class {
	#name : #SBRepresentationPrompt,
	#superclass : #SBBlock,
	#instVars : [
		'options',
		'target',
		'currentRepresentation',
		'selectedIndex',
		'sourceMorph',
		'position',
		'scroll'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> candidates [

	^ options submorphs select: [:m | m visible]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> childSandblocksDo: aBlock [

	options submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> close [

	self delete.
	Project current addDeferredUIMessage: [currentRepresentation select]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> filterKeyStroke: anEvent [

	anEvent keyCharacter = Character cr ifTrue: [self close].
	anEvent keyCharacter = Character arrowDown ifTrue: [self select: selectedIndex + 1].
	anEvent keyCharacter = Character arrowUp ifTrue: [self select: selectedIndex - 1]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> hasUnsavedChanges: aBoolean [

	
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> initialize [

	super initialize.
	selectedIndex := 1.
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4;
		layoutInset: 4;
		addDropShadow;
		addMorphBack: (SBStringMorph new
			contents: 'Change Repr:';
			bold);
		addMorphBack: (SBTextBubble new
			prefix: 'Filter: ';
			when: #contentsChanged send: #updateFilter to: self;
			when: #stopEditing send: #close to: self;
			when: #keyStroke send: #filterKeyStroke: to: self);
		addMorphBack: (scroll := ScrollPane new
			hResizing: #shrinkWrap;
			vResizing: #rigid;
			height: 150).
	
	scroll scroller addMorphBack: (options := SBColumn new)
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	Project current addDeferredUIMessage: [
		self sandblockEditor startInput: self submorphs second at: 1 replacingContents: true]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> mouseEnter: anEvent [

	self removeAlarm: #delete
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> mouseLeave: anEvent [

	SBToggledCode comment: '' active: 0 do: {
		[
			self addAlarm: #delete after: 1 seconds asMilliSeconds]
	}
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> object [

	^ nil
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> options: aCollection target: anObject at: aPoint from: aSourceMorph [

	SBExample
		self: [SBRepresentationPrompt new]
		args: [
			{(5 representationsThat: #isToplevelMorph). 5. nil}]
		label: 'example'.
	target := anObject.
	position := aPoint.
	sourceMorph := aSourceMorph.
	
	aCollection do: [:option |
		options addMorphBack: (SBTextBubble new
			prefix: (option causesSideEffects ifTrue: ['/!\ '] ifFalse: [nil]);
			contents: option prettyName;
			setProperty: #representation toValue: option;
			when: #selected send: #useRepresentation: to: self with: option)].
	currentRepresentation
		when: #positionChanged send: #updatePosition to: self;
		when: #extentChanged send: #updatePosition to: self.
	SBToggledCode
		comment: ''
		active: 0
		do: {
			[
				Project current addDeferredUIMessage: [
					self addAlarm: #delete after: 2 seconds asMilliSeconds]]
		}.
	self select: (aCollection findFirst: [:option | option causesSideEffects not]).
	self allMorphsDo: #layoutChanged
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> options: aCollection target: anObject current: aRepresentation [

	SBExample
		self: [SBRepresentationPrompt new]
		args: [
			{(5 representationsThat: #isToplevelMorph). 5. nil}]
		label: 'example'.
	currentRepresentation := aRepresentation.
	target := anObject.
	
	aCollection do: [:option |
		options addMorphBack: (SBTextBubble new
			prefix: (option causesSideEffects ifTrue: ['/!\ '] ifFalse: [nil]);
			contents: option prettyName;
			setProperty: #representation toValue: option;
			when: #selected send: #useRepresentation: to: self with: option)].
	currentRepresentation
		when: #positionChanged send: #updatePosition to: self;
		when: #extentChanged send: #updatePosition to: self.
	SBToggledCode
		comment: ''
		active: 0
		do: {
			[
				Project current addDeferredUIMessage: [
					self addAlarm: #delete after: 2 seconds asMilliSeconds]]
		}.
	self select: (aCollection findFirst: [:option | option causesSideEffects not])
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> select: aNumber [

	| candidates |
	candidates := self candidates.
	options submorphsDo: [:m | m detachDecorators: SBMultiSelectionDecorator].
	selectedIndex := aNumber clampLow: 1 high: candidates size.
	candidates ifNotEmpty: [ | selected |
		selected := candidates at: selectedIndex.
		selected attachDecorator: SBMultiSelectionDecorator new.
		scroll scrollToShow: (selected bounds expandBy: 0 @ 50).
		self sandblockEditor ifNotNil: [
			self useRepresentation: (selected valueOfProperty: #representation)]]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> updateFilter [

	| filter |
	filter := self submorphs second contents.
	options submorphsDo: [:morph | | visible |
		visible := filter isEmpty or: [
			(morph contents findString: filter startingAt: 1 caseSensitive: false) > 0].
		morph
			visible: visible;
			disableLayout: visible not].
	self select: 1
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> updatePosition [

	SBToggledCode
		comment: 'No idea why this is necessary, but otherwise we''re at 0@0'
		active: 1
		do: {
			[
				currentRepresentation owner ifNotNil: [:m | m layoutChanged fullBounds]]
		}.
	self position: currentRepresentation right @ self top
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> useRepresentation: aRepresentation [

	| newRepresentation |
	newRepresentation := aRepresentation newFor: target.
	
	currentRepresentation
		ifNotNil: [:c |
			c removeActionsWithReceiver: self.
			newRepresentation position: currentRepresentation position.
			
			currentRepresentation replaceBy: newRepresentation.
			newRepresentation center: currentRepresentation center]
		ifNil: [
			self sandblockEditor openMorphInView: newRepresentation.
			newRepresentation position: position].
	
	self flag: #todo.
	currentRepresentation := newRepresentation.
	self updatePosition.
	newRepresentation
		when: #positionChanged send: #updatePosition to: self;
		when: #extentChanged send: #updatePosition to: self.
	
	sourceMorph ifNotNil: [
		newRepresentation owner addMorphBack: (SBRepresentationConnector connect: sourceMorph to: newRepresentation representation: aRepresentation)]
]
