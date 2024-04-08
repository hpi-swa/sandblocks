"
A row in SBExampleWatches, containing the belonging example name and a view (display) of the evaluated expression values 
"
Class {
	#name : #SBExampleValueDisplay,
	#superclass : #Morph,
	#instVars : [
		'display',
		'label',
		'statusLabel',
		'hadValue'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #actions }
SBExampleValueDisplay >> clear [

	display clear.
	
	hadValue := false
]

{ #category : #accessing }
SBExampleValueDisplay >> display [

	^ display
]

{ #category : #accessing }
SBExampleValueDisplay >> displayedWatchValueBlocks [

	display isDisplayingWatchValues ifFalse: [^ {}].
	^ display displayedMorphs
]

{ #category : #accessing }
SBExampleValueDisplay >> exampleFinished: anExample [

	display exampleFinished: anExample.
	
	statusLabel
		contents: (hadValue 
			ifTrue: [''] 
			ifFalse: ['- Not reached -']);
		visible: hadValue not
]

{ #category : #accessing }
SBExampleValueDisplay >> exampleStarting: anExample [

	display exampleStarting: anExample.
	
	statusLabel contents: '...'.
	hadValue := false.
	
	self refreshWorld
]

{ #category : #initialization }
SBExampleValueDisplay >> initialize [

	super initialize.
	
	self color: Color transparent;
		cellGap: 5;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new;
		changeListDirection: #leftToRight;
		"To position the labels / buttons not directly at the top, which looks worse
		for displays displaying text"
		addMorphBack: (Morph new 
							color: Color transparent;
							changeTableLayout;
							changeListDirection: #leftToRight;
							vResizing: #shrinkWrap;
							hResizing: #shrinkWrap;
							cellGap: 2;
							layoutInset: 2@3;
							addAllMorphsBack: {
							label := SBStringMorph new visible: false. 
							statusLabel := SBStringMorph new contents: ''.
							self newChangeVizButton};
							yourself);
		addMorphBack: (display := SBExampleWatch watchViewClass new)
]

{ #category : #accessing }
SBExampleValueDisplay >> label [

	^ label contents
]

{ #category : #accessing }
SBExampleValueDisplay >> label: aString [

	label contents: aString
]

{ #category : #accessing }
SBExampleValueDisplay >> labelMorph [

	^ label
]

{ #category : #layout }
SBExampleValueDisplay >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: ((self submorphs select: [:s | s visible])
			collect: #layoutCommands
			separatedBy: [SBAlgebraCommand gap])
]

{ #category : #naming }
SBExampleValueDisplay >> name: aString [

	label contents: aString
]

{ #category : #layout }
SBExampleValueDisplay >> newChangeVizButton [

	^ SBButton new
		icon: SBIcon iconBarChart
			do: [display changeDisplay];
		balloonText: 'Change Visualisation';
		makeSmall;
		cornerStyle: #squared
]

{ #category : #'event handling' }
SBExampleValueDisplay >> reportValues: aCollectionOfWatchValues name: aString sized: aSBMorphResizer [

	display reportValues: aCollectionOfWatchValues sized: aSBMorphResizer.
	label contents: aString.
	label visible: false.
	hadValue := true
]

{ #category : #actions }
SBExampleValueDisplay >> resizeThrough: aMorphResizer [

	display resizeThrough: aMorphResizer
]

{ #category : #actions }
SBExampleValueDisplay >> updateDisplay [ 

	display updateDisplay.
	
	statusLabel contents: (hadValue
		ifTrue: ['']
		ifFalse:  ['- Not reached -'])
]
