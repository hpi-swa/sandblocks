Class {
	#name : #SBDeclareInstanceVariableCommand,
	#superclass : #SBCommand,
	#instVars : [
		'name',
		'class',
		'select'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclareInstanceVariableCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBDeclareInstanceVariableCommand >> do [

	class addInstVarName: name.
	^ select
]

{ #category : #'as yet unclassified' }
SBDeclareInstanceVariableCommand >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBDeclareInstanceVariableCommand >> select: aBlock [

	select := aBlock
]

{ #category : #'as yet unclassified' }
SBDeclareInstanceVariableCommand >> undo [

	class removeInstVarName: name.
	^ select
]
