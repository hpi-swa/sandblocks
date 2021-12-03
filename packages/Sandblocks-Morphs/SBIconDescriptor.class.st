Class {
	#name : #SBIconDescriptor,
	#superclass : #Object,
	#instVars : [
		'svg',
		'color',
		'size'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBIconDescriptor class >> svg: anSvg color: aColor size: aNumber [

	^ self new
		svg: anSvg;
		color: aColor;
		size:  aNumber;
		yourself
]

{ #category : #comparing }
SBIconDescriptor >> = anIconDescriptor [

	^ self svg == anIconDescriptor svg and:
	[self size = anIconDescriptor size and:
	[self color = anIconDescriptor color]]
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> averageColorInQuadOfSize: aNumber at: aPoint from: aForm [

	| alpha blue green num red |
	red := 0.
	green := 0.
	blue := 0.
	alpha := 0.
	num := 0.
	
	(aPoint x - aNumber max: 0) to: (aPoint x + aNumber min: aForm width - 1) do: [:x |
		(aPoint y - aNumber max: 0) to: (aPoint y + aNumber min: aForm height - 1) do: [:y | | p |
			p := aForm pixelValueAt: x @ y.
			red := red + ((p bitShift: -16) bitAnd: 16rFF).
			green := green + ((p bitShift: -8) bitAnd: 16rFF).
			blue := blue + (p bitAnd: 16rFF).
			alpha := alpha + (p bitShift: -24).
			num := num + 1]].
	^ (Color r: red / num g: green / num b: blue / num range: 255) alpha: alpha asFloat / num / 255.0
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> color [

	^ color
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> color: aColor [

	color := aColor
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> correctColorFromPixelValue: p [
	" Color class' colorFromPixelValue:depth: thinks colors are transparent when they're black "

	| alpha b g r |
	r := (p bitShift: -16) bitAnd: 16rFF.
	g := (p bitShift: -8) bitAnd: 16rFF.
	b := p bitAnd: 16rFF.
	alpha := p bitShift: -24.
	alpha = 0 ifTrue: [^Color transparent].
	^ (Color r: r g: g b: b range: 255) alpha: (alpha asFloat / 255.0)
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> downSample: aForm from: aFactor [

	| x y f |
	x := 0.
	y := 0.
	f := (Form extent: self size asPoint depth: 32) collectColors: [:c | | avgColor |
		avgColor := self averageColorInQuadOfSize: aFactor at: x @ y * aFactor from: aForm.
		x := x + 1.
		x >= self size ifTrue: [y := y + 1. x := 0].
		avgColor].
	"((Array streamContents: [:s | f collectColors: [:c | s nextPut: c]]) allSatisfy: #isTransparent) ifTrue: [self halt]."
	^ f
]

{ #category : #comparing }
SBIconDescriptor >> hash [

	self flag: #fixme. "not idea how collision-poor this is"
	^ (self svg hash bitXor: self size hash) bitXor: self color hash
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> renderForm [

	| rect form |
	rect := 0 @ 0 extent: self size asPoint * SBIcon supersamplingFactor.
	self svg bounds: rect.
	self svg allMorphsDo: [:morph |
		self color ifNil: [self halt].
		morph style at: 'fill' put: self color].
	
	form := self svg imageFormForRectangle: rect.
	^ SBIcon supersamplingFactor > 1
		ifTrue: [form scaledToSize: self size asPoint smoothing: 16]
		ifFalse: [form]
]

{ #category : #accessing }
SBIconDescriptor >> size [

	^ size
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> size: aNumber [

	size := aNumber
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> svg [

	^ svg
]

{ #category : #'as yet unclassified' }
SBIconDescriptor >> svg: anSvg [

	svg := anSvg
]
