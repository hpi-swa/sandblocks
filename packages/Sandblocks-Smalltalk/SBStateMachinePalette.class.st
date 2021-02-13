Class {
	#name : #SBStateMachinePalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachinePalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Statemachine';
		
		addBlock: 'State' as: (SBStateMachineState new name: 'unnamed state')
]

{ #category : #'as yet unclassified' }
SBStateMachinePalette class >> context [

	^ #(isSmalltalk)
]

{ #category : #'as yet unclassified' }
SBStateMachinePalette class >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStateMachinePalette class >> matchesBlock: aBlock [

	SBExample
		self: [SBStateMachinePalette]
		args: [{(SBStateMachineEditor >> #exampleStateMachine) asSandblock statements last expression}]
		label: 'toplevel'
		assert: [true].
	SBExample
		self: [SBStateMachinePalette]
		args: [
			{
				(SBStateMachineEditor >> #exampleStateMachine) asSandblock statements last expression firstSubmorph
			}]
		label: 'nested'
		assert: [true].
	(aBlock isKindOf: SBStateMachineEditor) ifTrue: [^ true].
	^ (aBlock ownerSatisfying: [:owner | owner isKindOf: SBStateMachineEditor]) notNil
]

{ #category : #'as yet unclassified' }
SBStateMachinePalette class >> title [

	^ 'Statemachine'
]
