Class {
	#name : #SBStDeclarationForInstanceVariable,
	#superclass : #SBStDeclarationForBehaviorVariable,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable class >> checkCastFor: aBlock parent: aMorph [

	| artefact |
	artefact := aMorph containingSandblock containingArtefact.
	^ (artefact satisfies: {#notNil. #isEditor. #isClassContainer}) and: [aMorph = artefact instanceVariables]
]

{ #category : #accessing }
SBStDeclarationForInstanceVariable >> allVariableNames [

	^ self block containingArtefact object instVarNames
]

{ #category : #actions }
SBStDeclarationForInstanceVariable >> browse [
	<action>

	self systemNavigation browseAllAccessesTo: self contents from: self block containingArtefact shownClass
]

{ #category : #actions }
SBStDeclarationForInstanceVariable >> browseReferences [

	self systemNavigation
		browseAllAccessesTo: self contents
		from: self relatedClass object
]

{ #category : #accessing }
SBStDeclarationForInstanceVariable >> guessedClass [

	class isMeta ifTrue: [^ (class theNonMetaClass instVarNamed: self contents) class].
	^ super guessedClass
]

{ #category : #accessing }
SBStDeclarationForInstanceVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForInstanceVariableDeclaration: self block
]

{ #category : #accessing }
SBStDeclarationForInstanceVariable >> typeLabel [

	^ 'instance variable'
]
