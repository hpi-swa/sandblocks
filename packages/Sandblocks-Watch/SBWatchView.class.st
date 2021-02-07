Class {
	#name : #SBWatchView,
	#superclass : #SBBlock,
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
SBWatchView >> changeDisplay [
	<action>

	| index options |
	options := Array streamContents: [:stream | lastValue allConversionsFor: SBInterfaces topLevel do: [:pair | stream nextPut: pair]].
	index := UIManager default chooseFrom: (options collect: #first).
	index = 0 ifTrue: [^ self].
	
	self useDisplay: (options at: index) second
]

{ #category : #'event handling' }
SBWatchView >> clear [

	count contents: '0'
]

{ #category : #'as yet unclassified' }
SBWatchView >> drawnColor [

	^ Color transparent
]

{ #category : #'event handling' }
SBWatchView >> exampleFinished: anExample [ 

	display exampleFinished: anExample
]

{ #category : #'event handling' }
SBWatchView >> exampleStarting: anExample [

	self clear.
	"display exampleStarting: anExample"
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
		hResizing: #shrinkWrap;
		addMorphBack: (count := SBBadge new
			contents: '0';
			balloonText: 'Number of reported values';
			yourself)
]

{ #category : #'as yet unclassified' }
SBWatchView >> lastValue: anObject [

	lastValue := anObject
]

{ #category : #'event handling' }
SBWatchView >> noValue [

	display ifNotNil: [display replaceBy: (display := Morph new color: Color transparent; extent: display fullBounds extent)]
]

{ #category : #'as yet unclassified' }
SBWatchView >> object [

	^ lastValue
]

{ #category : #'as yet unclassified' }
SBWatchView >> printOn: aStream [

	aStream nextPutAll: 'watch on '.
	self object printOn: aStream
]

{ #category : #'as yet unclassified' }
SBWatchView >> reportValue: anObject [

	hadValue ifFalse: [hadValue := true].
	
	SBToggledCode
		comment: 'we want to check if we can/should reuse the previous conversion procedure'
		active: 1
		do: {[self useDisplay: (anObject convertedFor: SBInterfaces topLevel do: #yourself)]}.
	
	count contents: (count contents asInteger + 1) asString.
	lastValue := anObject
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
SBWatchView >> useDisplay: aDisplay [

	display ifNotNil: #delete.
	display := aDisplay.
	self addMorphBack: display
]

{ #category : #'as yet unclassified' }
SBWatchView >> veryDeepCopyWith: deepCopier [

	| new oldLastValue |
	oldLastValue := lastValue.
	lastValue := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	lastValue := oldLastValue.
	new lastValue: lastValue.
	
	^ new
]
