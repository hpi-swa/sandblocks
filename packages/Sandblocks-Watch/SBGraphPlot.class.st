Class {
	#name : #SBGraphPlot,
	#superclass : #SBBlock,
	#instVars : [
		'data',
		'label',
		'labelColor'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #drawing }
SBGraphPlot >> drawOn: aCanvas [

	| max x height |
	max := data max max: 1.
	x := 0.
	height := self height - 1.
	
	data do: [:value | | nowY |
		nowY := (value / max * self height) ceiling.
		aCanvas fillRectangle: (x - self gap @ (height - nowY + 1) + self position extent: self gap @ nowY) color: Color red.
		x := x + self gap].
	
	aCanvas drawString: label, ' (', data last asString, '/', max asString, ')' at: self position font: nil color: labelColor
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> extent: aPoint [

	| point |
	point := aPoint max: 10 @ 30.
	super extent: point.
	data size ~= point x ifTrue: [data size: point x // self gap]
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> gap [
	" gap between plot values "

	^ 1
]

{ #category : #initialization }
SBGraphPlot >> initialize [

	data := SBCyclicList new.
	super initialize.
	label := ''.
	labelColor := Color black.
	self
		hResizing: #spaceFill;
		vResizing: #rigid;
		height: TextStyle defaultFont height * 2
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> label [

	^ label
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> label: aString [

	label := aString
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> labelColor: aColor [

	labelColor := aColor
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> replace: anObject [

	anObject isNumber ifTrue: [self reportValue: anObject].
	anObject isCollection ifTrue: [
		data clear.
		anObject do: [:val | data add: val].
		self changed]
]

{ #category : #'as yet unclassified' }
SBGraphPlot >> reportValue: aNumber [

	data add: aNumber.
	self changed
]
