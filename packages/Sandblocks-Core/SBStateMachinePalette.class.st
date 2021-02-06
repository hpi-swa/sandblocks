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

{ #category : #'as yet unclassified' }
SBStateMachinePalette >> matchesBlock: aBlock [

	SBExample
		self: [SBStateMachinePalette new]
		args: [{(SBStateMachineExample >> #initialize) asSandblock statements last expression}]
		label: 'toplevel'
		assert: [true].
	SBExample
		self: [SBStateMachinePalette new]
		args: [{(SBStateMachineExample >> #initialize) asSandblock statements last expression firstSubmorph}]
		label: 'nested'
		assert: [true].
	(aBlock isKindOf: SBStateMachineEditor) ifTrue: [^ true].
	^ (aBlock ownerSatisfying: [:owner | owner isKindOf: SBStateMachineEditor]) notNil
]
