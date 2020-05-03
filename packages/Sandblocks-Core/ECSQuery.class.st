Class {
	#name : #ECSQuery,
	#superclass : #SBBlock,
	#instVars : [
		'bindings'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
ECSQuery >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
ECSQuery >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
ECSQuery >> query: anArray block: aBlock [

	self addMorphBack: anArray.
	self addMorphBack: (bindings := SBRow new).
	self addMorphBack: aBlock.
	
	anArray childSandblocksDo: [:symbol |
		bindings addMorphBack: (SBName contents: symbol contents withFirstCharacterDownshifted)]
]
