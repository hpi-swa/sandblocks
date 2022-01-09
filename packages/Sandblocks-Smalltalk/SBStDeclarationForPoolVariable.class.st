Class {
	#name : #SBStDeclarationForPoolVariable,
	#superclass : #SBStDeclarationBehavior,
	#instVars : [
		'binding'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable class >> checkCastFor: aBlock parent: aMorph [

	| artefact |
	artefact := aMorph containingSandblock containingArtefact.
	^ (artefact satisfies: {#notNil. #isEditor. #isClassContainer}) and: [aMorph = artefact classVariables]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'pool'
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> binding: aBinding [

	binding := aBinding
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> browse [
	<action>

	(self block binding value isKindOf: Behavior) ifTrue: [self systemNavigation browseClass: self block binding value]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> browseReferences [

	self systemNavigation browseAllCallsOnClass: binding
]

{ #category : #'as yet unclassified' }
SBStDeclarationForPoolVariable >> guessedClass [

	^ self block binding value ifNotNil: #class
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
