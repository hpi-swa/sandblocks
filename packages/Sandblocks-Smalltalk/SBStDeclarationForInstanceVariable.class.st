Class {
	#name : #SBStDeclarationForInstanceVariable,
	#superclass : #SBStDeclarationBehavior,
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
SBStDeclarationForInstanceVariable >> defineGetterSetter [
	<action>

	self block sandblockEditor
		openMorphInView: (SBStMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol arguments: #() class: self block containingArtefact shownClass;
			body: (SBStBlockBody new statements: {
				(SBStReturn new expression: (SBStName contents: self contents))
			}));
		openMorphInView: (SBStMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol asSimpleSetter
				arguments: {(SBStName contents: 'anObject')}
				class: self block containingArtefact shownClass;
			body: (SBStBlockBody new statements: {
				(SBStAssignment new binding: (SBStName contents: self contents) value: (SBStName contents: 'anObject'))
			}))
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
SBStDeclarationForInstanceVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForInstanceVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForInstanceVariable >> valid [

	^ true
]
