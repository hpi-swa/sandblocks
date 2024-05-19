Class {
	#name : #SBLineChart,
	#superclass : #SBVisualization,
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBLineChart class >> newWithValues: traceValues havingHeight: aNumber [
	
	| valuesToVisualize |
	valuesToVisualize := traceValues 
		ifEmpty: [#(0)]
		ifNotEmpty: [traceValues].
	^ self new
		targetHeight: aNumber;
		traceValues: valuesToVisualize;
		scaleY: (SBScale 
			newLinearScaleWithDomain: (valuesToVisualize min to: valuesToVisualize max) 
			forRange: (0 to: aNumber));
		yourself
]

{ #category : #conversion }
SBLineChart class >> supportedInterface [
	
	^ #isNumber
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointDefaultColor [
	
	^ self sandblockForegroundColor
]

{ #category : #'visualization - constants' }
SBLineChart >> datapointExtent [
	
	^ 3@3 sbScaled 
]

{ #category : #geometry }
SBLineChart >> extent: aPoint [

	super extent: aPoint.
	self targetHeight: aPoint y- 6.
	self scaleY range: (self scaleY range start to: aPoint y).
	self visualize
]

{ #category : #visualization }
SBLineChart >> lineColorFrom: aDataPoint1 to: aDataPoint2 [
	
	"Comparing y coordinates might yield false results as the coordinates are rounded
	to whole numbers"
	^ ((aDataPoint1 valueOfProperty: #chartValue) <= (aDataPoint2 valueOfProperty: #chartValue))
		ifTrue: [self positiveGradientColor]
		ifFalse: [self negativeGradientColor]
]

{ #category : #'visualization - constants' }
SBLineChart >> lineWidth [
	
	^ 2 sbScaled 
]

{ #category : #'visualization - constants' }
SBLineChart >> negativeGradientColor [
	
	^ Color red
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
		height: self targetHeight;
		left: ((positionIndex - 0.5)  * self spaceBetweenPoints ) rounded;
		width: self spaceBetweenPoints;
		color: Color transparent;
		balloonText: aValue printString;
		addMorph: (EllipseMorph new
			extent: self datapointExtent;
			color: self datapointDefaultColor;
			borderWidth: 0;
			left: positionIndex * self spaceBetweenPoints;
			top: ((self targetHeight - (self scaleY scaledValueOf: aValue)) 
				clampLow: 0 
				high: (targetHeight - (self datapointExtent y / 2)));
			setProperty: #chartValue toValue: (self scaleY scaledValueOf: aValue); 
			yourself);
		yourself 
]

{ #category : #visualization }
SBLineChart >> newLineFrom: aDataPointMorph1 to: aDataPointMorph2 [
	
	^ LineMorph 
		from: aDataPointMorph1 center 
		to: aDataPointMorph2 center 
		color: (self lineColorFrom: aDataPointMorph1 to: aDataPointMorph2)
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
SBLineChart >> newScaleLineFrom: anOrigin to: anEnd [ 
	
	^ LineMorph from: anOrigin to: anEnd color: self scaleLineColor width: self scaleLineWidth
		
	
]

{ #category : #visualization }
SBLineChart >> newScaleLineHeight: height length: length [ 
	
	^ LineMorph 
		from: 0 @ height 
		to: length @ height 
		color: self scaleLineColor 
		width: self scaleLineWidth
		
	
]

{ #category : #visualization }
SBLineChart >> newScaleLinesOn: aMorph [
	
	| section |
	section := self targetHeight / (self numberScaleLines - 1).
	^ (0 to: (self numberScaleLines - 1)) collect: [:i | 
		self newScaleLineHeight: (section * i) length: aMorph width]
		
	
]

{ #category : #'visualization - constants' }
SBLineChart >> numberScaleLines [

	^ 5
]

{ #category : #'visualization - constants' }
SBLineChart >> positiveGradientColor [
	
	^ Color green
]

{ #category : #'visualization - constants' }
SBLineChart >> spaceBetweenPoints [
	
	^ 6 sbScaled
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
