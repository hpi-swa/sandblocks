Class {
	#name : #SBRestoreCommand,
	#superclass : #SBCommand,
	#instVars : [
		'morphs',
		'restore',
		'commonOwner'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRestoreCommand >> do [

	^ self notePositions
]

{ #category : #'as yet unclassified' }
SBRestoreCommand >> morphs: aCollection commonOwner: aMorph [

	morphs := aCollection.
	commonOwner := aMorph
]

{ #category : #'as yet unclassified' }
SBRestoreCommand >> notePositions [

	| set order |
	restore ifNotNil: [^ morphs ifNotEmpty: #first ifEmpty: [nil]].
	
	set := morphs asSet.
	order := Array streamContents: [:stream | commonOwner allMorphsDo: [:morph | (set remove: morph ifAbsent: [nil]) ifNotNil: [stream nextPut: morph]]].
	restore := order collect: [:morph | {morph. morph owner. morph submorphIndex}].
	^ morphs ifNotEmpty: #first ifEmpty: [nil]
]

{ #category : #'as yet unclassified' }
SBRestoreCommand >> setArtefactFrom [

	^ morphs ifNotEmpty: #first ifEmpty: [nil]
]

{ #category : #'as yet unclassified' }
SBRestoreCommand >> undo [

	restore do: [:pair | pair second addMorph: pair first asElementNumber: pair third].
	commonOwner allMorphsDo: [:m | m valueOfProperty: #tsReplacementPlaceholder ifPresentDo: [:original | m delete]].
	^ morphs ifNotEmpty: #first ifEmpty: [nil]
]
