Class {
	#name : #SBNilPermutation,
	#superclass : #SBPermutation,
	#type : #variable,
	#category : #'Sandblocks-Utils'
}

{ #category : #actions }
SBNilPermutation >> apply [
	
	"Do nothing"
]

{ #category : #converting }
SBNilPermutation >> asString [
	
	^ 'No Variation'
]

{ #category : #accessing }
SBNilPermutation >> isActive [

	^ false
]

{ #category : #accessing }
SBNilPermutation >> isNilPermutation [

	^ true
]
