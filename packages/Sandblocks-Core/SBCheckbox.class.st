Class {
	#name : #SBCheckbox,
	#superclass : #SBBlock,
	#instVars : [
		'value',
		'nonEdit',
		'radioButtonLook'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCheckbox >> changeValue: aBoolean [

	self value: aBoolean.
	self triggerEvent: #toggled
]

{ #category : #'as yet unclassified' }
SBCheckbox >> click: anEvent [

	super click: anEvent.
	self toggle
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
	
	radioButtonLook := false.
	
	self
		addMorphBack: SBIcon iconCheckSquareO;
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
SBCheckbox >> radioButtonLook [

	^ radioButtonLook ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBCheckbox >> radioButtonLook: aBoolean [

	radioButtonLook := aBoolean.
	self updateIcon
]

{ #category : #'as yet unclassified' }
SBCheckbox >> startInputAt: aNumber replacingContents: aBoolean [

	self toggle.
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBCheckbox >> toggle [

	self sandblockEditor do: (self toggleCommandFor: self containingArtefact)
]

{ #category : #'as yet unclassified' }
SBCheckbox >> toggleCommandFor: anArtefact [

	^ SBMutatePropertyCommand new
		target: self;
		selector: #value;
		mutateSelector: #changeValue:;
		value: self value not
]

{ #category : #'as yet unclassified' }
SBCheckbox >> updateIcon [

	^ self firstSubmorph changeIconName: (self value
		ifTrue: [self radioButtonLook ifTrue: [#iconSquare] ifFalse: [#iconCheckSquareO]]
		ifFalse: [self radioButtonLook ifTrue: [#iconSquareO] ifFalse: [#iconSquareO]])
]

{ #category : #'as yet unclassified' }
SBCheckbox >> value [

	^ value
]

{ #category : #'as yet unclassified' }
SBCheckbox >> value: aBoolean [

	value := aBoolean.
	self updateIcon
]
