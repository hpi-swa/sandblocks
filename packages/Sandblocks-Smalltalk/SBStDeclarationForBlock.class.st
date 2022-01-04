Class {
	#name : #SBStDeclarationForBlock,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForBlock class >> checkCastFor: aBlock parent: aMorph [

	^ aMorph isBlockBindings
]

{ #category : #accessing }
SBStDeclarationForBlock >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'block var'
]

{ #category : #accessing }
SBStDeclarationForBlock >> guessedClass [

	^ self block containingArtefact typeFor: self block
]

{ #category : #accessing }
SBStDeclarationForBlock >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #accessing }
SBStDeclarationForBlock >> isBlockBinding [

	^ true
]

{ #category : #accessing }
SBStDeclarationForBlock >> isMethodLocal [

	^ true
]

{ #category : #accessing }
SBStDeclarationForBlock >> prefix [

	^ ':'
]

{ #category : #accessing }
SBStDeclarationForBlock >> printBlockOn: aStream [

	aStream nextPutAll: 'block declaration '; nextPutAll: self contents
]

{ #category : #accessing }
SBStDeclarationForBlock >> scope [

	^ {self block parentSandblock}
]

{ #category : #accessing }
SBStDeclarationForBlock >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForBlockDeclaration: self block
]

{ #category : #accessing }
SBStDeclarationForBlock >> valid [
	" check that this name does not already exist in a parent scope "

	^ (self block containingBlock parentSandblock
		binding: self contents
		for: self block
		class: (self block containingArtefact ifNotNil: #relatedClass)
		ifPresent: [:binding | binding isMethodLocal ifTrue: [binding] ifFalse: [nil]]) isNil
]
