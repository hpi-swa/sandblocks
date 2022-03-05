Class {
	#name : #SBStDeclarationForClassVariable,
	#superclass : #SBStDeclarationForBehaviorVariable,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForClassVariable class >> checkCastFor: aBlock parent: aMorph [

	| artefact |
	artefact := aMorph containingSandblock containingArtefact.
	^ (artefact satisfies: {#notNil. #isEditor. #isClassContainer}) and: [aMorph = artefact classVariables]
]

{ #category : #accessing }
SBStDeclarationForClassVariable >> allVariableNames [

	^ self block containingArtefact object classVarNames
]

{ #category : #actions }
SBStDeclarationForClassVariable >> browse [
	<action>

	self systemNavigation
		browseAllCallsOn: self contents
		from: self block containingArtefact shownClass
]

{ #category : #actions }
SBStDeclarationForClassVariable >> browseReferences [

	self systemNavigation
		browseAllCallsOn: self contents
		from: self relatedClass object
]

{ #category : #accessing }
SBStDeclarationForClassVariable >> guessedClass [

	^ self block binding value ifNotNil: #class
]

{ #category : #accessing }
SBStDeclarationForClassVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForClassVariableDeclaration: self block
]

{ #category : #accessing }
SBStDeclarationForClassVariable >> typeLabel [

	^ 'class variable'
]
