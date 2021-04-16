Class {
	#name : #SBInputStructureCommand,
	#superclass : #SBInputCommand,
	#instVars : [
		'oldMorphs',
		'newMorphs',
		'oldOwners',
		'oldIndices',
		'newOwners',
		'newIndices'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInputStructureCommand >> do [

	super do.
	
	newMorphs
		with: newOwners
		and: newIndices
		do: [:morph :owner :index | morph owner ~= owner ifTrue: [owner addMorph: morph asElementNumber: index]].
	
	(oldMorphs difference: newMorphs) do: #delete.
	
	^ newMorph
]

{ #category : #'as yet unclassified' }
SBInputStructureCommand >> hasChange [

	^ super hasChange or: [newMorphs ~= oldMorphs]
]

{ #category : #'as yet unclassified' }
SBInputStructureCommand >> newMorphs: aCollection [

	newMorphs := aCollection.
	newOwners := newMorphs collect: #owner.
	newIndices := newMorphs collect: [:morph | morph submorphIndex]
]

{ #category : #'as yet unclassified' }
SBInputStructureCommand >> oldMorphs: aCollection [

	oldMorphs := aCollection.
	oldOwners := oldMorphs collect: #owner.
	oldIndices := oldMorphs collect: [:morph | morph submorphIndex]
]

{ #category : #'as yet unclassified' }
SBInputStructureCommand >> undo [

	super undo.
	
	oldMorphs
		with: oldOwners
		and: oldIndices
		do: [:morph :owner :index | owner addMorph: morph asElementNumber: index].
	
	(newMorphs difference: oldMorphs) do: #delete.
	
	^ oldMorph
]
