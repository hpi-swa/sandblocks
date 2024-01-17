"
A SBWatchView contains all the interesting information when watching an expression in scope of an example. It counts the expression evaluations, the expression results and offers reset options. 
"
Class {
	#name : #SBWatchView,
	#superclass : #SBBlock,
	#instVars : [
		'watchValues',
		'numSavedValues',
		'dark',
		'count',
		'clear',
		'fallbackResizer',
		'updateScheduled'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBWatchView class >> saving: anInteger [
	"Any value < 1 will result in saving all reported values"
	
	^ self new numSavedValues: anInteger
]

{ #category : #accessing }
SBWatchView >> addValue: anObject sized: aSBMorphResizer [

	(watchValues size >= numSavedValues and: [numSavedValues > 0]) ifTrue: [watchValues removeFirst].
	^ watchValues addLast: (SBWatchValue 
		value: anObject sbSnapshot 
		identityHash: anObject identityHash
		sized: aSBMorphResizer)
]

{ #category : #'insert/delete' }
SBWatchView >> canDelete [

	^ false
]

{ #category : #'insert/delete' }
SBWatchView >> canDeleteChild: aBlock [

	^ false
]

{ #category : #display }
SBWatchView >> changeDisplay [
	<action>

	| index options |
	options := Array streamContents: [:stream | 
		self values allConversionsFor: SBInterfaces topLevel do: [:pair | stream nextPut: pair]]. 
	options := options do: [:aPair | aPair at: 2 put: (self watchValuesContainer addMorphBack: (self fallbackResizer applyOn: aPair second))].
	options := options, {{'default'. self watchValuesContainer addAllMorphsBack: (watchValues collect: #asValueMorph)}}.
	index := UIManager default chooseFrom: (options collect: #first).
	index = 0 ifTrue: [^ self].
	
	self displayOnScrollPane: (options at: index) second.
]

{ #category : #actions }
SBWatchView >> clear [
	<action>

	count contents: '0'.
	watchValues := LinkedList new.
	
	self scroller removeAllMorphs.
	clear
		disableLayout: true;
		visible: false
]

{ #category : #accessing }
SBWatchView >> count [

	^ count contents
]

{ #category : #accessing }
SBWatchView >> count: aNumber [

	count contents: aNumber asString
]

{ #category : #display }
SBWatchView >> defaultDisplay [

	^ SBBlock new
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (ScrollPane new
			color: Color transparent;
			borderWidth: 0;
			vScrollBarPolicy: #never;
			showHScrollBarOnlyWhenNeeded;
			scrollBarThickness: self scrollBarHeight;
			width: 20;
			height: 20)
]

{ #category : #'insert/delete' }
SBWatchView >> deleteCommandFor: aBlock [

	^ nil
]

{ #category : #accessing }
SBWatchView >> display [

	^self submorphs second
]

{ #category : #display }
SBWatchView >> displayOnScrollPane: aMorph [

	self scroller removeAllMorphs.
	
	self scroller addMorph: aMorph.
	self scrollPane height: aMorph height + self scrollBarHeight.
	
	"Simulates an expanding layout"
	self scrollPane width: (aMorph width <= self maxWidth 
		ifTrue: [aMorph width] 
		ifFalse: [self maxWidth])
]

{ #category : #display }
SBWatchView >> displayWatchValues [

	| valuesMorph |
	valuesMorph := self watchValuesContainer.
	valuesMorph addAllMorphsBack: (watchValues collect: #asValueMorph).

	self displayOnScrollPane: valuesMorph.
]

{ #category : #accessing }
SBWatchView >> displayedMorphs [

	^ self scroller submorphs first "container for scrolling" submorphs 
]

{ #category : #'event handling' }
SBWatchView >> doubleClick: evt [

	super doubleClick: evt.
	self exploreValues
]

{ #category : #'colors and color policies' }
SBWatchView >> drawnColor [

	^ Color white
]

{ #category : #actions }
SBWatchView >> exploreValues [
	<action>

	self object explore
]

{ #category : #accessing }
SBWatchView >> fallbackResizer [

	^ fallbackResizer
]

{ #category : #accessing }
SBWatchView >> fallbackResizer: aSBMorphResizer [

	fallbackResizer := aSBMorphResizer
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
	fallbackResizer := SBMorphResizer newSmall.
	
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
		addMorphBack: self defaultDisplay;
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

{ #category : #layout }
SBWatchView >> maxWidth [

	^ 350
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
SBWatchView >> placeholder [

	^  Morph new 
		color: Color transparent; 
		extent: (0@0)
]

{ #category : #printing }
SBWatchView >> printOn: aStream [

	aStream nextPutAll: 'watch on '.
	self object printOn: aStream
]

{ #category : #actions }
SBWatchView >> reportValue: anObject [

	self reportValues: {anObject} sized: SBMorphResizer newIdentity
]

{ #category : #actions }
SBWatchView >> reportValues: aCollectionOfObjects sized: aMorphResizer [

	self fallbackResizer: aMorphResizer.
	aCollectionOfObjects do: [:anObject | self addValue: anObject sized: aMorphResizer].
	self count: self count contents + aCollectionOfObjects size.
	
	updateScheduled ifFalse: [
		updateScheduled := true.
		Project current addDeferredUIMessage: [self updateDisplay]]
]

{ #category : #actions }
SBWatchView >> resizeThrough: aMorphResizer [

	"Clearing everything here as Morphs get distorted when resized multiple times."
	| valuesMorph |
	valuesMorph := self watchValuesContainer.
	valuesMorph addAllMorphsBack: (self displayedMorphs 
		collect: #sbSnapshot 
		thenDo: [:aMorph | aMorphResizer applyOn: aMorph]).

	self displayOnScrollPane: valuesMorph.
	self fallbackResizer: aMorphResizer.
]

{ #category : #layout }
SBWatchView >> scrollBarHeight [

	^ 7 sbScaled 
]

{ #category : #accessing }
SBWatchView >> scrollPane [

	^ self display lastSubmorph
]

{ #category : #accessing }
SBWatchView >> scroller [

	^ self scrollPane scroller
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

{ #category : #accessing }
SBWatchView >> values [

	watchValues ifEmpty: [^{}].
	^ watchValues collect: [:value | value watchedValue]
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

{ #category : #display }
SBWatchView >> watchValuesContainer [

	^ SBRow new
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 1;
		borderWidth: 0;
		on: #doubleClick send: #exploreValues to: self
]
