Class {
	#name : #SBBarChart,
	#superclass : #SBLineChart,
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBBarChart class >> newWithValues: traceValues [
	
	| valuesToVisualize |
	valuesToVisualize := traceValues 
		ifEmpty: [#(0)]
		ifNotEmpty: [traceValues].
	^ self new
		traceValues: valuesToVisualize;
		scaleY: (SBScale 
			newLinearScaleWithDomain: (({valuesToVisualize min. 0} min) to: valuesToVisualize max) 
			forRange: (0 to: self canvasHeight));
		yourself
]

{ #category : #'visualization - constants' }
SBBarChart >> barWidth [

	^ self spaceBetweenPoints / 2
]

{ #category : #visualization }
SBBarChart >> newBarFor: aValue at: positionIndex [
	
	"There is an extra Morph containing the datapoint itself so the tooltip is far easier to activate through more area"
	^ Morph new
		height: self class preferredHeight;
		left: ((positionIndex - 0.5) * self spaceBetweenPoints) rounded;
		width: self spaceBetweenPoints;
		color: Color transparent;
		balloonText: aValue printString;
		addMorph: (Morph new
			color: self datapointDefaultColor;
			width: self barWidth;
			height: {(self scaleY scaledValueOf: aValue). 1} max;
			bottom: self class canvasHeight + self class heightMargin;
			left: positionIndex * self spaceBetweenPoints;
			setProperty: #chartValue toValue: (self scaleY scaledValueOf: aValue);
			yourself);
		yourself
	
		
	
]

{ #category : #visualization }
SBBarChart >> newDataPoints [
	
	^ self traceValues collectWithIndex: [:aTraceValue :index | self newBarFor: aTraceValue at: index]
]

{ #category : #visualization }
SBBarChart >> newLineFrom: aDataPointMorph1 to: aDataPointMorph2 [
	
	^ LineMorph 
		from: aDataPointMorph1 topCenter 
		to: aDataPointMorph2 topCenter  
		color: ((self lineColorFrom: aDataPointMorph1 to: aDataPointMorph2) alpha: 0.2)
		width: self lineWidth
		
	
]
