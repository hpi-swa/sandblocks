Class {
	#name : #SBStringMorph,
	#superclass : #StringMorph,
	#category : 'Sandblocks-Core'
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

	^ self containingSandblock foregroundColor
]

{ #category : #drawing }
SBStringMorph >> drawOn: aCanvas [
	" overriden so we can override color "

	aCanvas drawString: contents in: self layoutBounds font: self fontToUse color: self color
]

{ #category : #layout }
SBStringMorph >> minExtent [

	^ (self fontToUse widthOfString: self contents) @ self fontToUse height + (self layoutInset * 2)
]

{ #category : #accessing }
SBStringMorph >> reportValue: anObject [

	self contents: anObject printString
]
