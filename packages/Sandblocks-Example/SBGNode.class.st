Class {
	#name : #SBGNode,
	#superclass : #Morph,
	#instVars : [
		'sockets',
		'outputs',
		'inputs',
		'outputsAE',
		'inputsAE'
	],
	#category : 'Sandblocks-Example'
}

{ #category : #'as yet unclassified' }
SBGNode >> addInput: aSocket [ 
	SBWatch
		report: (inputs addMorphBack: aSocket)
		for: 832650923.
	inputsAE update
]

{ #category : #'as yet unclassified' }
SBGNode >> addOutput: aSocket [ 
	outputs addMorphBack: aSocket.
	outputsAE update
]

{ #category : #'as yet unclassified' }
SBGNode >> graphExample [
	SBMorphExample
		setUp: [SBGNode new]
		cases: {SBMorphExampleCase
				name: 'test'
				caseBlock: [:m | m]}
		extent: 212 @ 170
]

{ #category : #'as yet unclassified' }
SBGNode >> initialize [
	super initialize.
	self color: Color white.
	self addMorphBack: (outputs := SBColumn new).
	outputsAE := ManualActiveExpression
				on: [outputs].
	self addMorphBack: (inputs := SBColumn new).
	inputsAE := ManualActiveExpression
				on: [inputs]
]
