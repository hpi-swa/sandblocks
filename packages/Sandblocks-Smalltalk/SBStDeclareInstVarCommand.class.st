Class {
	#name : #SBStDeclareInstVarCommand,
	#superclass : #SBStDeclareBehaviorVarCommand,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #apply }
SBStDeclareInstVarCommand >> basicDo [

	^ class addInstVarName: name
]

{ #category : #apply }
SBStDeclareInstVarCommand >> basicUndo [

	class removeInstVarName: name
]

{ #category : #private }
SBStDeclareInstVarCommand >> variablesInClass: anStClass [

	^ anStClass instanceVariables
]
