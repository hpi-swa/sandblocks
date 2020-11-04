Class {
	#name : #SBSnapToSizeLayout,
	#superclass : #SBLayoutPolicy,
	#instVars : [
		'vertical'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSnapToSizeLayout >> initialize [

	super initialize.
	vertical := true
]

{ #category : #'as yet unclassified' }
SBSnapToSizeLayout >> layout: aMorph in: aRectangle [

	| offset count |
	offset := 0.
	SBToggledCode
		comment: 'distribute space between spaceFill and shrinkWrap children'
		active: 1
		do: {
			[
				count := self layoutMorphsOf: aMorph do: [:m | nil]]
		}.
	self
		layoutMorphsOf: aMorph
		do: [:morph | | extent advance |
			extent := morph minExtent.
			morph layoutInBounds: (aRectangle origin + (vertical ifTrue: [0 @ offset] ifFalse: [offset @ 0]) extent: (vertical
				ifTrue: [
					advance := extent y.
					aRectangle width @ advance]
				ifFalse: [
					advance := aRectangle width / count max: extent x.
					advance @ aRectangle height])).
			offset := offset + advance]
]

{ #category : #'as yet unclassified' }
SBSnapToSizeLayout >> minExtentOf: aMorph in: aRectangle [

	| sum |
	sum := 0.
	self
		layoutMorphsOf: aMorph
		do: [:morph | | extent |
			extent := morph minExtent.
			sum := sum + (vertical ifTrue: [extent y] ifFalse: [extent x])].
	^ aRectangle origin extent: (vertical ifTrue: [aRectangle width @ sum] ifFalse: [sum @ aRectangle height])
]

{ #category : #'as yet unclassified' }
SBSnapToSizeLayout >> vertical: aBoolean [

	vertical := aBoolean
]
