Class {
	#name : #SBStDeclareBehaviorVarCommand,
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

{ #category : #apply }
SBStDeclareBehaviorVarCommand >> basicDo [

	^ self subclassResponsibility
]

{ #category : #apply }
SBStDeclareBehaviorVarCommand >> basicUndo [

	^ self subclassResponsibility
]

{ #category : #accessing }
SBStDeclareBehaviorVarCommand >> class: aClass [

	class := aClass
]

{ #category : #apply }
SBStDeclareBehaviorVarCommand >> do [

	self basicDo.
	newBindings := (source sandblockEditor
		allBlocksFor: class
		withInterfaces: SBInterfaces editor) collect: [:stClass | | binding variables |
		binding := SBStName contents: name.
		variables := self variablesInClass: stClass.
		variables submorphs
			detect: [:m | m contents = name]
			ifNone: [variables addMorphBack: binding].
		binding].
	^ source
]

{ #category : #accessing }
SBStDeclareBehaviorVarCommand >> name: aString [

	name := aString
]

{ #category : #accessing }
SBStDeclareBehaviorVarCommand >> setArtefactFrom [

	^ nil
]

{ #category : #accessing }
SBStDeclareBehaviorVarCommand >> source: aBlock [

	source := aBlock
]

{ #category : #apply }
SBStDeclareBehaviorVarCommand >> undo [

	self basicUndo.
	newBindings do: #delete.
	^ source
]

{ #category : #private }
SBStDeclareBehaviorVarCommand >> variablesInClass: anStClass [

	^ self subclassResponsibility
]
