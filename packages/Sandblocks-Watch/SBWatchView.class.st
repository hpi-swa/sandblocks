Class {
	#name : #SBWatchView,
	#superclass : #Morph,
	#instVars : [
		'display',
		'lastValue',
		'dark',
		'hadValue',
		'count'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBWatchView class >> watchTypes [

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
SBWatchView >> clear [

	count contents: '0'
]

{ #category : #'as yet unclassified' }
SBWatchView >> dark: aBoolean [

	self submorphs from: 1 to: 2 do: [:morph | morph color: (aBoolean ifTrue: [Color lightGray] ifFalse: [Color black])].
	
	dark := aBoolean.
	display dark: aBoolean
]

{ #category : #'event handling' }
SBWatchView >> exampleFinished: anExample [ 

	display exampleFinished: anExample
]

{ #category : #'event handling' }
SBWatchView >> exampleStarting: anExample [

	self clear.
	display exampleStarting: anExample
]

{ #category : #'as yet unclassified' }
SBWatchView >> exploreLastValue [

	self sandblockEditor openMorphInView: (SBExplorer on: lastValue)
]

{ #category : #'as yet unclassified' }
SBWatchView >> initialize [

	super initialize.
	
	dark := true.
	hadValue := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 8;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
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
			yourself);
		useDisplay: SBDisplayPrint
]

{ #category : #'as yet unclassified' }
SBWatchView >> promptChangeDisplay [

	| choices index |
	choices := self validDisplaysFor: lastValue.
	
	index := UIManager default chooseFrom: choices.
	index < 1 ifTrue: [^ self].
	
	self useDisplay: (choices at: index)
]

{ #category : #'as yet unclassified' }
SBWatchView >> reportValue: anObject [

	hadValue ifFalse: [
		hadValue := true.
		self useDisplay: (self validDisplaysFor: anObject) first].
	
	(display class matches: anObject) ifFalse: [self useDisplay: SBDisplayPrint].
	
	count contents: (count contents asInteger + 1) asString.
	lastValue := anObject.
	^ display reportValue: anObject
]

{ #category : #'as yet unclassified' }
SBWatchView >> storeAsExample [

	| name class value |
	name := (UIManager default request: 'Name for example method?') ifNil: [^ self].
	class := self containingSandblock containingArtefact methodClass.
	value := lastValue veryDeepCopy.
	class compile: name, String cr, '^', value storeString.
	self sandblockEditor open: class >> name asSymbol
]

{ #category : #'as yet unclassified' }
SBWatchView >> useDisplay: aDisplayClass [

	display ifNotNil: #delete.
	display := aDisplayClass new dark: dark.
	self addMorphBack: display.
	lastValue ifNotNil: [display reportValue: lastValue]
]

{ #category : #'as yet unclassified' }
SBWatchView >> validDisplaysFor: anObject [

	^ self class watchTypes select: [:display | anObject isNil or: [display matches: anObject]]
]

{ #category : #'as yet unclassified' }
SBWatchView >> veryDeepCopyWith: deepCopier [

	| new oldLastValue |
	oldLastValue := lastValue.
	lastValue := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	lastValue := oldLastValue.
	
	^ new
]
