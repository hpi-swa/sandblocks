Class {
	#name : #SBXWatch,
	#superclass : #SBBlock,
	#instVars : [
		'identifier',
		'expression',
		'display'
	],
	#classVars : [
		'Registry'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBXWatch class >> newFor: aBlock [

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBXWatch class >> registerWatch: aWatch [

	self registry at: aWatch identifier put: aWatch
]

{ #category : #'as yet unclassified' }
SBXWatch class >> registry [

	^ Registry ifNil: [Registry := WeakValueDictionary new]
]

{ #category : #'as yet unclassified' }
SBXWatch class >> report: aValue for: aSymbol [

	| reg watcher |
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue].
	
	^ aValue
]

{ #category : #actions }
SBXWatch >> chooseViewMode [
	<action>

	display promptChangeDisplay
]

{ #category : #'event handling' }
SBXWatch >> click: anEvent [

	super click: anEvent
]

{ #category : #'colors and color policies' }
SBXWatch >> color [

	^ self parentSandblock color
]

{ #category : #'event handling' }
SBXWatch >> doubleClick: anEvent [

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) replacer: self expression; target: self)
]

{ #category : #'colors and color policies' }
SBXWatch >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #actions }
SBXWatch >> exploreLastValue [
	<action>

	display exploreLastValue
]

{ #category : #accessing }
SBXWatch >> expression [

	^ self firstSubmorph
]

{ #category : #accessing }
SBXWatch >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock
]

{ #category : #accessing }
SBXWatch >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #accessing }
SBXWatch >> identifier [

	^ identifier
]

{ #category : #accessing }
SBXWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #initialization }
SBXWatch >> initialize [

	super initialize.
	
	self
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		addMorphBack: (display := SBWatchView new)
]

{ #category : #initialization }
SBXWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #layout }
SBXWatch >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self submorphs first layoutCommands.
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: self submorphs second}
]

{ #category : #'event handling' }
SBXWatch >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBXWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #printing }
SBXWatch >> printOn: aStream [

	aStream nextPutAll: 'watch '.
	self expression printOn: aStream
]

{ #category : #'as yet unclassified' }
SBXWatch >> reportValue: anObject [

	display reportValue: anObject
]

{ #category : #actions }
SBXWatch >> storeAsExample [
	<action>

	display storeAsExample
]

{ #category : #copying }
SBXWatch >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new oldDisplay |
	oldDisplay := display.
	display := SBWatchView new.
	oldDisplay replaceBy: display.
	
	new := super veryDeepCopyWith: deepCopier.
	new newIdentifier.
	
	display replaceBy: oldDisplay.
	display := oldDisplay.
	
	^ new
]
