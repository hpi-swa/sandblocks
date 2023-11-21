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
	
	^ 'Current setting without any variants'
]
