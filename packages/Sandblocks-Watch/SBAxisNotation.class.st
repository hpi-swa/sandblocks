"
A numerical legend for a scale
"
Class {
	#name : #SBAxisNotation,
	#superclass : #Morph,
	#instVars : [
		'scale',
		'numberTicks'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #'initialize-release' }
SBAxisNotation class >> newFromScale: aSBScale ticking: aNumber [

	^ self new
		scale: aSBScale
		numberTicks: aNumber
]

{ #category : #initialization }
SBAxisNotation >> initialize [ 

	super initialize.
	
	numberTicks := 3.
	scale := SBScale newLinearScaleWithDomain: (0 to: 100) forRange: (0 to: 100).
	
	self color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #spaceFill
]

{ #category : #accessing }
SBAxisNotation >> numberTicks [

	^ numberTicks
]

{ #category : #accessing }
SBAxisNotation >> numberTicks: aNumber [

	numberTicks := aNumber.
	
	self visualize
]

{ #category : #visualization }
SBAxisNotation >> relativeTickHeights [

	| section adjustedTicks |
	(self numberTicks < 2) ifTrue: [^#()].
	
	"Starting count from 0 here instead of 1"
	adjustedTicks := self numberTicks - 1.
	section := 1 / adjustedTicks.
	^ (0 to: adjustedTicks) collect: [:i | (section * i)]
]

{ #category : #accessing }
SBAxisNotation >> scale [

	^ scale
]

{ #category : #accessing }
SBAxisNotation >> scale: aSBScale [

	scale := aSBScale.
	
	self visualize
]

{ #category : #accessing }
SBAxisNotation >> scale: aSBScale numberTicks: aNumber [

	scale := aSBScale.
	numberTicks := aNumber.
	
	self visualize
]

{ #category : #visualization }
SBAxisNotation >> visualize [

	self submorphs copy do: #abandon.
	self relativeTickHeights withIndexDo: [:aFraction :i | | annotation |
		annotation := SBOwnTextMorph new 
			contents: ((self scale scaledValueOfRelative: aFraction) asString);
			layoutFrame: (LayoutFrame new topFraction: aFraction).
		"Fraction 1 will result in the text being just underneath ourself, so substract height as offset"
		(aFraction = 1) ifTrue: [annotation layoutFrame topOffset: (-1*(annotation minExtent y))].
		self addMorph: annotation.]
		
	
]
