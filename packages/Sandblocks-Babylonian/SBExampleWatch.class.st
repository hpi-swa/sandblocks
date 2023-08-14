Class {
	#name : #SBExampleWatch,
	#superclass : #SBStSubstitution,
	#instVars : [
		'identifier',
		'display',
		'exampleValues',
		'watchedExpression',
		'modifyExpression'
	],
	#classVars : [
		'Registry'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleWatch class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = 'report:for:modifying:']
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> newFor: aBlock [

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> registerWatch: aWatch [

	self registry add: aWatch
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> registry [

	(Registry isKindOf: WeakSet) ifFalse: [Registry := nil].
	^ Registry ifNil: [Registry := WeakSet new]
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> report: aValue for: aSymbol [

	"Compatibility to SBWatch"
	^ self reportValue: aValue for: aSymbol  modifying: (SBStBlockBody identityNamed: 'result').
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> report: aValue for: aSymbol modifying: aBlock [

	| reg watchers example |
	example := SBExecutionEnvironment value ifNil: [^ aValue].
	
	reg := self registry.
	watchers := reg select: [:watcher | watcher notNil and: [watcher identifier = aSymbol]].
	watchers do: [:watcher | watcher reportValue: aValue for: example modifying: aBlock].
	
	^ aValue
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> unregisterWatch: aWatch [

	self registry remove: aWatch ifAbsent: []
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> watchViewClass [

	^ SBExampleWatchView
]

{ #category : #'colors and color policies' }
SBExampleWatch >> color [

	^ self parentSandblock color
]

{ #category : #'event handling' }
SBExampleWatch >> doubleClick: anEvent [

	self sandblockEditor do: (SBReplaceCommand new
		replacer: self expression;
		target: self)
]

{ #category : #'colors and color policies' }
SBExampleWatch >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'event handling' }
SBExampleWatch >> exampleFinished: anExample [

	exampleValues at: anExample ifPresent: [:val | val exampleFinished: anExample]
]

{ #category : #'event handling' }
SBExampleWatch >> exampleStarting: anExample [

	(exampleValues at: anExample ifAbsentPut: [ | display |
		display := SBExampleValueDisplay new.
		self addMorph: (exampleValues at: anExample put: display) atIndex: 2.
		anExample when: #outOfWorld send: #exampleStopped: to: self with: anExample.
		display])
		exampleStarting: anExample;
		name: anExample label
]

{ #category : #'event handling' }
SBExampleWatch >> exampleStopped: anExample [

	exampleValues at: anExample ifPresent: [:val |
		self removeMorph: val.
		exampleValues removeKey: anExample]
]

{ #category : #accessing }
SBExampleWatch >> expression [

	^ watchedExpression
]

{ #category : #accessing }
SBExampleWatch >> expression: aBlock [

	watchedExpression ifNotNil: #delete.
	watchedExpression := aBlock.
	self addMorphFront: watchedExpression.
]

{ #category : #actions }
SBExampleWatch >> filterForContextId: aNumber example: anExample [

	exampleValues at: anExample ifPresent: [:display | display filterForContextId: aNumber]
]

{ #category : #accessing }
SBExampleWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #accessing }
SBExampleWatch >> identifier [

	^ identifier
]

{ #category : #accessing }
SBExampleWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #initialization }
SBExampleWatch >> initialize [

	super initialize.
	
	exampleValues := Dictionary new.
	watchedExpression := SBStMessageSend new.
	modifyExpression := SBStBlockBody identityNamed: 'result'.
	
	self
		cellGap: 4;
		layoutInset: 2;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addAllMorphsBack: {watchedExpression. modifyExpression};
		yourself 
]

{ #category : #initialization }
SBExampleWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> isExampleWatch [

	^ true
]

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> isGlobalWatch [

	^ false
]

{ #category : #testing }
SBExampleWatch >> isWatch [

	^ true
]

{ #category : #layout }
SBExampleWatch >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> listensToExamples [

	^ true
]

{ #category : #accessing }
SBExampleWatch >> modifyExpression [

	^ modifyExpression
]

{ #category : #accessing }
SBExampleWatch >> modifyExpression: aBlock [

	modifyExpression ifNotNil: #delete.
	modifyExpression := aBlock.
	self addMorphBack: modifyExpression.
]

{ #category : #accessing }
SBExampleWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #initialization }
SBExampleWatch >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self class unregisterWatch: self
]

{ #category : #printing }
SBExampleWatch >> printOn: aStream [

	aStream nextPutAll: 'example watch '.
	self expression printOn: aStream.
	aStream nextPutAll: ' modified by '.
	self modifyExpression printOn: aStream.
]

{ #category : #actions }
SBExampleWatch >> reportValue: anObject for: anExample modifying: aBlock [

	exampleValues
		at: anExample
		ifPresent: [:display | display reportValue: (self modifyExpression evaluateWithArguments: {anObject}) name: (anExample ifNotNil: #label ifNil: [''])]
]

{ #category : #accessing }
SBExampleWatch >> valuesForExample: anExample [

	^ exampleValues at: anExample ifAbsent: [nil]
]

{ #category : #copying }
SBExampleWatch >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	| new oldExamplesValues |
	oldExamplesValues := exampleValues.
	exampleValues := Dictionary new.
	
	new := super veryDeepCopyWith: deepCopier.
	exampleValues := oldExamplesValues.
	new newIdentifier.
	^ new
]

{ #category : #printing }
SBExampleWatch >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBExampleWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPutAll: ' modifying: '.
	self modifyExpression writeSourceOn: aStream.
	aStream nextPut: $)
]
