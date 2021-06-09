Class {
	#name : #SBCursorNone,
	#superclass : #SBCursorPosition,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorNone >> = aCursor [

	^ aCursor class = self class
]

{ #category : #'as yet unclassified' }
SBCursorNone >> block [

	^ nil
]

{ #category : #'as yet unclassified' }
SBCursorNone >> bounds [

	^ 0 @ 0 extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBCursorNone >> drawOn: aCanvas [

	
]

{ #category : #'as yet unclassified' }
SBCursorNone >> hash [

	^ self scaledIdentityHash
]
