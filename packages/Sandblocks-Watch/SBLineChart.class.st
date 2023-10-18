Class {
	#name : #SBLineChart,
	#superclass : #SBVisualization,
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBLineChart class >> newWithValues: traceValues [
	
	| valuesToVisualize |
	valuesToVisualize := traceValues 
		ifEmpty: [#(0)]
		ifNotEmpty: [traceValues].
	^ self new
		traceValues: valuesToVisualize;
		scaleY: (SBScale 
			newLinearScaleWithDomain: (valuesToVisualize min to: valuesToVisualize max) 
			forRange: (0 to: self canvasHeight));
		yourself
]

{ #category : #conversion }
SBLineChart class >> supportedInterface [
	
	^ #isNumber
]

{ #category : #visualization }
SBLineChart >> datapointColorForValue: aValue [
	
	| scaledValue |
	scaledValue := self scaleY scaleBehavior value: self scaleY domain value: aValue.
	(scaledValue <= self class highlightedDataPercentage) ifTrue: [^ self datapointLowerPercentColor].
	(scaledValue >= (1 - self class highlightedDataPercentage)) ifTrue: [^ self datapointHigherPercentColor].
	^ self datapointDefaultColor
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointDefaultColor [
	
	^ self sandblockForegroundColor
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointExtent [
	
	^ 5@5
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointHigherPercentColor [
	
	^ Color green
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointLowerPercentColor [
	
	^ Color red
]

{ #category : #visualization }
SBLineChart >> lineColorFrom: aPoint1 to: aPoint2 [
	
	^ (aPoint1 y >= aPoint2 y) 
		ifTrue: [self datapointHigherPercentColor]
		ifFalse: [self datapointLowerPercentColor]
]

{ #category : #'visualization - constants' }
SBLineChart >> lineWidth [
	
	^ 2
]

{ #category : #visualization }
SBLineChart >> newDataPoints [
	
	^ self traceValues collectWithIndex: [:aTraceValue :index |
		 self newDatapointFor: aTraceValue at: index]
]

{ #category : #visualization }
SBLineChart >> newDatapointFor: aValue at: positionIndex [
	
	"There is an extra Morph containing the datapoint itself so the tooltip is far easier to activate through more area"
	^ Morph new
		height: self class preferredHeight;
		left: ((positionIndex - 0.5) * self spaceBetweenPoints) rounded;
		width: self spaceBetweenPoints;
		color: Color transparent;
		balloonText: aValue printString;
		addMorph: (EllipseMorph new
			extent: self datapointExtent;
			color: (self datapointColorForValue: aValue);
			borderWidth: 0;
			left: positionIndex * self spaceBetweenPoints;
			top: self class canvasHeight - (self scaleY scaledValueOf: aValue);
			yourself);
		yourself
	
		
	
]

{ #category : #visualization }
SBLineChart >> newLineFrom: aDataPointMorph1 to: aDataPointMorph2 [
	
	^ LineMorph 
		from: aDataPointMorph1 center 
		to: aDataPointMorph2 center 
		color: (self lineColorFrom: aDataPointMorph1 center to: aDataPointMorph2 center)
		width: self lineWidth
		
	
]

{ #category : #visualization }
SBLineChart >> newLinesForDatapointsOn: visualizationMorph [
	
	^ visualizationMorph submorphs overlappingPairsCollect: [:oneDataPointMorph :anotherDataPointMorph | 
		self 
			newLineFrom: oneDataPointMorph firstSubmorph
			to: anotherDataPointMorph firstSubmorph]
]

{ #category : #visualization }
SBLineChart >> newScaleLinesOn: aMorph [
	
	^ {LineMorph from: 0@self scaleYOffset to: aMorph width@self scaleYOffset
		color: self scaleLineColor width: self scaleLineWidth.
		LineMorph from: 0@(self class canvasHeight/2)+self scaleYOffset to: aMorph width@(self class canvasHeight/2)+self scaleYOffset
		color: self scaleLineColor width: self scaleLineWidth.
		LineMorph from: 0@self class canvasHeight + self scaleYOffset to: aMorph width@self class canvasHeight + self scaleYOffset
		color: self scaleLineColor width: self scaleLineWidth.}
		
	
]

{ #category : #'visualization - constants' }
SBLineChart >> scaleYOffset [
	
	^ self datapointExtent y / 2
]

{ #category : #'visualization - constants' }
SBLineChart >> spaceBetweenPoints [
	
	^ 15
]

{ #category : #visualization }
SBLineChart >> visualizationMorph [
	
	| visualizationMorph |
	visualizationMorph := self newBackground.
		
	visualizationMorph addAllMorphs: self newDataPoints.
	visualizationMorph addAllMorphsBack: (self newLinesForDatapointsOn: visualizationMorph).
	visualizationMorph addAllMorphsBack: (self newScaleLinesOn: visualizationMorph).
	
	^ visualizationMorph
]
