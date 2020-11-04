Class {
	#name : #SBNode,
	#superclass : #Morph,
	#instVars : [
		'inputs',
		'outputs',
		'flowIn',
		'flowOut',
		'isFlowSource'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBNode >> addInput: aString [

	| label socket |
	label := self newTextMorph contents: aString.
	socket := SBNodeSocket new type: #input.
	inputs addMorphBack: (SBRow new
		cellGap: 2 * self scalingFactor;
		addMorphBack: socket;
		addMorphBack: label).
	^ socket
]

{ #category : #'as yet unclassified' }
SBNode >> addOutput: aString [

	| label socket |
	label := self newTextMorph contents: aString.
	socket := SBNodeSocket new
			type: #output;
			when: #connected send: #maybeRemoveFlowIn to: self.
	outputs addMorphBack: (SBRow new
		cellGap: 2 * self scalingFactor;
		addMorphBack: label;
		addMorphBack: socket).
	^ socket
]

{ #category : #'as yet unclassified' }
SBNode >> bubbleSize [

	^ 12
]

{ #category : #'as yet unclassified' }
SBNode >> drawOn: aCanvas [

	aCanvas fillRoundRect: self bounds radius: 4 * self scalingFactor fillStyle: Color white
]

{ #category : #'as yet unclassified' }
SBNode >> flowIn [

	^ flowIn
]

{ #category : #'as yet unclassified' }
SBNode >> flowOut [

	^ flowOut
]

{ #category : #'as yet unclassified' }
SBNode >> hasFlowIn: aBoolean [

	aBoolean
		ifTrue: [self addMorphFront: flowIn]
		ifFalse: [flowIn delete].
	
	(aBoolean not and:  [isFlowSource not]) ifTrue: [self hasFlowOut: false]
]

{ #category : #'as yet unclassified' }
SBNode >> hasFlowOut: aBoolean [

	aBoolean
		ifTrue: [self addMorphBack: flowOut]
		ifFalse: [flowOut delete]
]

{ #category : #'as yet unclassified' }
SBNode >> initialize [

	super initialize.
	
	flowIn := SBNodeSocket new
		type: #flowIn;
		when: #connected send: #hasFlowOut: to: self with: true.
	flowOut := SBNodeSocket new type: #flowOut.
	isFlowSource := false.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		wrapCentering: #center;
		cellGap: 8 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		
		addMorphBack: (SBRow new
			changeTableLayout;
			addMorphBack: (inputs := SBColumn new);
			addMorphBack: (outputs := SBColumn new))
]

{ #category : #'as yet unclassified' }
SBNode >> inputs [

	^ inputs
]

{ #category : #'as yet unclassified' }
SBNode >> isFlowSource: aBoolean [

	self hasFlowOut: aBoolean.
	isFlowSource := aBoolean.
	aBoolean ifTrue: [self hasFlowIn: false]
]

{ #category : #'as yet unclassified' }
SBNode >> isLink [

	^ false
]

{ #category : #'as yet unclassified' }
SBNode >> isNode [

	^ true
]

{ #category : #'as yet unclassified' }
SBNode >> maybeRemoveFlowIn [

	isFlowSource ifTrue: [^ self].
	
	self hasFlowIn: false
]

{ #category : #'as yet unclassified' }
SBNode >> newTextMorph [

	^ StringMorph new
]

{ #category : #'as yet unclassified' }
SBNode >> output [

	^ outputs firstSubmorph submorphs second
]

{ #category : #'as yet unclassified' }
SBNode >> outputs [

	^ outputs
]
