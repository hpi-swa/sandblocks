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

	| nextSelection |
	" make sure our history stack never gets accidentally broken "
	self assert: (aCommand isKindOf: SBCommand).
	
	(undoStack notEmpty and: [undoStack last shouldMergeWithNext])
		ifTrue: [undoStack addLast: (SBCombinedCommand newWith: {undoStack removeLast. aCommand})]
		ifFalse: [undoStack addLast: aCommand].
	
	redoStack removeAll.
	aCommand previousSelection: aMorph.
	
	aCommand preDo.
	self markChanged: aCommand affectedArtefacts.
	
	nextSelection := aCommand do.
	aCommand selectAfter ifNotNil: [:b | nextSelection := b = #none ifTrue: [nil] ifFalse: [b]].
	aBlock value: nextSelection value: aCommand affectedArtefacts.
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
SBHistoryStack >> markChanged: aCollection [

	changedArtefacts addAll: aCollection.
	aCollection do: [:artefact | artefact changed]
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
