Class {
	#name : #SBStDeclarationForTemporaryVariable,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable class >> checkCastFor: aBlock parent: aMorph [

	^ aMorph isTemporaries
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'temporary'
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> fixActions [

	^ self hasUsages
		ifTrue: [#()]
		ifFalse: [{
			SBCodeAction
				labeled: 'Remove unused declaration' for: self block
				do: [:node | node deleteBlock]}]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> isMethodLocal [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> isTemporaryVariable [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'temporary '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> scope [

	^ {self block containingBlock}
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForTemporaryVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForTemporaryVariable >> valid [

	^ self block isInWorld not or: [self hasUsages]
]
