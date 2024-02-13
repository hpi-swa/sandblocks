Class {
	#name : #SBWatchValue,
	#superclass : #Object,
	#instVars : [
		'watchedValue',
		'watchedValueIdentityHash',
		'morphResizer',
		'tracePosition',
		'occuringWatchId'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #utility }
SBWatchValue class >> newContainerMorphFor: aWatchValue [

	^ SBWatchValueBlock new
		watchValue: aWatchValue;
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		yourself
]

{ #category : #'instance creation' }
SBWatchValue class >> value: aValue identityHash: tracedValueIdentityHash [
	
	^ self 
		value: aValue 
		identityHash: tracedValueIdentityHash 
		sized: SBMorphResizer newIdentity
]

{ #category : #'instance creation' }
SBWatchValue class >> value: aValue identityHash: tracedValueIdentityHash sized: aSBMorphResizer [
	
	^ self new
		watchedValue: aValue;
		watchedValueIdentityHash: tracedValueIdentityHash;
		morphResizer: aSBMorphResizer;
		yourself 
]

{ #category : #accessing }
SBWatchValue >> asValueMorph [

	^ self watchedValue sbWatchValueMorphFor: self sized: self morphResizer
]

{ #category : #accessing }
SBWatchValue >> explore [

	self watchedValue explore
]

{ #category : #accessing }
SBWatchValue >> expressionString [

	^ self occuringWatch expression sourceString
]

{ #category : #'initialize-release' }
SBWatchValue >> initialize [ 

	super initialize.
	
	watchedValue := 0.
	watchedValueIdentityHash := 0 identityHash.
	morphResizer := SBMorphResizer newIdentity.
	tracePosition := 0.
]

{ #category : #accessing }
SBWatchValue >> morphResizer [

	^ morphResizer
]

{ #category : #accessing }
SBWatchValue >> morphResizer: aSBMorphResizer [

	morphResizer := aSBMorphResizer.
	
]

{ #category : #accessing }
SBWatchValue >> occuringWatch [

	^ SBExampleWatch registry detect: [:aWatch | 
		aWatch notNil and: [aWatch identifier = occuringWatchId]]
]

{ #category : #accessing }
SBWatchValue >> occuringWatchId: aNumber [

	occuringWatchId := aNumber
]

{ #category : #printing }
SBWatchValue >> printOn: aStream [
	
	super printOn: aStream. 
	aStream space.
	self watchedValue printOn: aStream.
]

{ #category : #accessing }
SBWatchValue >> tracePosition [

	^ tracePosition
]

{ #category : #accessing }
SBWatchValue >> tracePosition: aNumber [

	tracePosition := aNumber
]

{ #category : #accessing }
SBWatchValue >> watchedValue [

	^ watchedValue
]

{ #category : #accessing }
SBWatchValue >> watchedValue: anObject [

	watchedValue := anObject
]

{ #category : #accessing }
SBWatchValue >> watchedValueIdentityHash [

	^ watchedValueIdentityHash
]

{ #category : #accessing }
SBWatchValue >> watchedValueIdentityHash: anObject [

	watchedValueIdentityHash := anObject
]
