Class {
	#name : #SBStNewCascade,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNewCascade >> canDeleteChild: aBlock [

	^ aBlock ~= self receiver
]

{ #category : #'as yet unclassified' }
SBStNewCascade >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self receiver layoutCommands.
			SBAlgebraCommand group data: (self messages gather: [:message | {SBAlgebraCommand hardLine withGap: true. message layoutCommands}])}
]

{ #category : #'as yet unclassified' }
SBStNewCascade >> messages [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBStNewCascade >> receiver [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStNewCascade >> receiver: aBlock messages: aCollection [

	self addMorphBack: aBlock.
	aCollection do: [:m | self addMorphBack: m]
]
