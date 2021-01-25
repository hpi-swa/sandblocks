Class {
	#name : #SBStateMachinePalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStateMachinePalette >> grammarHandler [

	^ SBSmalltalkGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStateMachinePalette >> initialize [

	super initialize.
	
	self addBlock: 'State' as: (SBStateMachineState new name: 'unnamed state')
]
