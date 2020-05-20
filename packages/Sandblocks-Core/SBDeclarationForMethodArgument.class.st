Class {
	#name : #SBDeclarationForMethodArgument,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'argument'
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> guessedClass [

	^ self block containingArtefact typeFor: self
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> inputCommandClass [

	^ SBBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> isMethodArgument [

	^ true
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> isMethodLocal [

	^ true
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> printBlockOn: aStream [

	aStream nextPutAll: 'method argument '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> scope [

	^ {self block containingArtefact}
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForMethodArgumentDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBDeclarationForMethodArgument >> valid [

	^ true
]
