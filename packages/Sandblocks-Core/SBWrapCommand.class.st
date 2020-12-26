Class {
	#name : #SBWrapCommand,
	#superclass : #SBCommand,
	#instVars : [
		'outer',
		'inner',
		'wrap'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #accessing }
SBWrapCommand >> do [

	| currentOwner index |
	currentOwner := inner owner.
	index := currentOwner submorphIndexOf: inner.
	inner delete.
	wrap value: outer value: inner.
	
	currentOwner addMorph: outer asElementNumber: index.
	outer position: inner position.
		
	^ inner
]

{ #category : #accessing }
SBWrapCommand >> inner [

	^ inner
]

{ #category : #accessing }
SBWrapCommand >> inner: anObject [

	inner := anObject
]

{ #category : #accessing }
SBWrapCommand >> outer [

	^ outer
]

{ #category : #accessing }
SBWrapCommand >> outer: anObject [

	outer := anObject
]

{ #category : #accessing }
SBWrapCommand >> undo [

	outer replaceBy: inner.
	^ inner
]

{ #category : #accessing }
SBWrapCommand >> wrap [

	^ wrap
]

{ #category : #accessing }
SBWrapCommand >> wrap: anObject [

	wrap := anObject
]
