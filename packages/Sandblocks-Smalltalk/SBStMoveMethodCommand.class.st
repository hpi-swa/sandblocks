Class {
	#name : #SBStMoveMethodCommand,
	#superclass : #SBCommand,
	#instVars : [
		'fromClass',
		'toClass',
		'method'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMoveMethodCommand >> do [

	fromClass := method methodClass.
	method selector: method selector arguments: method arguments class: toClass.
	method currentClass: toClass.
	
	^ method clearCache
]

{ #category : #'as yet unclassified' }
SBStMoveMethodCommand >> method: aMethod [

	method := aMethod
]

{ #category : #'as yet unclassified' }
SBStMoveMethodCommand >> setArtefactFrom [

	^ method
]

{ #category : #'as yet unclassified' }
SBStMoveMethodCommand >> toClass: aClass [

	toClass := aClass
]

{ #category : #'as yet unclassified' }
SBStMoveMethodCommand >> undo [

	method selector: method selector arguments: method arguments class: fromClass.
	method currentClass: fromClass.
	
	^ method clearCache
]
