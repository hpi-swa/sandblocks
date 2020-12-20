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

	^ (self block containingArtefact typeFor: self)
		ifNil: [
			(self contents size > 3 and: [self contents first = $a]) ifTrue: [ | className |
				className := (self contents second = $n
					ifTrue: [self contents allButFirst: 2]
					ifFalse: [self contents allButFirst]) asSymbol.
				Smalltalk at: className ifAbsent: [nil]]]
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
