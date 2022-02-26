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
SBCursorNone >> color [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBCursorNone >> drawOn: aCanvas in: aRectangle color: aColor [

	
]

{ #category : #'as yet unclassified' }
SBCursorNone >> hash [

	^ self scaledIdentityHash
]

{ #category : #'as yet unclassified' }
SBCursorNone >> horizontalOffsetInFloat [

	^ 0
]

{ #category : #'as yet unclassified' }
SBCursorNone >> minimalBounds [

	^ self bounds
]

{ #category : #'as yet unclassified' }
SBCursorNone >> mode [

	^ #none
]

{ #category : #'as yet unclassified' }
SBCursorNone >> moveHorizontal: anInteger wordWise: aBoolean [

	^ nil
]

{ #category : #'as yet unclassified' }
SBCursorNone >> selectLarger [
]

{ #category : #'as yet unclassified' }
SBCursorNone >> selectSmaller [
]

{ #category : #'as yet unclassified' }
SBCursorNone >> valid [

	^ true
]
