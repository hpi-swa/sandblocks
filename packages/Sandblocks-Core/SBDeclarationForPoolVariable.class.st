Class {
	#name : #SBDeclarationForPoolVariable,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> browse [

	(self block binding value isKindOf: Behavior) ifTrue: [self systemNavigation browseClass: self block binding value]
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> guessedClass [

	^ self block binding value class
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'pool variable '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> scope [

	^ {self block sandblockEditor}
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForPoolVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBDeclarationForPoolVariable >> valid [

	^ true
]
