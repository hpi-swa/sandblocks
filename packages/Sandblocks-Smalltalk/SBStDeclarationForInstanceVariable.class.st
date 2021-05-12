Class {
	#name : #SBStDeclarationForInstanceVariable,
	#superclass : #SBStDeclarationBehavior,
	#instVars : [
		'class'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'instance variable'
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> browse [
	<action>

	self systemNavigation browseAllAccessesTo: self contents from: self block containingArtefact shownClass
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> browseReferences [

	self systemNavigation
		browseAllAccessesTo: self contents
		from: class
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> class: aClass [

	class := aClass
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> defineGetterSetter [
	<action>

	self block sandblockEditor
		createArtefactInView: self getterBlock;
		createArtefactInView: self setterBlock
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> getterBlock [

	^ SBStMethod new
		selector: self contents asSymbol
			arguments: #()
			class: self block containingArtefact shownClass;
		body: (SBStBlockBody new statements: {SBStReturn new expression: (SBStName contents: self contents)})
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> guessedClass [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'instance variable '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> scope [

	^ self block sandblockEditor ifNotNil: [:e | e methods select: [:m | m methodClass = self block containingArtefact shownClass]] ifNil: [#()]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> setterBlock [

	^ SBStMethod new
		selector: self contents asSymbol asSimpleSetter
			arguments: {SBStName contents: 'anObject'}
			class: self block containingArtefact shownClass;
		body: (SBStBlockBody new statements: {[:b | b assign: self contents to: (b name: 'anObject')] sbStBuild})
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForInstanceVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> valid [

	^ self block containingArtefact object instVarNames includes: self contents
]
