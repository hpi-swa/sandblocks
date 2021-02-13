Class {
	#name : #SBRecordedCommand,
	#superclass : #SBCommand,
	#instVars : [
		'undo',
		'doBlock',
		'firstRemoved',
		'firstAdded'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #action }
SBRecordedCommand >> add: aMorph in: anOwnerMorph at: aNumber [

	undo add: [aMorph delete].
	anOwnerMorph addMorph: aMorph asElementNumber: aNumber.
	self added: aMorph
]

{ #category : #action }
SBRecordedCommand >> addAll: aCollection after: aMorph [

	self addAll: aCollection in: aMorph owner at: aMorph submorphIndex + 1
]

{ #category : #action }
SBRecordedCommand >> addAll: aCollection in: anOwnerMorph at: aNumber [

	undo add: [aCollection do: [:m | m delete]].
	aCollection withIndexDo: [:m :index |
		anOwnerMorph addMorph: m asElementNumber: aNumber + index.
		self added: m]
]

{ #category : #action }
SBRecordedCommand >> added: aMorph [

	aMorph postDuplicate.
	firstAdded ifNil: [firstAdded := aMorph]
]

{ #category : #apply }
SBRecordedCommand >> do [

	undo := OrderedCollection new.
	firstAdded := nil.
	firstRemoved := nil.
	doBlock value: self.
	^ firstAdded
]

{ #category : #action }
SBRecordedCommand >> moveAll: aCollection after: aMorph [

	self moveAll: aCollection in: aMorph owner at: aMorph submorphIndex + 1
]

{ #category : #action }
SBRecordedCommand >> moveAll: aCollection in: anOwnerMorph at: aNumber [

	| previousIndices previousOwners |
	previousOwners := aCollection collect: #owner.
	previousIndices := aCollection collect: #submorphIndex.
	undo add: [aCollection with: previousOwners and: previousIndices do: [:m :owner :index | owner addMorph: m asElementNumber: index]].
	
	aCollection withIndexDo: [:m :index |
		anOwnerMorph addMorph: m asElementNumber: aNumber + index.
		self added: m]
]

{ #category : #record }
SBRecordedCommand >> record: aBlock [

	doBlock := aBlock
]

{ #category : #action }
SBRecordedCommand >> remove: aMorph [

	| index owner |
	owner := aMorph owner.
	index := aMorph submorphIndex.
	undo add: [owner addMorph: aMorph asElementNumber: index].
	
	aMorph delete.
	self removed: aMorph
]

{ #category : #action }
SBRecordedCommand >> removed: aMorph [

	firstRemoved ifNil: [firstRemoved := aMorph]
]

{ #category : #action }
SBRecordedCommand >> replace: aMorph with: anotherMorph [

	undo add: [anotherMorph replaceBy: aMorph].
	aMorph replaceBy: anotherMorph.
	self added: anotherMorph
]

{ #category : #action }
SBRecordedCommand >> restore: aMorph [
	" remember this Morph's position in the tree and restore it when undone "
	
	| oldIndex oldOwner |
	oldOwner := aMorph owner.
	oldIndex := oldOwner submorphIndexOf: aMorph.
	undo add: [oldOwner addMorph: aMorph asElementNumber: oldIndex]
]

{ #category : #action }
SBRecordedCommand >> restore: aCollection after: aBlock [
	" remember these Morphs' positions in the tree and restore them when undone "
	
	| oldIndices oldOwners |
	oldOwners := aCollection collect: #owner.
	oldIndices := aCollection with: oldOwners collect: [:morph :owner | owner submorphIndexOf: morph].
	aBlock value.
	undo add: [
		oldOwners with: aCollection and: oldIndices do: [:owner :morph :index |
			owner addMorph: morph asElementNumber: index]]
]

{ #category : #apply }
SBRecordedCommand >> undo [

	undo reverseDo: #value.
	^ firstRemoved
]