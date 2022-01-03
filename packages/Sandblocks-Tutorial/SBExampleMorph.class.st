Class {
	#name : #SBExampleMorph,
	#superclass : #Morph,
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'as yet unclassified' }
SBExampleMorph >> drawOn: aCanvas [

	aCanvas fillRectangle: self bounds fillStyle: (self color alpha: 0.4)
]

{ #category : #'as yet unclassified' }
SBExampleMorph >> example [

	SBMorphExample
		setUp: [self class new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:mt | mt]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBExampleMorph >> initialize [

	super initialize.
	
	self extent: 50 asPoint.
	self color: Color red
]

{ #category : #'as yet unclassified' }
SBExampleMorph >> step [

	self position: 60 @ ((Time millisecondClockValue / 100) sin * 30 + 80)
]

{ #category : #'as yet unclassified' }
SBExampleMorph >> stepTime [

	^ 0
]
