"
Attach a SBTag to a Morph to enable filtering for a specific tag value, e.g. in the SBHistoryView. See #snapshotSatisfying: for usages 
"
Class {
	#name : #SBTag,
	#superclass : #Object,
	#instVars : [
		'exampleLabel',
		'watchId',
		'permutationName'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBTag class >> newFromExample: aSBExample [

	^ self new addFromExample: aSBExample
]

{ #category : #'initialize-release' }
SBTag class >> newFromPermutation: aSBPermutation [

	^ self new addFromPermutation: aSBPermutation
]

{ #category : #'initialize-release' }
SBTag class >> newFromWatch: aSBExampleWatch [

	^ self new addFromWatch: aSBExampleWatch
]

{ #category : #accessing }
SBTag >> addFromExample: aSBExample [

	self exampleLabel: aSBExample label 
]

{ #category : #accessing }
SBTag >> addFromPermutation: aSBPermutation [

	self permutationName: aSBPermutation asString 
]

{ #category : #accessing }
SBTag >> addFromWatch: aSBExampleWatch [
	
	aSBExampleWatch isActive
		ifTrue: [self watchId: aSBExampleWatch identifier asString] 
		ifFalse: [self watchId: aSBExampleWatch originalIdentifier asString]
	
]

{ #category : #accessing }
SBTag >> exampleLabel [

	^ exampleLabel
]

{ #category : #accessing }
SBTag >> exampleLabel: aString [

	exampleLabel := aString
]

{ #category : #accessing }
SBTag >> isNilTag [

	^ false
]

{ #category : #accessing }
SBTag >> permutationName [

	^ permutationName
]

{ #category : #accessing }
SBTag >> permutationName: aString [

	permutationName := aString
]

{ #category : #filtering }
SBTag >> satisfiesExampleLabel: aString [

	^ aString isNil 
		or: [self exampleLabel isNil] 
		or: [self exampleLabel includesSubstring: aString]
]

{ #category : #filtering }
SBTag >> satisfiesTag: anotherTag [

	^ (self satisfiesExampleLabel: anotherTag exampleLabel)
		and: [self satisfiesWatchId: anotherTag watchId]
		and: [self satisfiesVariantId: anotherTag permutationName]
]

{ #category : #filtering }
SBTag >> satisfiesVariantId: aString [

	^ aString isNil 
		or: [self permutationName isNil] 
		or: [self permutationName includesSubstring: aString]
]

{ #category : #filtering }
SBTag >> satisfiesWatchId: aString [

	^ aString isNil 
		or: [self watchId isNil] 
		or: [self watchId includesSubstring: aString]
]

{ #category : #accessing }
SBTag >> watchId [

	^ watchId
]

{ #category : #accessing }
SBTag >> watchId: anObject [

	watchId := anObject isString 
		ifTrue: [ anObject ] 
		ifFalse: [ anObject asString ]
]
