Class {
	#name : #SBStCreateClassCommand,
	#superclass : #SBCommand,
	#instVars : [
		'name',
		'editor',
		'source',
		'class'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #apply }
SBStCreateClassCommand >> do [

	class := SBStClass new
		className: name;
		category: ((self artefact ifNotNil: [:container | container relatedClass])
			ifNotNil: #category
			ifNil: ['UserObjects']).
	editor createArtefactInView: class.
	^ source
]

{ #category : #accessing }
SBStCreateClassCommand >> editor: anEditor [

	editor := anEditor
]

{ #category : #accessing }
SBStCreateClassCommand >> name: aString [

	name := aString
]

{ #category : #accessing }
SBStCreateClassCommand >> setArtefactFrom [

	^ nil
]

{ #category : #accessing }
SBStCreateClassCommand >> source: aBlock [

	source := aBlock
]

{ #category : #apply }
SBStCreateClassCommand >> undo [

	class deleteClass.
	^ source
]
