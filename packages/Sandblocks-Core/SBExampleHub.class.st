Class {
	#name : #SBExampleHub,
	#superclass : #Object,
	#instVars : [
		'activeExamples',
		'editor'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBExampleHub >> activeExamples [

	(Array streamContents: [:stream | activeExamples do: [:example | example isInWorld ifFalse: [stream nextPut: example]]]) do: [:deactivatedExample | activeExamples remove: deactivatedExample ifAbsent: []].
	
	^ activeExamples
]

{ #category : #'as yet unclassified' }
SBExampleHub >> editor: anEditor [

	editor := anEditor
]

{ #category : #'as yet unclassified' }
SBExampleHub >> initialize [

	super initialize.
	
	activeExamples := WeakSet new
]

{ #category : #'as yet unclassified' }
SBExampleHub >> registerWatch: aWatch [

	self activeExamples do: [:example | aWatch exampleStarting: example]
]

{ #category : #'as yet unclassified' }
SBExampleHub >> started: anExample [

	activeExamples add: anExample.
	
	editor allBlocksDo: [:morph | morph listensToExamples ifTrue: [morph exampleStarting: anExample]]
]

{ #category : #'as yet unclassified' }
SBExampleHub >> stopped: anExample [

	activeExamples remove: anExample ifAbsent: [].
	
	editor allBlocksDo: [:morph | morph listensToExamples ifTrue: [morph exampleStopped: anExample]]
]
