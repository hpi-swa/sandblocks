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

	inner replaceBy: outer.
	wrap value: outer value: inner.
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
