Class {
	#name : #SBNewWatchView,
	#superclass : #Morph,
	#instVars : [
		'display',
		'lastValue',
		'dark',
		'hadValue',
		'count',
		'currentRepresentation'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBNewWatchView class >> watchTypes [

	^ {
		SBDisplayBarChart.
		"Smalltalk at: #SBDisplayActiveExpressionMarbles ifAbsent: [nil]."
		Smalltalk at: #SBDisplayActiveExpression ifAbsent: [nil].
		SBDisplayColor.
		SBDisplayPoint.
		SBDisplayMorph.
		SBDisplayCanvas.
		SBDisplayForm.
		SBDisplayPrint.
		SBDisplayText.
		SBDisplayMultiple.
	} select: #notNil
]

{ #category : #'event handling' }
SBNewWatchView >> clear [

	count contents: '0'
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> dark: aBoolean [

	self submorphs from: 1 to: 2 do: [:morph | morph color: (aBoolean ifTrue: [Color lightGray] ifFalse: [Color black])].
	
	dark := aBoolean.
	display dark: aBoolean
]

{ #category : #'event handling' }
SBNewWatchView >> exampleFinished: anExample [ 

	display exampleFinished: anExample
]

{ #category : #'event handling' }
SBNewWatchView >> exampleStarting: anExample [

	self clear.
	"display exampleStarting: anExample"
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> exploreLastValue [

	self sandblockEditor openMorphInView: (SBExplorer on: lastValue)
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> initialize [

	super initialize.
	
	dark := true.
	hadValue := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 8;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBIcon iconSearch
			large;
			on: #click send: #exploreLastValue to: self;
			balloonText: 'Explore last value';
			yourself);
		addMorphBack: (SBIcon iconBar_chart
			large;
			on: #click send: #promptChangeDisplay to: self;
			balloonText: 'Change display type';
			yourself);
		addMorphBack: (count := SBBadge new
			contents: '0';
			balloonText: 'Number of reported values';
			yourself)
]

{ #category : #'event handling' }
SBNewWatchView >> noValue [

	display ifNotNil: #delete
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> promptChangeDisplay [

	| index options |
	options := lastValue representationsThat: self representationTypes.
	index := UIManager default chooseFrom: options.
	index = 0 ifTrue: [^ self].
	
	currentRepresentation := options at: index.
	
	self useDisplay: (currentRepresentation newFor: lastValue)
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> reportValue: anObject [

	hadValue ifFalse: [hadValue := true].
	
	(currentRepresentation notNil and: [currentRepresentation matches: anObject])
		ifTrue: [display replace: anObject]
		ifFalse: [self useDisplay: (anObject anyRepresentationThat: self representationTypes)].

	count contents: (count contents asInteger + 1) asString.
	lastValue := anObject
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> representationTypes [

	^ #(isToplevelMorph)
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> storeAsExample [

	| name class value |
	name := (UIManager default request: 'Name for example method?') ifNil: [^ self].
	class := self containingSandblock containingArtefact methodClass.
	value := lastValue veryDeepCopy.
	class compile: name, String cr, '^', value storeString.
	self sandblockEditor open: class >> name asSymbol
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> useDisplay: aDisplay [

	display ifNotNil: #delete.
	display := aDisplay.
	self addMorphBack: display
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> validDisplaysFor: anObject [

	^ self class watchTypes select: [:display | anObject isNil or: [display matches: anObject]]
]

{ #category : #'as yet unclassified' }
SBNewWatchView >> veryDeepCopyWith: deepCopier [

	| new oldLastValue |
	oldLastValue := lastValue.
	lastValue := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	lastValue := oldLastValue.
	
	^ new
]
