Class {
	#name : #SBStClassNameFreeInput,
	#superclass : #SBTextBubble,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClassNameFreeInput >> class: aClass [

	self contents: aClass name
]

{ #category : #'as yet unclassified' }
SBStClassNameFreeInput >> object [

	^ Smalltalk at: self contents asSymbol ifAbsent: [nil]
]
