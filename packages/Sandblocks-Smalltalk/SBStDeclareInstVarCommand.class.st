Class {
	#name : #SBStDeclareInstVarCommand,
	#superclass : #SBCommand,
	#instVars : [
		'class',
		'name',
		'editor',
		'newBindings',
		'source'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclareInstVarCommand >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBStDeclareInstVarCommand >> do [

	class addInstVarName: name.
	newBindings := (source sandblockEditor allBlocksFor: class withInterfaces: SBInterfaces editor) collect: [:class | | binding |
		binding := SBStName contents: name.
		class instanceVariables submorphs
			detect: [:m | m contents = name]
			ifNone: [class instanceVariables addMorphBack: binding].
		binding].
	^ source
]

{ #category : #'as yet unclassified' }
SBStDeclareInstVarCommand >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBStDeclareInstVarCommand >> source: aBlock [

	source := aBlock
]

{ #category : #'as yet unclassified' }
SBStDeclareInstVarCommand >> undo [

	class removeInstVarName: name.
	newBindings do: #delete.
	^ source
]
