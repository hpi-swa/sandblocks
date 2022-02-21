Class {
	#name : #SBWatchView,
	#superclass : #SBBlock,
	#instVars : [
		'lastValue',
		'dark',
		'count',
		'currentRepresentation',
		'clear',
		'updateScheduled',
		'numReportedValues',
		'env'
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
	<action>

	count contents: '0'.
	self display replaceBy: (self placeholder: 0 @ 0).
	clear
		disableLayout: true;
		visible: false
]

{ #category : #'event handling' }
SBWatchView >> display [

	^ self submorphCount = 3
		ifTrue: [self submorphs second]
		ifFalse: [nil]
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
	updateScheduled := false.
	numReportedValues := 0.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 8;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (count := SBBadge new
			contents: '0';
			balloonText: 'Number of reported values';
			yourself);
		addMorphBack: (self placeholder: 0 @ 0);
		addMorphBack: (clear := SBIcon iconTrash
			on: #click send: #clear to: self;
			disableLayout: true;
			visible: false)
]

{ #category : #'as yet unclassified' }
SBWatchView >> lastValue: anObject [

	lastValue := anObject
]

{ #category : #'event handling' }
SBWatchView >> noValue [

	self display ifNotNil: [self display replaceBy: (self placeholder: self display fullBounds extent)]
]

{ #category : #'as yet unclassified' }
SBWatchView >> object [

	^ lastValue
]

{ #category : #'event handling' }
SBWatchView >> placeholder: aPoint [

	^ Morph new color: Color transparent; extent: aPoint
]

{ #category : #'as yet unclassified' }
SBWatchView >> printOn: aStream [

	aStream nextPutAll: 'watch on '.
	self object printOn: aStream
]

{ #category : #'as yet unclassified' }
SBWatchView >> reportValue: anObject [

	numReportedValues := numReportedValues + 1.
	lastValue := anObject.
	
	env := SBExecutionEnvironment value.
	updateScheduled ifFalse: [
		updateScheduled := true.
		Project current addDeferredUIMessage: [self updateDisplay]]
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
SBWatchView >> updateDisplay [

	updateScheduled ifFalse: [^ self].
	
	updateScheduled := false.
	
	numReportedValues = 0 ifTrue: [
		clear
			disableLayout: false;
			visible: true].
	
	count contents: numReportedValues asString.
	
	((lastValue class respondsTo: #visualPrimitiveMapping) and: [lastValue class visualPrimitiveMapping notEmpty])
		ifTrue: [ | morph vp |
			morph := SBBlock new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6.
			SBExecutionEnvironment value: env during: [
				vp := (Smalltalk at: #SBVisualPrimitive)
					newFromObject: lastValue
					in: morph].
			vp attachTreeDecorator.
			vp layout.
			self useDisplay: (SBRow new
				addMorphBack: morph;
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap)]
		ifFalse: [
			SBToggledCode comment: '' active: 1 do: {
				[self useDisplay: (SBExplorer on: lastValue)].
				[self useDisplay: (anObject convertedFor: self watchObjectInterface do: #yourself)]}]
]

{ #category : #'as yet unclassified' }
SBWatchView >> useDisplay: aDisplay [

	self display ifNotNil: #delete.
	self addMorph: aDisplay asElementNumber: 2
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

{ #category : #'as yet unclassified' }
SBWatchView >> watchObjectInterface [

	^ SBInterfaces topLevel, {[:o | o isEditor not]}
]
