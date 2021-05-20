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

	methodCommands := (class organization listAtCategoryNamed: category) collect: [:selector | SBStDeleteMethodCommand new target: class >> selector].
	methodCommands do: #do.
	class organization removeCategory: category
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> setArtefactFrom [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStDeleteMethodCategoryCommand >> undo [

	methodCommands do: #undo
]
