Class {
	#name : #SBRectangleChart,
	#superclass : #SBVisualization,
	#instVars : [
		'scaleX'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBRectangleChart class >> newWithValues: traceValues havingHeight: aNumber [
	
	| biggestCoordinate absolutePoints coordinateSystemSize |
	absolutePoints := traceValues collect: [:aPoint | aPoint abs].
	biggestCoordinate := {absolutePoints max x. absolutePoints max y} max.
	coordinateSystemSize := aNumber.
	^ self new
		targetHeight: aNumber;
		traceValues: traceValues;
		scaleY: (SBScale 
			newLinearScaleWithDomain:  (biggestCoordinate negated to: biggestCoordinate) 
			forRange: (coordinateSystemSize / 2 negated to: coordinateSystemSize  / 2))
		scaleX: (SBScale  
			newLinearScaleWithDomain: (biggestCoordinate negated to: biggestCoordinate) 
			forRange: (coordinateSystemSize / 2 negated to: coordinateSystemSize  / 2));
		yourself
]

{ #category : #conversion }
SBRectangleChart class >> supportedInterface [
	
	^ #isPoint
]

{ #category : #visualization }
SBRectangleChart >> borderStyleFor: scaledValues [
	
	| borderWidth color |
	borderWidth := 0.
	color := Color transparent.
	
	((scaledValues y <= self class highlightedDataPercentage) 
	or: [scaledValues x <= self class highlightedDataPercentage])
		ifTrue: [ borderWidth := borderWidth + 1. color := self valueLowerPercentColor.].	
			
	((scaledValues y >= (1 - self class highlightedDataPercentage)) 
	or: [scaledValues x >= (1 - self class highlightedDataPercentage)])
		ifTrue: [ borderWidth := borderWidth + 1. color := self valueHigherPercentColor.].	
			
	(borderWidth >= 2) ifTrue: [color := self valueHigherLowerPercentColor].
	
	^  BorderStyle width: borderWidth color: color
]

{ #category : #'visualization - constants' }
SBRectangleChart >> coordinateSystemSize [
	
	^ self targetHeight @ self targetHeight
]

{ #category : #geometry }
SBRectangleChart >> extent: aPoint [

	super extent: aPoint.
	self targetHeight: aPoint y.
	self scaleY range: (aPoint y / 2 negated to: aPoint y / 2).
	self scaleX range: (aPoint y / 2 negated to: aPoint y / 2).
	self visualize
]

{ #category : #visualization }
SBRectangleChart >> newCoordinateSystemFor: aValue at: positionIndex [
	
	| left center |
	"There is an extra Morph containing the lines so the tooltip is far easier to activate through more area"
	left := ((positionIndex - 1) * self spaceBetweenPoints) rounded.
	center := ((positionIndex - 0.5) * self spaceBetweenPoints) rounded.
	^ Morph new
		extent: self coordinateSystemSize;
		left: left;
		width: self spaceBetweenPoints;
		color: Color transparent;
		balloonText: aValue printString;
		addAllMorphs: 
			{LineMorph 
				from: center@0 
				to: center@(self coordinateSystemSize y)
				color: self lineColor width: self scaleLineWidth.
			LineMorph 
				from: left@(self coordinateSystemSize y / 2) 
				to: (left + self spaceBetweenPoints)@(self coordinateSystemSize y / 2) 
				color: self lineColor width: self scaleLineWidth.};
		yourself
]

{ #category : #visualization }
SBRectangleChart >> newCoordinateSystems [
	
	^ self traceValues collectWithIndex: [:aTraceValue :index |
		 self newCoordinateSystemFor: aTraceValue at: index]
]

{ #category : #visualization }
SBRectangleChart >> newRectangleFor: aValue at: positionIndex [
	
	| scaledWidth scaledHeight left |
	scaledWidth := self scaleX scaledValueOf: aValue x.
	scaledHeight := self scaleY scaledValueOf: aValue y.
	left := ((positionIndex - 0.5) * self spaceBetweenPoints) rounded.
	^ Morph new
		extent: {scaledWidth abs. 1} max@{scaledHeight abs. 1} max;
		color: (self rectangleColorForValue: aValue);
		borderStyle: (self borderStyleFor: (scaledWidth @ scaledHeight));
		left:  ({scaledWidth. 0} min )+ left;
		top: (self coordinateSystemSize y / 2) - {scaledHeight. 0} max;
		yourself
	
]

{ #category : #visualization }
SBRectangleChart >> newRectangles [
	
	^ self traceValues collectWithIndex: [:aTraceValue :index |
		 self newRectangleFor: aTraceValue at: index]
]

{ #category : #visualization }
SBRectangleChart >> rectangleColorForValue: aPoint [
	
	(aPoint x >= 0 and: [aPoint y >= 0]) ifTrue: [^ self rectanglePosPosColor].
	(aPoint x >= 0 and: [aPoint y < 0]) ifTrue: [^ self rectanglePosNegColor].
	(aPoint x < 0 and: [aPoint y < 0]) ifTrue: [^ self rectangleNegNegColor].
	(aPoint x < 0 and: [aPoint y >= 0]) ifTrue: [^ self rectangleNegPosColor].
]

{ #category : #'visualization - constants' }
SBRectangleChart >> rectangleNegNegColor [
	
	^ Color red
]

{ #category : #'visualization - constants' }
SBRectangleChart >> rectangleNegPosColor [
	
	^ Color bubblegum
]

{ #category : #'visualization - constants' }
SBRectangleChart >> rectanglePosNegColor [
	
	^ Color bubblegum
]

{ #category : #'visualization - constants' }
SBRectangleChart >> rectanglePosPosColor [
	
	^ Color green
]

{ #category : #accessing }
SBRectangleChart >> scaleX [

	^ scaleX
]

{ #category : #accessing }
SBRectangleChart >> scaleX: aSBScale [

	scaleX := aSBScale.
	
	self visualize
]

{ #category : #accessing }
SBRectangleChart >> scaleY: aYSBScale scaleX: aXSBScale [

	scaleY := aYSBScale.
	scaleX := aXSBScale.
	
	self visualize
]

{ #category : #'visualization - constants' }
SBRectangleChart >> spaceBetweenPoints [
	
	^ self coordinateSystemSize x
]

{ #category : #'visualization - constants' }
SBRectangleChart >> valueHigherLowerPercentColor [
	
	^ Color black
]

{ #category : #'visualization - constants' }
SBRectangleChart >> valueHigherPercentColor [
	
	^ Color green
]

{ #category : #'visualization - constants' }
SBRectangleChart >> valueLowerPercentColor [
	
	^ Color red
]

{ #category : #visualization }
SBRectangleChart >> visualizationMorph [
	
	| visualizationMorph |
	visualizationMorph := self newBackground.
	visualizationMorph addAllMorphs: self newCoordinateSystems.
	visualizationMorph addAllMorphs: self newRectangles.
	
	^ visualizationMorph
]
