Class {
	#name : #SBStDeleteMethodCategoryCommand,
	#superclass : #SBCommand,
	#instVars : [
		'category',
		'class',
		'methodCommands'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> category: aString [

	category := aString
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> do [

	methodCommands := (class organization listAtCategoryNamed: category) collect: [:selector |
		(SBStDeleteMethodCommand newFor: artefact) target: class >> selector].
	methodCommands do: #do.
	class organization removeCategory: category
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> undo [

	methodCommands do: #undo
]
