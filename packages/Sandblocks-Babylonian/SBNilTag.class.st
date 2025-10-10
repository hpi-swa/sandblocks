Class {
	#name : #SBNilTag,
	#superclass : #SBTag,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #accessing }
SBNilTag >> isNilTag [ 

	^ true 
]

{ #category : #filtering }
SBNilTag >> satisfiesExampleLabel: aString [

	^ false
]

{ #category : #filtering }
SBNilTag >> satisfiesTag: anotherTag [

	^ false
]

{ #category : #filtering }
SBNilTag >> satisfiesVariantId: aString [

	^ false
]

{ #category : #filtering }
SBNilTag >> satisfiesWatchId: aString [

	^ false
]
