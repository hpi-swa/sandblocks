Class {
	#name : #SBWatch,
	#superclass : #SBBlock,
	#instVars : [
		'identifier',
		'expression',
		'display'
	],
	#classVars : [
		'Registry',
		'WatchViewClass'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWatch class >> registerWatch: aWatch [

	self registry add: aWatch
]

{ #category : #'as yet unclassified' }
SBWatch class >> registry [

	Registry isDictionary ifTrue: ["convert to current version"
	Registry := Registry values as: WeakSet].
	^ Registry ifNil: [Registry := WeakSet new]
]

{ #category : #'as yet unclassified' }
SBWatch class >> report: aValue for: identifier [

	| reg watchers |
	reg := self registry.
	watchers := reg select: [:watcher | watcher notNil and: [watcher identifier = identifier]].
	watchers do: [:watcher | watcher reportValue: aValue].
	
	^ aValue
]

{ #category : #'as yet unclassified' }
SBWatch class >> unregisterWatch: aWatch [

	self registry remove: aWatch ifAbsent: []
]

{ #category : #'as yet unclassified' }
SBWatch class >> watchViewClass [

	^ WatchViewClass ifNil: [SBWatchView]
]

{ #category : #'as yet unclassified' }
SBWatch class >> watchViewClass: aClass [

	WatchViewClass := aClass
]

{ #category : #'as yet unclassified' }
SBWatch >> actionProviders [

	^ {self grammarHandler. self}
]

{ #category : #testing }
SBWatch >> canAppearInBlockBody [

	^ true
]

{ #category : #actions }
SBWatch >> chooseViewMode [
	<action>

	display promptChangeDisplay
]

{ #category : #'event handling' }
SBWatch >> click: anEvent [

	super click: anEvent
]

{ #category : #'colors and color policies' }
SBWatch >> color [

	^ self parentSandblock color
]

{ #category : #'event handling' }
SBWatch >> doubleClick: anEvent [

	self sandblockEditor do: (SBReplaceCommand new
		replacer: self expression;
		target: self)
]

{ #category : #'colors and color policies' }
SBWatch >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBWatch >> evaluate [

	| result |
	result := self expression evaluate.
	self reportValue: result.
	^ result
]

{ #category : #actions }
SBWatch >> exploreLastValue [
	<action>

	display exploreLastValue
]

{ #category : #accessing }
SBWatch >> expression [

	^ self firstSubmorph
]

{ #category : #accessing }
SBWatch >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock
]

{ #category : #accessing }
SBWatch >> grammarHandler [

	^ self parentSandblock ifNotNil: #grammarHandler
]

{ #category : #accessing }
SBWatch >> identifier [

	^ identifier
]

{ #category : #accessing }
SBWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #initialization }
SBWatch >> initialize [

	super initialize.
	
	self
		cellGap: 4;
		layoutInset: 2;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (display := self class watchViewClass new)
]

{ #category : #initialization }
SBWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #testing }
SBWatch >> isExpression [

	^ true
]

{ #category : #layout }
SBWatch >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self submorphs first layoutCommands.
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: self submorphs second}
]

{ #category : #'event handling' }
SBWatch >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #accessing }
SBWatch >> object [

	^ self
]

{ #category : #initialization }
SBWatch >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self class unregisterWatch: self
]

{ #category : #caching }
SBWatch >> postDuplicateSelf [

	super postDuplicateSelf.
	self newIdentifier
]

{ #category : #printing }
SBWatch >> printOn: aStream [

	aStream nextPutAll: 'watch '.
	self expression printOn: aStream
]

{ #category : #'as yet unclassified' }
SBWatch >> reportValue: anObject [

	display reportValue: anObject
]

{ #category : #actions }
SBWatch >> storeAsExample [
	<action>

	display storeAsExample
]

{ #category : #copying }
SBWatch >> veryDeepCopyWith: deepCopier [

	| new oldDisplay |
	" assure that copies of us have a unique id "
	oldDisplay := display.
	display := self class watchViewClass new.
	oldDisplay replaceBy: display.
	
	new := super veryDeepCopyWith: deepCopier.
	
	display replaceBy: oldDisplay.
	display := oldDisplay.
	
	^ new
]

{ #category : #printing }
SBWatch >> writeSourceOn: aStream [

	self grammarHandler writeSourceOn: aStream for: self
]

{ #category : #'as yet unclassified' }
SBWatch >> writeSourceOn: aStream indent: aNumber [

	self writeSourceOn: aStream
]
