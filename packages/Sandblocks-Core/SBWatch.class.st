Class {
	#name : #SBWatch,
	#superclass : #SBSubstitution,
	#instVars : [
		'identifier',
		'expression',
		'display'
	],
	#classVars : [
		'Registry'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWatch class >> matches: aBlock [

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBWatch'] and: [aBlock selector = 'report:for:']
]

{ #category : #'as yet unclassified' }
SBWatch class >> newFrom: aBlock [

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBWatch class >> registerWatch: aWatch [

	self registry at: aWatch identifier put: aWatch
]

{ #category : #'as yet unclassified' }
SBWatch class >> registry [

	^ Registry ifNil: [Registry := WeakValueDictionary new]
]

{ #category : #'as yet unclassified' }
SBWatch class >> report: aValue for: aSymbol [

	| reg watcher |
	reg := self registry.
	watcher := reg at: aSymbol ifAbsent: [^ aValue].
	watcher ifNil: [reg removeKey: aSymbol] ifNotNil: [watcher reportValue: aValue].
	
	^ aValue
]

{ #category : #'as yet unclassified' }
SBWatch >> childSandblocksDo: aBlock [

	self submorphCount = 2 ifTrue: [aBlock value: self expression]
]

{ #category : #'as yet unclassified' }
SBWatch >> chooseViewMode [

	display promptChangeDisplay
]

{ #category : #'as yet unclassified' }
SBWatch >> click: anEvent [

	super click: anEvent
]

{ #category : #'as yet unclassified' }
SBWatch >> codeActions [

	^ {
		SBCodeAction labeled: 'Change View Mode' for: self do: #chooseViewMode.
		SBCodeAction labeled: 'Explore Value' for: self do: #exploreLastValue.
		SBCodeAction labeled: 'Store as Example' for: self do: #storeAsExample.
	}, super codeActions
]

{ #category : #'as yet unclassified' }
SBWatch >> color [

	^ self parentSandblock color
]

{ #category : #'as yet unclassified' }
SBWatch >> doubleClick: anEvent [

	self sandblockEditor do: ((SBReplaceCommand newFor: self method) replacer: self expression; target: self)
]

{ #category : #'as yet unclassified' }
SBWatch >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBWatch >> exampleStarting: anExample [

	" ensure that we're the active watch "
	self class registerWatch: self.
	
	display exampleStarting: anExample
]

{ #category : #'as yet unclassified' }
SBWatch >> exploreLastValue [

	display exploreLastValue
]

{ #category : #'as yet unclassified' }
SBWatch >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBWatch >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock
]

{ #category : #'as yet unclassified' }
SBWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'as yet unclassified' }
SBWatch >> identifier [

	^ identifier
]

{ #category : #'as yet unclassified' }
SBWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #'as yet unclassified' }
SBWatch >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := SBWatchView new dark: true)
]

{ #category : #'as yet unclassified' }
SBWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #'as yet unclassified' }
SBWatch >> isGlobalWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBWatch >> isWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBWatch >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #'as yet unclassified' }
SBWatch >> printOn: aStream [

	aStream nextPutAll: 'watch '.
	self expression printOn: aStream
]

{ #category : #'as yet unclassified' }
SBWatch >> reportValue: anObject [

	display reportValue: anObject
]

{ #category : #'as yet unclassified' }
SBWatch >> storeAsExample [

	display storeAsExample
]

{ #category : #'as yet unclassified' }
SBWatch >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	new newIdentifier.
	^ new
]

{ #category : #'as yet unclassified' }
SBWatch >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
