Class {
	#name : #SBStDeclareClassVarCommand,
	#superclass : #SBStDeclareBehaviorVarCommand,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #apply }
SBStDeclareClassVarCommand >> basicDo [

	^ class addClassVarName: name
]

{ #category : #apply }
SBStDeclareClassVarCommand >> basicUndo [

	class removeClassVarName: name
]

{ #category : #private }
SBStDeclareClassVarCommand >> variablesInClass: anStClass [

	^ anStClass classVariables
]
