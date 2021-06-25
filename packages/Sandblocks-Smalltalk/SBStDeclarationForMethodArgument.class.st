Class {
	#name : #SBStDeclarationForMethodArgument,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument class >> checkCastFor: aBlock parent: aMorph [

	^ (aMorph parentSandblock ifNotNil: [:b | b isMethod] ifNil: [false]) and: [aMorph parentSandblock isMyArgument: self]
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'argument'
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> guessedClass [

	^ SBToggledCode
		comment: 'while generally a nice idea, way too often people just use generic superclasses for their arg names'
		active: 2
		do: {
			[
				(self block containingArtefact typeFor: self block) ifNil: [
					(self contents size > 3 and: [self contents first = $a]) ifTrue: [ | className |
						className := (self contents second = $n
							ifTrue: [self contents allButFirst: 2]
							ifFalse: [self contents allButFirst]) asSymbol.
						Smalltalk
							at: className
							ifPresent: [:obj | obj isBehavior ifTrue: [obj] ifFalse: [nil]]
							ifAbsent: [nil]]]].
			[nil]}
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> isMethodArgument [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> isMethodLocal [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> printBlockOn: aStream [

	aStream nextPutAll: 'method argument '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> scope [

	^ {self block containingArtefact}
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> symbolsFor: aColorPolicy [

	^ aColorPolicy symbolsForMethodArgumentDeclaration: self block
]

{ #category : #'as yet unclassified' }
SBStDeclarationForMethodArgument >> valid [

	^ true
]
