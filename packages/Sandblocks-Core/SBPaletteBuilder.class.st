Class {
	#name : #SBPaletteBuilder,
	#superclass : #SBColumn,
	#instVars : [
		'categories'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> addBlock: aString as: aBlock [

	| block |
	SBToggledCode
		comment: ''
		active: 0
		do: {[self addMorphBack: (SBStringMorph new contents: aString)]}.
	block := (aBlock isInlineBlock and: [aBlock factory rootRuleName = aBlock type])
		ifTrue: [aBlock childSandblocks first]
		ifFalse: [aBlock].
	self addMorphBack: (self container: block label: aString)
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> addHeader: aString [

	categories addMorphBack: (Morph new
		color: Color transparent;
		height: 8).
	categories addMorphBack: (SBStringMorph new
		contents: aString;
		bold)
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> addSectionHeader: aString [

	| header |
	header := SBStringMorph new
		contents: aString;
		bold.
	self addMorphBack: (Morph new
		color: Color transparent;
		height: 16).
	self addMorphBack: header.
	self addMorphBack: (Morph new
		color: Color transparent;
		height: 4).
	
	categories addMorphBack: (SBStringMorph new
		contents: aString;
		on: #click send: #scrollToSection:event:morph: to: self withValue: header)
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> addSubSectionHeader: aString [

	| header |
	header := SBStringMorph new contents: (aString asUppercase asText addAttribute: (TextFontChange fontNumber: 1)).
	self hasSubmorphs ifTrue: [
		self addMorphBack: (Morph new
			color: Color transparent;
			height: 4)].
	self addMorphBack: header.
	self addMorphBack: (Morph new
		color: Color transparent;
		height: 4)
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> categories [

	^ categories
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> container: aBlock label: aString [

	^ SBPalettePreviewContainer new
		methodClass: nil;
		label: aString;
		addMorphBack: (self markCopyPlaceholder: aBlock)
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> content [

	^ self
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> initialize [

	super initialize.
	
	categories := SBColumn new
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> markCopyPlaceholder: aBlock [

	(aBlock nextBlockThat: [:m | m isUnknown]) ifNotNil: [:m | m setProperty: #copyPlaceholder toValue: true].
	^ aBlock
]

{ #category : #'as yet unclassified' }
SBPaletteBuilder >> scrollToSection: aBlock event: anEvent morph: aMorph [

	self owner owner owner vScrollBar setValue: aBlock top
]
