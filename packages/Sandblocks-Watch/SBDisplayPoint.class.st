Class {
	#name : #SBDisplayPoint,
	#superclass : #Morph,
	#instVars : [
		'lastPoint',
		'label',
		'pointers',
		'direction'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayPoint class >> matches: anObject [

	^ anObject isPoint
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> dark: aBoolean [
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> exampleFinished: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> hidePoint [

	pointers do: [:p | p delete].
	pointers := #()
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> initialize [

	super initialize.
	
	pointers := #().
	
	self
		on: #mouseEnter send: #showPoint to: self;
		on: #mouseLeave send: #hidePoint to: self;
		changeTableLayout;
		listDirection: #leftToRight;
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (direction := ImageMorph new image: (Form extent: 24 asPoint depth: 32))
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> reportValue: aPoint [

	lastPoint := aPoint.
	label contents: aPoint asString.
	self updateDirection
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> showPoint [

	pointers := Array streamContents: [:stream |
		self sandblockEditor allActiveMorphExamples do: [:example |
			example view addMorph: (stream nextPut: (Morph new extent: 8 asPoint; center: lastPoint; color: Color green))]]
]

{ #category : #'as yet unclassified' }
SBDisplayPoint >> updateDirection [

	| canvas arrow size |
	canvas := direction form getCanvas.
	size := direction image width // 2.
	(lastPoint x = 0 and: [lastPoint y = 0])
		ifTrue: [canvas fillColor: Color transparent]
		ifFalse: [
			arrow := lastPoint normalized * size.
	
			canvas fillColor: Color transparent.
			canvas line: size asPoint to: size asPoint + arrow color: Color white.
			canvas fillRectangle: (size asPoint - 2 extent: 4 asPoint) color: Color white]
]
