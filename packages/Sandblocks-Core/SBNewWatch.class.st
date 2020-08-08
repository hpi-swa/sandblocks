Class {
	#name : #SBNewWatch,
	#superclass : #SBSubstitution,
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
SBNewWatch class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBNewWatch'] and: [aBlock selector = 'report:for:']
]

{ #category : #'as yet unclassified' }
SBNewWatch class >> newFor: aBlock [

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBNewWatch class >> registerWatch: aWatch [

	self registry at: aWatch identifier put: aWatch
]

{ #category : #'as yet unclassified' }
SBNewWatch class >> registry [

	^ Registry ifNil: [Registry := WeakValueDictionary new]
]

{ #category : #'as yet unclassified' }
SBNewWatch class >> report: aValue for: aSymbol [

	| reg watcher |
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue].
	
	^ aValue
]

{ #category : #'as yet unclassified' }
SBNewWatch >> childSandblocksDo: aBlock [

	self submorphCount = 2 ifTrue: [aBlock value: self expression]
]

{ #category : #'as yet unclassified' }
SBNewWatch >> chooseViewMode [
	<action>

	display promptChangeDisplay
]

{ #category : #'as yet unclassified' }
SBNewWatch >> click: anEvent [

	super click: anEvent
]

{ #category : #'as yet unclassified' }
SBNewWatch >> color [

	^ self parentSandblock color
]

{ #category : #'as yet unclassified' }
SBNewWatch >> doubleClick: anEvent [

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact) replacer: self expression; target: self)
]

{ #category : #'as yet unclassified' }
SBNewWatch >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBNewWatch >> exampleStarting: anExample [

	" ensure that we're the active watch "
	self class registerWatch: self.
	
	display exampleStarting: anExample
]

{ #category : #'as yet unclassified' }
SBNewWatch >> exploreLastValue [
	<action>

	display exploreLastValue
]

{ #category : #'as yet unclassified' }
SBNewWatch >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBNewWatch >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock
]

{ #category : #'as yet unclassified' }
SBNewWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'as yet unclassified' }
SBNewWatch >> identifier [

	^ identifier
]

{ #category : #'as yet unclassified' }
SBNewWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #'as yet unclassified' }
SBNewWatch >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := SBNewWatchView new)
]

{ #category : #'as yet unclassified' }
SBNewWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #'as yet unclassified' }
SBNewWatch >> isGlobalWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBNewWatch >> isWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBNewWatch >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBNewWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #'as yet unclassified' }
SBNewWatch >> printOn: aStream [

	aStream nextPutAll: 'watch '.
	self expression printOn: aStream
]

{ #category : #'as yet unclassified' }
SBNewWatch >> reportValue: anObject [

	display reportValue: anObject
]

{ #category : #'as yet unclassified' }
SBNewWatch >> storeAsExample [
	<action>

	display storeAsExample
]

{ #category : #'as yet unclassified' }
SBNewWatch >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	new newIdentifier.
	^ new
]

{ #category : #'as yet unclassified' }
SBNewWatch >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBNewWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
