Class {
	#name : #SBOverlayOption,
	#superclass : #Morph,
	#instVars : [
		'backgroundColor',
		'suboptions',
		'active',
		'parentOption',
		'place',
		'command',
		'contents'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOverlayOption >> active: aBoolean [

	active = aBoolean ifTrue: [^ self].
	
	active := aBoolean.
	
	self backgroundColor: (aBoolean ifTrue: [Color red] ifFalse: [Color white]).
	self color: (aBoolean ifTrue: [Color white] ifFalse: [Color black]).
	
	suboptions ifNil: [^ self].
	aBoolean
		ifTrue: [suboptions do: [:morph |
					morph
						center: morph parentOption center;
						moveBy: morph place.
					self owner addMorphBack: morph]]
		ifFalse: [suboptions do: #delete]
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> backgroundColor [

	^ backgroundColor
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> backgroundColor: aColor [

	backgroundColor := aColor.
	self changed
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> command [

	^ command
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> command: aSymbol [

	command := aSymbol
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> contents [

	^ contents
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> contents: aString [

	| font |
	contents := aString.
	font := TextStyle defaultFont.
	self extent: (font widthOfString: aString) @ font height + (self bounds extent - self layoutBounds extent)
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> drawOn: aCanvas [

	aCanvas frameAndFillRectangle: self bounds fillColor: self backgroundColor borderWidth: 2 borderColor: Color black.
	aCanvas drawString: self contents in: self layoutBounds font: nil color: (active ifTrue: [Color white] ifFalse: [Color black])
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> focusFrom: aMorph [

	(aMorph notNil and: [aMorph ~= self] and: [aMorph ~= parentOption]) ifTrue: [aMorph active: false].
	self active: true.
	^ self
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> initialize [

	super initialize.
	
	backgroundColor := Color white.
	active := false.
	
	self layoutInset: 8
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> moveBy: aPoint [

	self position: self position + aPoint
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> parentOption [

	^ parentOption
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> parentOption: aMorph [

	parentOption := aMorph
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> place [

	^ place
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> place: aTuple [

	place := aTuple
]

{ #category : #'as yet unclassified' }
SBOverlayOption >> suboptions: aCollection [

	suboptions := aCollection.
	aCollection do: [:morph | morph parentOption: self]
]
