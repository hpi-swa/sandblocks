Class {
	#name : #SBDeclarationForInstanceVariable,
	#superclass : #SBDeclarationBehavior,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'instance variable'
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> browse [
	<action>

	self systemNavigation browseAllAccessesTo: self contents from: self block containingArtefact shownClass
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> defineGetterSetter [
	<action>

	self block sandblockEditor
		openMorphInView: (SBMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol arguments: #() class: self block containingArtefact shownClass;
			body: (SBBlockBody new statements: {
				(SBReturn new expression: (SBName contents: self contents))
			}));
		openMorphInView: (SBMethod new
			hasUnsavedChanges: true;
			selector: self contents asSymbol asSimpleSetter
				arguments: {(SBName contents: 'anObject')}
				class: self block containingArtefact shownClass;
			body: (SBBlockBody new statements: {
				(SBAssignment new binding: (SBName contents: self contents) value: (SBName contents: 'anObject'))
			}))
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> guessedClass [

	^ nil
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> printBlockOn: aStream [

	aStream nextPutAll: 'instance variable '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> scope [

	^ self block sandblockEditor ifNotNil: [:e | e methods select: [:m | m methodClass = self block containingArtefact shownClass]] ifNil: [#()]
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForInstanceVariableDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBDeclarationForInstanceVariable >> valid [

	^ true
]
