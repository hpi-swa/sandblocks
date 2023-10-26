"
Observes (watches) an expression locally for added SBExamples. Whenever an example has finished running, it updates its belonging view. Further, with a given modifyExpression, it transforms the watched expression values. Also known as a Probe in the context of Babylonian Smalltalk.
"
Class {
	#name : #SBExampleWatch,
	#superclass : #SBStSubstitution,
	#instVars : [
		'identifier',
		'watchedExpression',
		'dimensionOptions',
		'modifyExpression',
		'exampleToDisplay',
		'exampleToValues'
	],
	#classVars : [
		'Registry'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #testing }
SBExampleWatch class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock receiver satisfies: #(notNil isBinding)) and: [aBlock receiver contents = self name] and: [aBlock selector = self matchingSelectors first]
]

{ #category : #constants }
SBExampleWatch class >> matchingSelectors [

	^ #(#report:for:modifying:)
]

{ #category : #'instance creation' }
SBExampleWatch class >> newFor: aMessageSend [

	"Saving the temp is necessary here, as directly accessing will cause
	the message send to lose an arguments with each assignment"
	"Also done in SBMemoize"
	| args |
	args := aMessageSend arguments.
	^ self new
		identifier: args second contents asNumber;
		modifyExpression: args third;
		expression: args first 
]

{ #category : #shortcuts }
SBExampleWatch class >> registerShortcuts: aProvider [

	aProvider registerShortcut: Character backspace do: #replaceWithWatchedExpression.
	aProvider cmdShortcut: Character delete do: #replaceWithWatchedExpression.

]

{ #category : #'event handling' }
SBExampleWatch class >> registerWatch: aWatch [

	self registry add: aWatch
]

{ #category : #accessing }
SBExampleWatch class >> registry [

	(Registry isKindOf: WeakSet) ifFalse: [Registry := nil].
	^ Registry ifNil: [Registry := WeakSet new]
]

{ #category : #'event handling' }
SBExampleWatch class >> report: aValue for: aSymbol [

	"Compatibility to SBWatch"
	^ self reportValue: aValue for: aSymbol modifying: (SBStBlockBody identityNamed: 'each').
]

{ #category : #'event handling' }
SBExampleWatch class >> report: aValue for: aSymbol modifying: aBlock [

	| reg watchers example |
	example := SBExecutionEnvironment value ifNil: [^ aValue].
	
	reg := self registry.
	watchers := reg select: [:watcher | watcher notNil 
		and: [watcher identifier = aSymbol]
		and: [watcher isActive]].
	watchers do: [:watcher | watcher reportValue: aValue for: example].
	
	^ aValue
]

{ #category : #'event handling' }
SBExampleWatch class >> unregisterWatch: aWatch [

	self registry remove: aWatch ifAbsent: []
]

{ #category : #accessing }
SBExampleWatch class >> watchViewClass [

	^ SBExampleWatchView
]

{ #category : #'event handling' }
SBExampleWatch >> applyChosenDimensionOnValues [
	
	"Clearing everything here as Morphs get distorted when resized multiple times."
	self applyModifyExpressionOnValues.
	self flag: #todo. "If the sizing should be saved for watches in the future, 
	remove the markSaved here. That way, users will first browse and then decide if they want a size permanently"
	self sandblockEditor markSaved: self containingArtefact 
	
]

{ #category : #'event handling' }
SBExampleWatch >> applyModifyExpressionOnValues [

	exampleToDisplay associationsDo: [:anExampleDisplayPair | 
		anExampleDisplayPair value clear.
		 anExampleDisplayPair value
			reportValues: (self modifiedValuesFor: anExampleDisplayPair key)
			name: (anExampleDisplayPair key ifNotNil: #label ifNil: [''])
			sized: self selectedMorphResizer.
		anExampleDisplayPair value updateDisplay]
]

{ #category : #copying }
SBExampleWatch >> asInactiveCopy [

	^ SBInactiveExampleWatch newFromWatch: self
]

{ #category : #'colors and color policies' }
SBExampleWatch >> color [

	^ self parentSandblock color
]

{ #category : #'insert/delete' }
SBExampleWatch >> deleteCommandFor: aBlock [

	^ nil
]

{ #category : #'event handling' }
SBExampleWatch >> doubleClick: anEvent [

	self replaceWithWatchedExpression 
]

{ #category : #'colors and color policies' }
SBExampleWatch >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'event handling' }
SBExampleWatch >> exampleFinished: anExample [

	exampleToDisplay
		at: anExample
		ifPresent: [:aDisplay | | modifiedValues |
			modifiedValues := self modifiedValuesFor: anExample.
			modifiedValues ifNotEmpty: [
			aDisplay 
				reportValues: modifiedValues
				name: (anExample ifNotNil: #label ifNil: [''])
				sized: self selectedMorphResizer].
			aDisplay exampleFinished: anExample]
]

{ #category : #'event handling' }
SBExampleWatch >> exampleStarting: anExample [

	exampleToValues at: anExample put: OrderedCollection new.

	(exampleToDisplay at: anExample ifAbsentPut: [ | display |
		display := SBExampleValueDisplay new.
		self addMorph: (exampleToDisplay at: anExample put: display) atIndex: 2.
		anExample when: #outOfWorld send: #exampleStopped: to: self with: anExample.
		display])
		exampleStarting: anExample;
		name: anExample label
]

{ #category : #'event handling' }
SBExampleWatch >> exampleStopped: anExample [

	exampleToDisplay at: anExample ifPresent: [:aDisplay |
		self removeMorph: aDisplay.
		exampleToDisplay removeKey: anExample]
]

{ #category : #accessing }
SBExampleWatch >> exampleToDisplay: anExampleToDisplayDict [

	exampleToDisplay := anExampleToDisplayDict
]

{ #category : #accessing }
SBExampleWatch >> exampleToValues: anExampleToCollectionOfObjectsDict [

	exampleToValues := anExampleToCollectionOfObjectsDict
]

{ #category : #accessing }
SBExampleWatch >> expression [

	^ self firstSubmorph 
]

{ #category : #accessing }
SBExampleWatch >> expression: aBlock [

	watchedExpression ifNotNil: #delete.
	watchedExpression := aBlock.
	self addMorphFront: watchedExpression.
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

	| options |
	super initialize.
	options := SBMorphResizer standardOptions.
	
	exampleToDisplay := Dictionary new.
	exampleToValues := Dictionary new.
	watchedExpression := SBStMessageSend new.
	dimensionOptions := SBComboBox new
			prefix: 'Dimensions: ';
			labels: (options collect: #label);
			values: options;
			object: options first;
			when: #selectionChanged send: #applyChosenDimensionOnValues to: self.
	modifyExpression := SBStBlockBody identityNamed: 'each'.
	
	self
		changeTableLayout;
		cellGap: 4;
		layoutInset: 2;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addAllMorphsBack: {
			watchedExpression. 
			 SBRow new
				hResizing: #spaceFill;
				listCentering: #bottomRight;
				addMorphBack: dimensionOptions;
				yourself. 
			modifyExpression};
		yourself 
]

{ #category : #initialization }
SBExampleWatch >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self class registerWatch: self
]

{ #category : #accessing }
SBExampleWatch >> isActive [

	^ true
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

{ #category : #copying }
SBExampleWatch >> keepKeysDeepCopyValuesOf: aDictionary [

	^ Dictionary newFrom: (
		aDictionary associations collect: [:aKeyValuePair | aKeyValuePair key -> aKeyValuePair value sbSnapshot ])
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
SBExampleWatch >> modifiedValuesFor: anExample [

	^ exampleToValues at: anExample 
		ifPresent: [:aCollection | aCollection 
			collect: [:anObject | self modifyExpression evaluateWithArguments: {anObject}]]
		ifAbsent: [{}]
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
SBExampleWatch >> replaceWithWatchedExpression [
	<action>
	
	self sandblockEditor do: (SBReplaceCommand new
		replacer: self expression;
		target: self)
]

{ #category : #actions }
SBExampleWatch >> reportValue: anObject for: anExample [ 

	exampleToValues
		at: anExample
		ifPresent: [:values | values add: anObject]
]

{ #category : #accessing }
SBExampleWatch >> selectedMorphResizer [

	^ dimensionOptions object
]

{ #category : #accessing }
SBExampleWatch >> setWatchedExpressionUneditable [

	watchedExpression selectable: false
]

{ #category : #accessing }
SBExampleWatch >> valuesForExample: anExample [

	^ exampleToValues at: anExample ifAbsent: [nil]
]

{ #category : #copying }
SBExampleWatch >> veryDeepCopyWith: deepCopier [

	" assure that copies of us have a unique id "
	" disregarding deep copy of dictionaries to avoid duplicating examples"
	| new oldExampleDisplays oldExampleValues |
	oldExampleDisplays := exampleToDisplay.
	oldExampleValues := exampleToValues.
	exampleToDisplay := Dictionary new.
	exampleToValues := Dictionary new.
	
	new := super veryDeepCopyWith: deepCopier.
	exampleToDisplay := oldExampleDisplays.
	exampleToValues := oldExampleValues.
	
	new newIdentifier.
	new exampleToDisplay: (Dictionary newFrom: 
		(exampleToDisplay keys withIndexCollect: [:anExample :i | anExample -> (new submorphs at: (i + 1))])).
	new exampleToValues: (Dictionary newFrom: (
		oldExampleValues associations collect: [:aKeyValuePair | aKeyValuePair key -> aKeyValuePair value sbSnapshot ])).
	
	^ new
]

{ #category : #printing }
SBExampleWatch >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBExampleWatch report: ('.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ') for: '.
	self identifier storeOn: aStream.
	aStream nextPutAll: ' modifying: '.
	self modifyExpression writeSourceOn: aStream.
	aStream nextPut: $)
]
