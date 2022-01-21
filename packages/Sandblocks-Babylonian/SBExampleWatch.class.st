Class {
	#name : #SBExampleWatch,
	#superclass : #SBStSubstitution,
	#instVars : [
		'identifier',
		'expression',
		'display',
		'exampleValues'
	],
	#classVars : [
		'Registry'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBExampleWatch class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = 'report:for:']
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> newFor: aBlock [

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> registerWatch: aWatch [

	(self registry at: aWatch identifier ifAbsentPut: [OrderedCollection new]) add: aWatch
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> registry [

	SBToggledCode
		comment: 'temporary migration fix'
		active: 1
		do: {[(Registry isKindOf: WeakValueDictionary) ifTrue: [Registry := nil]]}.
	
	^ Registry ifNil: [Registry := Dictionary new]
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> report: aValue for: aSymbol [

	| reg watchers example |
	example := SBExecutionEnvironment value ifNil: [^ aValue].
	
	reg := self registry.
	watchers := reg at: aSymbol ifAbsent: [^ aValue].
	watchers do: [:watcher | watcher reportValue: aValue for: example].
	
	^ aValue
]

{ #category : #'as yet unclassified' }
SBExampleWatch class >> unregisterWatch: aWatch [

	self registry at: aWatch identifier ifPresent: [:list |
		list remove: aWatch ifAbsent: [].
		list ifEmpty: [self registry removeKey: aWatch identifier]]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> color [

	^ self parentSandblock color
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> doubleClick: anEvent [

	self sandblockEditor do: (SBReplaceCommand new
		replacer: self expression;
		target: self)
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> exampleFinished: anExample [

	exampleValues at: anExample ifPresent: [:val | val exampleFinished: anExample]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> exampleStarting: anExample [

	(exampleValues at: anExample ifAbsentPut: [ | display |
		display := SBExampleValueDisplay new.
		self addMorphBack: (exampleValues at: anExample put: display).
		anExample when: #outOfWorld send: #exampleStopped: to: self with: anExample.
		display])
		exampleStarting: anExample;
		name: anExample label
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> exampleStopped: anExample [

	exampleValues at: anExample ifPresent: [:val |
		self removeMorph: val.
		exampleValues removeKey: anExample]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> expression: aBlock [

	self submorphCount > 1 ifTrue: [self firstSubmorph delete].
	self addMorphFront: aBlock
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> filterForContextId: aNumber example: anExample [

	exampleValues at: anExample ifPresent: [:display | display filterForContextId: aNumber]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> identifier [

	^ identifier
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> identifier: aSymbol [

	identifier := aSymbol.
	self world ifNotNil: [self class registerWatch: self]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> initialize [

	super initialize.
	
	exampleValues := Dictionary new.
	
	self
		cellGap: 4;
		layoutInset: 2;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> isExampleWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> isGlobalWatch [

	^ false
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> isWatch [

	^ true
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> listensToExamples [

	^ true
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	
	self class unregisterWatch: self
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> printOn: aStream [

	aStream nextPutAll: 'example watch '.
	self hasSubmorphs ifTrue: [self expression printOn: aStream]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> reportValue: anObject for: anExample [

	exampleValues
		at: anExample
		ifPresent: [:display | display reportValue: anObject name: (anExample ifNotNil: #label ifNil: [''])]
]

{ #category : #'as yet unclassified' }
SBExampleWatch >> valuesForExample: anExample [

	^ exampleValues at: anExample ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBExampleWatch >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBExampleWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
