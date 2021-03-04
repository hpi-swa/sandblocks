Class {
	#name : #SBHistoryStack,
	#superclass : #Object,
	#instVars : [
		'undoStack',
		'redoStack',
		'changedArtefacts'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #actions }
SBHistoryStack >> clearUndoStack [

	undoStack := OrderedCollection new.
	redoStack := OrderedCollection new.
	changedArtefacts := Set new
]

{ #category : #actions }
SBHistoryStack >> do: aCommand previousSelection: aMorph selectDo: aBlock [

	(undoStack notEmpty and: [undoStack last shouldMergeWithNext])
		ifTrue: [undoStack addLast: (SBCombinedCommand newWith: {undoStack removeLast. aCommand})]
		ifFalse: [undoStack addLast: aCommand].
	
	redoStack removeAll.
	
	changedArtefacts addAll: aCommand affectedArtefacts.
	
	aCommand previousSelection: aMorph.
	aBlock value: aCommand do value: aCommand affectedArtefacts.
	aCommand postDo
]

{ #category : #actions }
SBHistoryStack >> hasUnsavedChanges: anArtefact [

	^ changedArtefacts includes: anArtefact
]

{ #category : #actions }
SBHistoryStack >> initialize [

	self clearUndoStack
]

{ #category : #actions }
SBHistoryStack >> markSaved: anArtefact [

	changedArtefacts remove: anArtefact ifAbsent: [].
	anArtefact changed
]

{ #category : #actions }
SBHistoryStack >> noMoreMerge [

	undoStack ifNotEmpty: [undoStack last shouldMergeWithNext: false]
]

{ #category : #actions }
SBHistoryStack >> redoDo: aBlock [

	redoStack ifNotEmpty: [ | command |
		command := redoStack removeLast.
		undoStack addLast: command.
		aBlock value: command do value: command affectedArtefacts]
]

{ #category : #actions }
SBHistoryStack >> undoDo: aBlock [

	undoStack ifNotEmpty: [ | ret command |
		command := undoStack removeLast.
		redoStack addLast: command.
		ret := command undo.
		aBlock
			value: ((command previousSelection notNil and: [command previousSelection isInWorld]) ifTrue: [command previousSelection] ifFalse: [ret])
			value: command affectedArtefacts]
]
