Class {
	#name : #SBChangeMethodCategoryCommand,
	#superclass : #SBCommand,
	#instVars : [
		'class',
		'selector',
		'category',
		'previousCategory',
		'previousClass'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBChangeMethodCategoryCommand >> category: aString [

	category := aString
]

{ #category : #'as yet unclassified' }
SBChangeMethodCategoryCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBChangeMethodCategoryCommand >> do [

	previousClass ~= class ifTrue: [
		class compile: (class >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	class organization classify: selector under: category logged: true
]

{ #category : #'as yet unclassified' }
SBChangeMethodCategoryCommand >> method: aMethod [

	selector := aMethod selector.
	previousClass := aMethod methodClass.
	previousCategory := previousClass organization categoryOfElement: selector
]

{ #category : #'as yet unclassified' }
SBChangeMethodCategoryCommand >> undo [

	previousClass ~= class ifTrue: [
		previousClass compile: (previousClass >> selector) getSourceFromFile.
		previousClass removeSelector: selector].
	
	previousClass organization classify: selector under: previousCategory logged: true
]
