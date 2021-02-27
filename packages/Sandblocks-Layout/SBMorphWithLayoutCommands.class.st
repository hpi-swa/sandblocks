Class {
	#name : #SBMorphWithLayoutCommands,
	#superclass : #Morph,
	#instVars : [
		'layoutCommands'
	],
	#category : #'Sandblocks-Layout-Tests'
}

{ #category : #'as yet unclassified' }
SBMorphWithLayoutCommands >> layoutCommands [

	^ layoutCommands
]

{ #category : #'as yet unclassified' }
SBMorphWithLayoutCommands >> layoutCommands: aCommand [

	layoutCommands := aCommand
]
