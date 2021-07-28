Class {
	#name : #SBMarkedDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'letter'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMarkedDecorator >> letter [

	^ letter
]

{ #category : #'as yet unclassified' }
SBMarkedDecorator >> letter: aCharacter [

	letter := aCharacter
]

{ #category : #'as yet unclassified' }
SBMarkedDecorator >> postDrawOn: aCanvas [

	| font origin |
	aCanvas
		frameRectangle: (self morph bounds expandBy: 2)
		width: self morph frameSize
		color: self morph sandblockEditor colorPolicy highlightColor.
	
	letter ifNotNil: [
		font := TextStyle defaultFont.
		origin := self morph topRight - ((font widthOf: self letter) @ 0) + (4 @ -4).
		aCanvas
			fillRectangle: (origin extent: (font widthOf: self letter) + 2 @ font height)
			color: self morph sandblockEditor colorPolicy highlightColor.
		aCanvas drawString: self letter asString at: origin + (1 @ 0)]
]
