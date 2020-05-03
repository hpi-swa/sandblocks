Class {
	#name : #SBNewNode,
	#superclass : #Morph,
	#instVars : [
		'inputMorphs',
		'outputMorphs',
		'flowIn',
		'flowOut',
		'inOutMorphs'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBNewNode >> autoPlace [

	self autoPlaceInputs
]

{ #category : #'as yet unclassified' }
SBNewNode >> autoPlaceInputs [

	self inputSockets do: [:input |
		input connectedLink sourceNode
			fullBounds;
			centerRight: (input leftCenter - (50 @ 0));
			autoPlace]
]

{ #category : #'as yet unclassified' }
SBNewNode >> flowInSocket [

	^ flowIn
]

{ #category : #'as yet unclassified' }
SBNewNode >> flowOutSocket [

	^ flowOut
]

{ #category : #'as yet unclassified' }
SBNewNode >> hasFlowIn [

	^ false
]

{ #category : #'as yet unclassified' }
SBNewNode >> hasFlowOut [

	^ false
]

{ #category : #'as yet unclassified' }
SBNewNode >> initialize [

	super initialize.
	
	flowIn := SBNewNodeSocket new type: #flowIn.
	flowOut := SBNewNodeSocket new type: #flowOut.
	
	self
		listDirection: #topToBottom;
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color white;
		addMorphBack: (inOutMorphs := SBRow new
			changeTableLayout;
			cellGap: 12;
			addMorphBack: (inputMorphs := SBColum new changeTableLayout);
			addMorphBack: (outputMorphs := SBColum new changeTableLayout));
		update
]

{ #category : #'as yet unclassified' }
SBNewNode >> inputSockets [

	^ inputMorphs submorphs
]

{ #category : #'as yet unclassified' }
SBNewNode >> inputs [

	^ #()
]

{ #category : #'as yet unclassified' }
SBNewNode >> isLink [

	^ false
]

{ #category : #'as yet unclassified' }
SBNewNode >> isNode [

	^ true
]

{ #category : #'as yet unclassified' }
SBNewNode >> merge: aMorph withLabels: aStringCollection type: aSymbol [

	" add new ones "
	aMorph submorphCount + 1 to: aStringCollection size do: [:index |
		aMorph addMorphBack: (SBNewNodeSocket new type: aSymbol)].
	
	" remove left overs "
	aStringCollection size + 1 to: aMorph submorphCount do: [:index |
		aMorph removeMorph: aMorph lastSubmorph].
	
	" update label "
	aMorph submorphs with: aStringCollection do: [:morph :label  | morph label: label]
]

{ #category : #'as yet unclassified' }
SBNewNode >> outputSockets [

	^ outputMorphs submorphs
]

{ #category : #'as yet unclassified' }
SBNewNode >> outputs [

	^ #()
]

{ #category : #'as yet unclassified' }
SBNewNode >> update [

	self merge: inputMorphs withLabels: self inputs type: #input.
	self merge: outputMorphs withLabels: self outputs type: #output.
	
	self hasFlowIn ifTrue: [self addMorphFront: flowIn] ifFalse: [flowIn delete].
	self hasFlowOut ifTrue: [self addMorphBack: flowOut] ifFalse: [flowOut delete].
	
	self extent: 0 @ 0.
	
	self layoutInset: (Rectangle
		left: (inputMorphs submorphs ifEmpty: [8] ifNotEmpty: [0])
		right: (outputMorphs submorphs ifEmpty: [8] ifNotEmpty: [0])
		top: (self hasFlowIn ifTrue: [0] ifFalse: [8])
		bottom: (self hasFlowOut ifTrue: [0] ifFalse: [8]))
]
