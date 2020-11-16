Class {
	#name : #SBMethodSelect,
	#superclass : #SBComboBox,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBMethodSelect >> display: anObject [

	^ anObject asString asUppercase
]

{ #category : #'as yet unclassified' }
SBMethodSelect >> initialize [

	super initialize.
	
	self layoutInset: (SBEdgeInsets left: 2 right: 2 top: 1 bottom: 2)
]

{ #category : #'as yet unclassified' }
SBMethodSelect >> values [

	^ #(get put post delete patch head options trace connect)
]
