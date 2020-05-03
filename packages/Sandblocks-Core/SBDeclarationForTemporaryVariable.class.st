Class {
	#name : #SBDeclarationForTemporaryVariable,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'temporary'
]

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> inputCommandClass [

	^ SBBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> isMethodLocal [

	^ true
]

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'temporary '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> scope [

	^ {self block containingBlock}
]

{ #category : #'as yet unclassified' }
SBDeclarationForTemporaryVariable >> valid [

	^ true
]
