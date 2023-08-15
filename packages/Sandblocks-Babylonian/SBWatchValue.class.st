Class {
	#name : #SBWatchValue,
	#superclass : #Object,
	#instVars : [
		'watchedValue',
		'watchedValueIdentityHash'
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
	
	^ self new
		watchedValue: aValue;
		watchedValueIdentityHash: tracedValueIdentityHash;
		yourself 
]

{ #category : #accessing }
SBWatchValue >> asValueMorph [

	^ self watchedValue sbWatchValueMorphFor: self
]

{ #category : #accessing }
SBWatchValue >> explore [

	self watchedValue explore
]

{ #category : #'initialize-release' }
SBWatchValue >> initialize [ 

	super initialize.
	
	watchedValue := 0.
	watchedValueIdentityHash := 0 identityHash.
]

{ #category : #printing }
SBWatchValue >> printOn: aSteam [
	
	super printOn: aSteam. 
	aSteam space.
	self watchedValue printOn: aSteam.
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
