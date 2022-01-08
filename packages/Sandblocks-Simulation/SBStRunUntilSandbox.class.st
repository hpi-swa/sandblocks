Class {
	#name : #SBStRunUntilSandbox,
	#superclass : #Sandbox2,
	#instVars : [
		'selector',
		'receiverClass',
		'pc'
	],
	#category : #'Sandblocks-Simulation'
}

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> context: aContext step: aBlock [

	(aContext selector = selector and: [aContext receiver class = receiverClass and: [aContext previousPc = pc]]) ifTrue: [
		^ SBStRunUntilValue new
			value: (aContext at: aContext stackPtr);
			signal].
	^ super context: aContext step: aBlock
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> receiverClass [

	^ receiverClass
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> receiverClass: aClass [

	receiverClass := aClass
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> selector [

	^ selector
]

{ #category : #'as yet unclassified' }
SBStRunUntilSandbox >> selector: aSymbol [

	selector := aSymbol
]
