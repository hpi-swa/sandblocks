Class {
	#name : #SBStringMorph,
	#superclass : #StringMorph,
	#instVars : [
		'opacity'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #layout }
SBStringMorph >> applyUserInterfaceTheme [

	super applyUserInterfaceTheme.
	
	font := nil.
	self extent: self minExtent
]

{ #category : #accessing }
SBStringMorph >> basicContents: newContents [

	contents := newContents.
]

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

	^ (self sandblockForegroundColor ifNil: [Color black]) alpha: self opacity
]

{ #category : #'as yet unclassified' }
SBStringMorph >> color: aColor [

	aColor ifNotNil: [super color: aColor] ifNil: [
		color := aColor]
]

{ #category : #drawing }
SBStringMorph >> drawOn: aCanvas [
	" overriden so we can override color "

	aCanvas
		drawString: self contents
		in: (self layoutBounds translateBy: 0 @ 0.75 sbScaled sbScaled)
		font: self fontToUse
		color: self color
]

{ #category : #'as yet unclassified' }
SBStringMorph >> initialize [

	super initialize.
	color := nil
]

{ #category : #testing }
SBStringMorph >> isStringMorph [

	^ true
]

{ #category : #accessing }
SBStringMorph >> italic [

	self emphasis: TextEmphasis italic emphasisCode
]

{ #category : #'as yet unclassified' }
SBStringMorph >> large [

	self font: (TextStyle default fontOfSize: 22 sbScaled)
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

{ #category : #'as yet unclassified' }
SBStringMorph >> small [

	self font: (TextStyle default fontOfSize: 10)
]

{ #category : #'as yet unclassified' }
SBStringMorph >> tiny [

	self font: (TextStyle default fontOfSize: 6)
]

{ #category : #accessing }
SBStringMorph >> wantsMetaMenu [

	^ false
]
