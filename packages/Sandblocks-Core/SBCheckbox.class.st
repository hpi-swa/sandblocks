Class {
	#name : #SBCheckbox,
	#superclass : #SBBlock,
	#instVars : [
		'value'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCheckbox >> childSandblocksDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBCheckbox >> initialize [

	super initialize.
	
	self
		addMorphBack: SBIcon iconCheck_square_o;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		value: false
]

{ #category : #'as yet unclassified' }
SBCheckbox >> startInputAt: aNumber replacingContents: aBoolean [

	self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
		target: self;
		selector: #value;
		value: self value not).
	
	self triggerEvent: #toggled.
	^ nil
]

{ #category : #'as yet unclassified' }
SBCheckbox >> value [

	^ value
]

{ #category : #'as yet unclassified' }
SBCheckbox >> value: aBoolean [

	self firstSubmorph changeIconName: (aBoolean ifTrue: [#iconCheck_square_o] ifFalse: [#iconSquare_o]).
	value := aBoolean
]
