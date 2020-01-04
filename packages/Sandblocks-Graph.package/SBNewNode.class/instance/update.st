as yet unclassified
update

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