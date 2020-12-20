Class {
	#name : #SBDeleteMethodCategoryCommand,
	#superclass : #SBCommand,
	#instVars : [
		'category',
		'class',
		'methodCommands'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeleteMethodCategoryCommand >> category: aString [

	category := aString
]

{ #category : #'as yet unclassified' }
SBDeleteMethodCategoryCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBDeleteMethodCategoryCommand >> do [

	methodCommands := (class organization listAtCategoryNamed: category) collect: [:selector |
		(SBDeleteMethodCommand newFor: artefact) target: class >> selector].
	methodCommands do: #do.
	class organization removeCategory: category
]

{ #category : #'as yet unclassified' }
SBDeleteMethodCategoryCommand >> undo [

	methodCommands do: #undo
]
