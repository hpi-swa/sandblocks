Class {
	#name : #SBDeclarationForBlock,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBDeclarationForBlock >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'block var'
]

{ #category : #accessing }
SBDeclarationForBlock >> guessedClass [

	^ self block containingArtefact typeFor: self
]

{ #category : #accessing }
SBDeclarationForBlock >> inputCommandClass [

	^ SBBindingRenameCommand
]

{ #category : #accessing }
SBDeclarationForBlock >> isBlockBinding [

	^ true
]

{ #category : #accessing }
SBDeclarationForBlock >> isMethodLocal [

	^ true
]

{ #category : #accessing }
SBDeclarationForBlock >> prefix [

	^ ':'
]

{ #category : #accessing }
SBDeclarationForBlock >> printBlockOn: aStream [

	aStream nextPutAll: 'block declaration '; nextPutAll: self contents
]

{ #category : #accessing }
SBDeclarationForBlock >> scope [

	^ {self block parentSandblock}
]

{ #category : #accessing }
SBDeclarationForBlock >> valid [

	" check that this name does not already exist in a parent scope "
	^ (self block containingBlock parentSandblock bindingFor: self contents class: self block containingArtefact relatedClass ifPresent: [:binding | binding]) isNil
]
