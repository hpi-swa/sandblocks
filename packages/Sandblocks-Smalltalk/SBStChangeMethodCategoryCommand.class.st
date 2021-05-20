Class {
	#name : #SBStChangeMethodCategoryCommand,
	#superclass : #SBCommand,
	#instVars : [
		'class',
		'selector',
		'category',
		'previousCategory',
		'previousClass'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> category: aString [

	category := aString
]

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> do [

	previousClass ~= class ifTrue: [
		class compile: (class >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	class organization classify: selector under: category logged: true
]

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> method: aMethod [

	selector := aMethod selector.
	previousClass := aMethod methodClass.
	previousCategory := previousClass organization categoryOfElement: selector
]

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> setArtefactFrom [

	^ category
]

{ #category : #'as yet unclassified' }
SBStChangeMethodCategoryCommand >> undo [

	previousClass ~= class ifTrue: [
		previousClass compile: (previousClass >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	
	previousClass organization classify: selector under: previousCategory logged: true
]
