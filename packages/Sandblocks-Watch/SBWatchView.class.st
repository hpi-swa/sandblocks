Class {
	#name : #SBWatchView,
	#superclass : #SBBlock,
	#instVars : [
		'values',
		'numSavedValues',
		'dark',
		'count',
		'clear',
		'updateScheduled',
		'env'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBWatchView class >> saving: anInteger [
	"Any value < 1 will result in saving all reported values"

	
	^ self new numSavedValues: anInteger
]

{ #category : #'as yet unclassified' }
SBWatchView >> addValue: anObject [

	(values size >= numSavedValues and: [numSavedValues > 0]) ifTrue: [values removeFirst].
	^ values addLast: anObject
]

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
	values := LinkedList new.
	
	self display replaceBy: (self placeholder: 0 @ 0).
	clear
		disableLayout: true;
		visible: false
]

{ #category : #'as yet unclassified' }
SBWatchView >> count [

	^ count contents
]

{ #category : #'event handling' }
SBWatchView >> display [

	^ self submorphCount = 3
		ifTrue: [self submorphs second]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBWatchView >> drawnColor [

	^ Color white
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

	self sandblockEditor openMorphInView: (SBExplorer on: values last)
]

{ #category : #'as yet unclassified' }
SBWatchView >> incrementCount [

	count contents: (count contents + 1) asString
]

{ #category : #'as yet unclassified' }
SBWatchView >> initialize [

	super initialize.
	
	dark := true.
	updateScheduled := false.
	numSavedValues := 1.
	values := LinkedList new.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		listDirection: #leftToRight;
		color: (Color r: 1 g: 1 b: 1);
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
SBWatchView >> lastValue [

	^ values last
]

{ #category : #'as yet unclassified' }
SBWatchView >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]

{ #category : #'event handling' }
SBWatchView >> noValue [

	self display ifNotNil: [self display replaceBy: (self placeholder: self display fullBounds extent)]
]

{ #category : #'as yet unclassified' }
SBWatchView >> numSavedValues: anInteger [
	"Private"

	
	numSavedValues := anInteger
]

{ #category : #'as yet unclassified' }
SBWatchView >> object [

	^ self values
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

	self addValue: anObject.
	self incrementCount.
	
	env := SBExecutionEnvironment value.
	updateScheduled ifFalse: [
		updateScheduled := true.
		Project current addDeferredUIMessage: [self updateDisplay]]
]

{ #category : #'as yet unclassified' }
SBWatchView >> storeAsExample [

	| name class values |
	name := (UIManager default request: 'Name for example method?') ifNil: [^ self].
	class := self containingSandblock containingArtefact methodClass.
	values := self values veryDeepCopy.
	class compile: name, String cr, '^', values storeString.
	self sandblockEditor open: class >> name asSymbol
]

{ #category : #'as yet unclassified' }
SBWatchView >> updateDisplay [

	updateScheduled ifFalse: [^ self].
	
	updateScheduled := false.
	
	values size = 0 ifTrue: [
		clear
			disableLayout: false;
			visible: true].
	
	((values last class respondsTo: #domainBlockMapping) and: [values last class domainBlockMapping notEmpty])
		ifTrue: [ | morph |
			SBExecutionEnvironment
				value: env
				during: [morph := (Smalltalk at: #SBDomainBlockContainer) visualize: ((Smalltalk at: #SBDomainBlock) newFromObject: self values)].
			self useDisplay: morph]
		ifFalse: [
			SBToggledCode comment: '' active: 1 do: {
				[self useDisplay: (self values convertedFor: self watchObjectInterface do: #yourself)].
				[self useDisplay: (SBExplorer on: self values)]}]
]

{ #category : #'as yet unclassified' }
SBWatchView >> useDisplay: aDisplay [

	self display ifNotNil: #delete.
	self addMorph: aDisplay asElementNumber: 2
]

{ #category : #'as yet unclassified' }
SBWatchView >> values [

	^ numSavedValues = 1 ifTrue: [values last] ifFalse: [^ values]
]

{ #category : #'as yet unclassified' }
SBWatchView >> values: aLinkedList [

	values := aLinkedList
]

{ #category : #'as yet unclassified' }
SBWatchView >> veryDeepCopyWith: deepCopier [

	| new oldValues |
	oldValues := values.
	values := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	values := oldValues.
	new values: values.
	
	^ new
]

{ #category : #'as yet unclassified' }
SBWatchView >> watchObjectInterface [

	^ SBInterfaces topLevel, {[:o | o isEditor not]}
]
