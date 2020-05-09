Class {
	#name : #SBAssignment,
	#superclass : #SBASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAssignment >> binding: aBlock value: anotherBlock [

	self removeAllMorphs.
	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: ':=').
	self addMorphBack: anotherBlock
]

{ #category : #converting }
SBAssignment >> childSandblocksDo: aBlock [

	self hasSubmorphs ifTrue: [
		aBlock value: self firstSubmorph.
		aBlock value: self lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBAssignment >> initialize [

	super initialize.
	
	pc := 0.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight
]

{ #category : #'as yet unclassified' }
SBAssignment >> isAssignment [

	^ true
]

{ #category : #converting }
SBAssignment >> isExpression [

	^ true
]

{ #category : #converting }
SBAssignment >> pc [

	^ pc
]

{ #category : #converting }
SBAssignment >> pc: aNumber [

	pc := aNumber
]

{ #category : #converting }
SBAssignment >> printOn: aStream [

	aStream nextPutAll: 'assignment to '.
	aStream nextPutAll: self firstSubmorph contents
]

{ #category : #converting }
SBAssignment >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self submorphs first writeSourceOn: aStream.
	aStream nextPutAll: ' := '.
	self submorphs third writeSourceOn: aStream.
	aStream nextPut: $)
]
