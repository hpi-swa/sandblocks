Class {
	#name : #SBStringMorph,
	#superclass : #StringMorph,
	#instVars : [
		'opacity'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #accessing }
SBStringMorph >> bold [

	self emphasis: TextEmphasis bold emphasisCode
]

{ #category : #accessing }
SBStringMorph >> clearEmphasis [

	self flag: #fixme. " the stringmorph API is a little borked when it comes to clearing format "
	emphasis := 0.
	font := nil.
	self emphasis: 0
]

{ #category : #accessing }
SBStringMorph >> color [

	^ self sandblockForegroundColor alpha: self opacity
]

{ #category : #'as yet unclassified' }
SBStringMorph >> color: aColor [

	aColor ifNotNil: [super color: aColor] ifNil: [
		color := aColor]
]

{ #category : #drawing }
SBStringMorph >> drawOn: aCanvas [
	" overriden so we can override color "

	aCanvas drawString: self contents in: self layoutBounds font: self fontToUse color: self color
]

{ #category : #'as yet unclassified' }
SBStringMorph >> fontToUse [

	^ super fontToUse
]

{ #category : #'as yet unclassified' }
SBStringMorph >> initialize [

	super initialize.
	color := nil
]

{ #category : #accessing }
SBStringMorph >> italic [

	self emphasis: TextEmphasis italic emphasisCode
]

{ #category : #'as yet unclassified' }
SBStringMorph >> large [

	self font: (TextStyle default fontOfSize: 22)
]

{ #category : #layout }
SBStringMorph >> minExtent [

	^ (self fontToUse widthOfString: self contents) @ self fontToUse height + (self layoutInset * 2)
]

{ #category : #'as yet unclassified' }
SBStringMorph >> opacity [

	^ opacity ifNil: [1]
]

{ #category : #'as yet unclassified' }
SBStringMorph >> opacity: aNumber [

	opacity := aNumber
]

{ #category : #accessing }
SBStringMorph >> reportValue: anObject [

	self contents: anObject printString
]

{ #category : #accessing }
SBStringMorph >> wantsMetaMenu [

	^ false
]
