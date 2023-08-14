Class {
	#name : #SBWatchView,
	#superclass : #SBBlock,
	#instVars : [
		'watchValues',
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

{ #category : #accessing }
SBWatchView >> addValue: anObject [

	(watchValues size >= numSavedValues and: [numSavedValues > 0]) ifTrue: [watchValues removeFirst].
	^ watchValues addLast: (SBWatchValue value: anObject sbSnapshot identityHash: anObject identityHash)
]

{ #category : #display }
SBWatchView >> changeDisplay [
	<action>

	| index options |
	options := Array streamContents: [:stream | self values allConversionsFor: SBInterfaces topLevel do: [:pair | stream nextPut: pair]].
	index := UIManager default chooseFrom: (options collect: #first).
	index = 0 ifTrue: [^ self].
	
	self useDisplay: (options at: index) second
]

{ #category : #'event handling' }
SBWatchView >> clear [
	<action>

	count contents: '0'.
	watchValues := LinkedList new.
	
	self display replaceBy: (self placeholder: 0 @ 0).
	clear
		disableLayout: true;
		visible: false
]

{ #category : #accessing }
SBWatchView >> count [

	^ count contents
]

{ #category : #display }
SBWatchView >> defaultDisplay [ 

	^ SBBlock new 
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #accessing }
SBWatchView >> display [

	(self submorphCount >= 3)
		ifFalse: [self addMorph: (self defaultDisplay) atIndex: 2].
	^self submorphs second
]

{ #category : #display }
SBWatchView >> displayWatchValues [
	
	self display delete.
	
	watchValues do: [:v | self display addMorphBack: (self valueMorphFor: v)]
]

{ #category : #'colors and color policies' }
SBWatchView >> drawnColor [

	^ Color white
]

{ #category : #accessing }
SBWatchView >> incrementCount [

	count contents: (count contents + 1) asString
]

{ #category : #initialization }
SBWatchView >> initialize [

	super initialize.
	
	dark := true.
	updateScheduled := false.
	numSavedValues := 1.
	watchValues := LinkedList new.
	
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

{ #category : #accessing }
SBWatchView >> lastValue [

	^ watchValues last watchedValue
]

{ #category : #layout }
SBWatchView >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]

{ #category : #'event handling' }
SBWatchView >> noValue [

	self display ifNotNil: [self display replaceBy: (self placeholder: self display fullBounds extent)]
]

{ #category : #accessing }
SBWatchView >> numSavedValues: anInteger [
	"Private"

	numSavedValues := anInteger
]

{ #category : #'object interface' }
SBWatchView >> object [

	^ self values
]

{ #category : #'event handling' }
SBWatchView >> placeholder: aPoint [

	^ Morph new color: Color transparent; extent: aPoint
]

{ #category : #printing }
SBWatchView >> printOn: aStream [

	aStream nextPutAll: 'watch on '.
	self object printOn: aStream
]

{ #category : #accessing }
SBWatchView >> reportValue: anObject [

	self addValue: anObject.
	self incrementCount.
	
	updateScheduled ifFalse: [
		updateScheduled := true.
		Project current addDeferredUIMessage: [self updateDisplay]]
]

{ #category : #'object interface' }
SBWatchView >> storeAsExample [

	| name class values |
	name := (UIManager default request: 'Name for example method?') ifNil: [^ self].
	class := self containingSandblock containingArtefact methodClass.
	values := self values veryDeepCopy.
	class compile: name, String cr, '^', values storeString.
	self sandblockEditor open: class >> name asSymbol
]

{ #category : #display }
SBWatchView >> updateDisplay [

	updateScheduled ifFalse: [^ self].
	
	updateScheduled := false.
	
	watchValues size > 0 ifTrue: [
		clear
			disableLayout: false;
			visible: true].
		
	self displayWatchValues
]

{ #category : #display }
SBWatchView >> useDisplay: aDisplay [

	self display delete.
	self addMorph: aDisplay atIndex: 2. 
]

{ #category : #display }
SBWatchView >> valueMorphFor: traceValue [
	
	| morph |
	morph := traceValue asValueMorph.
	morph on: #doubleClick send: #value to: [traceValue watchedValue explore].
	^ morph 
]

{ #category : #accessing }
SBWatchView >> values [

	^ numSavedValues = 1 ifTrue: [watchValues last watchedValue] ifFalse: [^ watchValues collect: [:value | value watchedValue]]
]

{ #category : #copying }
SBWatchView >> veryDeepCopyWith: deepCopier [

	| new oldValues |
	oldValues := watchValues.
	watchValues := nil.
	
	new := super veryDeepCopyWith: deepCopier.
	watchValues := oldValues.
	new watchValues: watchValues.
	
	^ new
]

{ #category : #accessing }
SBWatchView >> watchObjectInterface [

	^ SBInterfaces topLevel, {[:o | o isEditor not]}
]

{ #category : #accessing }
SBWatchView >> watchValues: aLinkedList [
	"Private"
	
	watchValues := aLinkedList
]
