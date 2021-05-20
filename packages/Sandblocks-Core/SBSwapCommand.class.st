Class {
	#name : #SBSwapCommand,
	#superclass : #SBCommand,
	#instVars : [
		'a',
		'b'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSwapCommand >> a: aMorph [

	a := aMorph
]

{ #category : #'as yet unclassified' }
SBSwapCommand >> b: aMorph [

	b := aMorph
]

{ #category : #'as yet unclassified' }
SBSwapCommand >> do [

	| aIndex aOwner bIndex bOwner |
	aOwner := a owner.
	aIndex := aOwner submorphIndexOf: a.
	
	bOwner := b owner.
	bIndex := bOwner submorphIndexOf: b.
	
	"aOwner removeMorph: a.
	bOwner removeMorph: b."
	aOwner addMorph: b asElementNumber: aIndex.
	bOwner addMorph: a asElementNumber: bIndex.
	^ a
]

{ #category : #'as yet unclassified' }
SBSwapCommand >> setArtefactFrom [

	^ a
]

{ #category : #'as yet unclassified' }
SBSwapCommand >> undo [

	^ self do
]
