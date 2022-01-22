Class {
	#name : #SBStDeclarationBehavior,
	#superclass : #SBStNameBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior class >> checkCastFor: aBlock parent: aMorph [

	^ false
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> allUsages [

	^ Array streamContents: [:stream |
		self allUsagesDo: [:u | stream nextPut: u]]
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> allUsagesDo: aBlock [

	^ self scope do: [:scope |
		scope ifNotNil: [
			scope allBlocksDo: [:block |
				(block isBinding and: [block ~= self block and: [block behavior resolveBinding = self block]]) ifTrue: [aBlock value: block]]]]
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> browseReferences [

	
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> browseSenders [
	<action>

	self browseReferences
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> guessedClass [

	^ (self block containingArtefact ifNotNil: [:a | a typeFor: self block]) ifNil: [super guessedClass]
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> hasUsages [

	self allUsagesDo: [:u | ^ true].
	^ false
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> isDeclaration [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> isMethodLocal [

	^ false
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> resolveBinding [

	^ self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> scope [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> suggestions [

	^ #()
]

{ #category : #'as yet unclassified' }
SBStDeclarationBehavior >> valid [

	^ self isReserved not
]
