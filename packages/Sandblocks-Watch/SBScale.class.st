"
A scale inspired by their usage in d3. Define a domain from which a set of numbers gets projected to your defined range. Both are Interval objects. As operations like min or array accesses don't work on reversed ordered Intervals (eg meaning they're sorted descendingly), only ascending intervals work.

A scale behavior is a block accepting a domain and a value to scale. The output is a percentage [0;1] representing its relative position in your domain. It can scale the value linear, logarithmic, exponentially etc. For an example, view class > linearScale.
"
Class {
	#name : #SBScale,
	#superclass : #Object,
	#instVars : [
		'range',
		'domain',
		'scaleBehavior'
	],
	#category : #'Sandblocks-Watch'
}

{ #category : #scaleBehaviors }
SBScale class >> linearScaleBehavior [
	
	^ [:domain :value | ((value - domain min) /  {domain extent. 1} max) abs]
]

{ #category : #'initialize-release' }
SBScale class >> newLinearScaleWithDomain: aDomainInterval forRange: aRangeInterval [
	
	^ self new
		domain: (
			{aDomainInterval start. aDomainInterval stop} min 
			to: {aDomainInterval start. aDomainInterval stop} max);
		range: (
			{aRangeInterval start. aRangeInterval stop} min 
			to: {aRangeInterval start. aRangeInterval stop} max);
		scaleBehavior: self linearScaleBehavior;
		yourself
]

{ #category : #'initialize-release' }
SBScale class >> newWithDomain: aDomainInterval forRange: aRangeInterval scalingLike: aScaleBehavior [
	
	^ self new
		domain: aDomainInterval;
		range: aRangeInterval;
		scaleBehavior: aScaleBehavior;
		yourself.
]

{ #category : #accessing }
SBScale >> domain [

	^ domain
]

{ #category : #accessing }
SBScale >> domain: anInterval [

	domain := anInterval
]

{ #category : #calculating }
SBScale >> domainValueOfRelative: aNumberFrom0To1 [
	
	"LERP the given number in domain before proceeding normally"
	^ (1 - aNumberFrom0To1) * self domain min + (aNumberFrom0To1 * self domain max)
]

{ #category : #accessing }
SBScale >> range [

	^ range
]

{ #category : #accessing }
SBScale >> range: anInterval [ 

	range := anInterval
]

{ #category : #accessing }
SBScale >> scaleBehavior [

	^ scaleBehavior
]

{ #category : #accessing }
SBScale >> scaleBehavior: aBlock [

	scaleBehavior := aBlock
]

{ #category : #calculating }
SBScale >> scaledValueOf: aNumberInDomain [
	
	"In case the given number is the start of the domain, meaning always at 0% of total range, 
	we might get a ZeroDivide during calculations, so catch the case early by return."
	(aNumberInDomain = self domain first) ifTrue: [^ self range first]. 
	
	^ self range at: (self scaleBehavior value: self domain value: aNumberInDomain) * self range extent +1
]
