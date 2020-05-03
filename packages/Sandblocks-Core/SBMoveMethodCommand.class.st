Class {
	#name : #SBMoveMethodCommand,
	#superclass : #SBCommand,
	#instVars : [
		'fromClass',
		'toClass',
		'method'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMoveMethodCommand >> do [

	fromClass := method methodClass.
	method selector: method selector arguments: method arguments class: toClass.
	
	^ method clearCache
]

{ #category : #'as yet unclassified' }
SBMoveMethodCommand >> method: aMethod [

	method := aMethod
]

{ #category : #'as yet unclassified' }
SBMoveMethodCommand >> toClass: aClass [

	toClass := aClass
]

{ #category : #'as yet unclassified' }
SBMoveMethodCommand >> undo [

	method selector: method selector arguments: method arguments class: fromClass.
	
	^ method clearCache
]
