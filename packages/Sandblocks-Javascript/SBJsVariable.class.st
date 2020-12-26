Class {
	#name : #SBJsVariable,
	#superclass : #SBJsLiteral,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsVariable >> acceptInputEvent: anEvent [

	(self isValidCharacter: anEvent keyCharacter)
		ifTrue: [super acceptInputEvent: anEvent]
		ifFalse: [SBJsGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBJsVariable >> fixActions [

	^ (self owner isBinaryOperator and: [self owner canMakeDeclaration])
		ifTrue: [{SBCodeAction labeled: 'Turn into declaration' for: self 	do: [:node | node owner makeDeclaration]}]
		ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBJsVariable >> isDeclaration [

	^ self owner isDeclaration and: [self owner lhs = self]
]

{ #category : #'as yet unclassified' }
SBJsVariable >> isValidCharacter: aCharacter [

	^ aCharacter isAlphaNumeric or: [aCharacter = $_]
]

{ #category : #'as yet unclassified' }
SBJsVariable >> resolveBinding [

	self binding: self contents for: self class: self containingArtefact relatedClass ifPresent: [:b | ^ b].
	^ nil
]

{ #category : #'as yet unclassified' }
SBJsVariable >> valid [

	^ self isDeclaration or: [self resolveBinding notNil]
]

{ #category : #'as yet unclassified' }
SBJsVariable >> validContents [

	^ self contents isEmpty or: [(self contents first isAlphaNumeric or: [self contents first = $_]) and: [self contents viewAllButFirst allSatisfy: [:c | c isAlphaNumeric or: [c = $_]]]]
]
