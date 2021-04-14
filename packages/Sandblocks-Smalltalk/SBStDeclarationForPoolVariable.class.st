Class {
	#name : #SBStDeclarationForPoolVariable,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> browse [
	<action>

	(self block binding value isKindOf: Behavior) ifTrue: [self systemNavigation browseClass: self block binding value]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> browseReferences [

	self systemNavigation browseAllCallsOnClass: self guessedClass
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> guessedClass [

	^ self block binding value class
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'pool variable '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> scope [

	^ {self block sandblockEditor}
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForPoolVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> valid [

	^ true
]
