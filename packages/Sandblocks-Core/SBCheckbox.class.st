Class {
	#name : #SBCheckbox,
	#superclass : #SBBlock,
	#instVars : [
		'value',
		'nonEdit'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCheckbox >> changeValue: aBoolean [

	self value: aBoolean.
	self triggerEvent: #toggled
]

{ #category : #'as yet unclassified' }
SBCheckbox >> childSandblocksDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBCheckbox >> click: anEvent [

	super click: anEvent.
	self changeValue: self value not
]

{ #category : #'as yet unclassified' }
SBCheckbox >> drawnColor [

	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBCheckbox >> initialize [

	super initialize.
	
	nonEdit := false.
	value := false.
	
	self
		addMorphBack: SBIcon iconCheck_square_o;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBCheckbox >> nonEdit [

	^ nonEdit
]

{ #category : #'as yet unclassified' }
SBCheckbox >> nonEdit: aBoolean [

	nonEdit := aBoolean
]

{ #category : #'as yet unclassified' }
SBCheckbox >> startInputAt: aNumber replacingContents: aBoolean [

	self sandblockEditor do: ((self nonEdit
		ifTrue: [SBMutatePropertyCommand newNonEdit]
		ifFalse: [
			SBMutatePropertyCommand newFor: self containingArtefact])
		target: self;
		selector: #value;
		mutateSelector: #changeValue:;
		value: self value not).
	
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
