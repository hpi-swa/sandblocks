Class {
	#name : #SBStDeclarationForBehaviorVariable,
	#superclass : #SBStDeclarationBehavior,
	#instVars : [
		'class'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> allVariableNames [

	^ self subclassResponsibility
]

{ #category : #converting }
SBStDeclarationForBehaviorVariable >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: self typeLabel
]

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> class: aClass [

	class := aClass
]

{ #category : #actions }
SBStDeclarationForBehaviorVariable >> createGetterSetter [
	<action>

	self block sandblockEditor
		createArtefactInView: self getterBlock;
		createArtefactInView: self setterBlock
]

{ #category : #private }
SBStDeclarationForBehaviorVariable >> getterBlock [

	^ SBStMethod new
		selector: self contents asSymbol
			arguments: #()
			class: self block containingArtefact shownClass;
		body: (SBStBlockBody new statements: {SBStReturn new expression: (SBStName contents: self contents)})
]

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> guessedClass [

	^ nil
]

{ #category : #printing }
SBStDeclarationForBehaviorVariable >> printBlockOn: aStream [

	aStream
		nextPutAll: self typeLabel;
		space;
		nextPutAll: self contents
]

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> relatedClass [

	^ class ifNil: [self block containingArtefact relatedClass]
]

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> scope [

	^ self block sandblockEditor
		ifNotNil: [:e | e methods select: [:m | m methodClass = self block containingArtefact shownClass]]
		ifNil: [#()]
]

{ #category : #private }
SBStDeclarationForBehaviorVariable >> setterBlock [

	| argumentName |
	argumentName := self setterBlockArgumentName.
	^ SBStMethod new
		selector: self contents asSymbol asSimpleSetter
			arguments: {SBStName contents: argumentName}
			class: self block containingArtefact shownClass;
		body: (SBStBlockBody new statements: {[:b | b assign: self contents to: (b name: argumentName)] sbStBuild})
]

{ #category : #private }
SBStDeclarationForBehaviorVariable >> setterBlockArgumentName [

	| className |
	className := (self guessedClass ifNil: [Object]) canonicalArgumentName.
	^ (className first isVowel ifTrue: ['an'] ifFalse: ['a']), className
]

{ #category : #accessing }
SBStDeclarationForBehaviorVariable >> typeLabel [

	^ self subclassResponsibility
]

{ #category : #testing }
SBStDeclarationForBehaviorVariable >> valid [

	^ self allVariableNames includes: self contents
]
