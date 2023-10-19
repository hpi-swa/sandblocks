"
A SBVisualization transforms the contents of watches to visual projections for easier reading. 

traceValues are the values getting projected. 
scaleY is a BPScale used to project your values to the canvas appropriately. The x direction is hardcoded; the morph can be
as wide as it needs to be.

Subclasses must provide following methods:
instance-sided: 
- visualizationMorph: The visualization itself provided as a Morph

class-sided: 
- newWithValues: forMorph: : Default constructor. Define a default scale here too.
- supportedInterface: Which interface is supported to be visualized? We assume homogeneous collections for traceValues.

Add a converter function to Collection, see #asLineChart for example
"
Class {
	#name : #SBVisualization,
	#superclass : #SBBlock,
	#instVars : [
		'scaleY',
		'traceValues'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #constants }
SBVisualization class >> canvasHeight [
	
	^ self preferredHeight - self heightMargin
]

{ #category : #constants }
SBVisualization class >> heightMargin [
	
	^ 5 sbScaled
]

{ #category : #constants }
SBVisualization class >> highlightedDataPercentage [
	
	^ 0.1
]

{ #category : #'initialize-release' }
SBVisualization class >> newWithValues: traceValues [
	
	^ self subclassResponsibility
]

{ #category : #constants }
SBVisualization class >> preferredHeight [
	
	^ 100 sbScaled 
]

{ #category : #conversion }
SBVisualization class >> supportedInterface [
	
	^ self subclassResponsibility
]

{ #category : #constants }
SBVisualization class >> traceValuesMorphClassesToFilterOut [
	
	^ {StringMorph}
]

{ #category : #conversion }
SBVisualization class >> visualizationClassesForValues: traceValues [
	
	| containedClasses |
	containedClasses := (traceValues collect: [:tracedValue | tracedValue class]) asSet.
	^ self allSubclasses select: [:aSubclass |
		containedClasses allSatisfy: [:aTracedValueClass | aTracedValueClass withAllSuperclasses includes: aSubclass supportedClass]]
]

{ #category : #'initialize-release' }
SBVisualization class >> visualizationObjectForValues: traceValues overMorph: traceValuesMorph [
	
	| responsibleSubclasses |
	responsibleSubclasses := self visualizationClassesForValues: traceValues.
	(responsibleSubclasses isEmpty)
		ifTrue: [^ (self newWithValues: traceValues forMorph: traceValuesMorph) visualizationMorph].
		
	^ (responsibleSubclasses first newWithValues: traceValues forMorph: traceValuesMorph)
]

{ #category : #visualization }
SBVisualization >> axisYNotation [
	
	^ SBAxisNotation newFromScale: self scaleY ticking: 5 
]

{ #category : #initialization }
SBVisualization >> initialize [ 

	super initialize.
	
	self selectable: false.
	
	self color: self drawnColor;
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		borderWidth: 0;
		yourself
]

{ #category : #testing }
SBVisualization >> isTopLevel [

	^ true
]

{ #category : #'visualization - constants' }
SBVisualization >> lineColor [
	
	^ self drawnColor 
]

{ #category : #visualization }
SBVisualization >> newBackground [
	
	
	^ Morph new
		color: self drawnColor;
		width: (self traceValues size + 2 "to have some margin") * self spaceBetweenPoints;
		height: self class preferredHeight;
		borderWidth: 0;
		yourself
]

{ #category : #'visualization - constants' }
SBVisualization >> scaleLineColor [
	
	^ self sandblockForegroundColor alpha: 0.3
]

{ #category : #'visualization - constants' }
SBVisualization >> scaleLineWidth [ 
	
	^ 1
]

{ #category : #accessing }
SBVisualization >> scaleY [

	^ scaleY
]

{ #category : #accessing }
SBVisualization >> scaleY: aSBScale [

	scaleY := aSBScale.
	
	self visualize
]

{ #category : #'visualization - constants' }
SBVisualization >> spaceBetweenPoints [
	
	^ 10 sbScaled 
]

{ #category : #accessing }
SBVisualization >> traceValues [

	^ traceValues
]

{ #category : #accessing }
SBVisualization >> traceValues: aCollection [

	traceValues := aCollection
]

{ #category : #visualization }
SBVisualization >> visualizationMorph [
	
	^ self subclassResponsibility
]

{ #category : #visualization }
SBVisualization >> visualize [ 
	
	self submorphs copy do: #abandon.
		
	self addAllMorphsBack: {self axisYNotation. self visualizationMorph}
]
