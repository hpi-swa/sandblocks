Class {
	#name : #SBRepresentationPrompt,
	#superclass : #SBBlock,
	#instVars : [
		'options',
		'target',
		'currentRepresentation',
		'selectedIndex'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> candidates [

	^ (self submorphs copyFrom: 3 to: self submorphCount) select: [:m | m visible]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> childSandblocksDo: aBlock [

	self submorphs allButFirstDo: aBlock
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
			when: #keyStroke send: #filterKeyStroke: to: self)
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
	self select: 1
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> select: aNumber [

	| candidates |
	candidates := self candidates.
	self submorphs from: 3 to: self submorphCount do: [:m | m detachDecorators: SBMultiSelectionDecorator].
	selectedIndex := aNumber clampLow: 1 high: candidates size.
	candidates ifNotEmpty: [ | selected |
		selected := candidates at: selectedIndex.
		selected attachDecorator: SBMultiSelectionDecorator new.
		self sandblockEditor ifNotNil: [
			self useRepresentation: (selected valueOfProperty: #representation)]]
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> updateFilter [

	(self submorphs allButFirst: 2) do: [:morph | | visible |
		visible := (morph contents findString: self submorphs second contents startingAt: 1 caseSensitive: false) > 0.
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
	self position: currentRepresentation topRight
]

{ #category : #'as yet unclassified' }
SBRepresentationPrompt >> useRepresentation: aRepresentation [

	| newRepresentation |
	newRepresentation := aRepresentation newFor: target.
	newRepresentation position: newRepresentation position.
	currentRepresentation removeActionsWithReceiver: self.
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				currentRepresentation sandblockEditor do: (SBReplaceCommand newNonEdit
					target: currentRepresentation;
					replacer: newRepresentation)].
			[
				currentRepresentation replaceBy: newRepresentation.
				newRepresentation center: currentRepresentation center]
		}.
	self flag: #todo.
	currentRepresentation := newRepresentation.
	self updatePosition.
	newRepresentation
		when: #positionChanged send: #updatePosition to: self;
		when: #extentChanged send: #updatePosition to: self
]
