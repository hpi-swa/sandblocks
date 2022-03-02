Class {
	#name : #SBOhmList,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmList >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmList >> connect [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBOhmList >> connect: aString expressions: aCollection [

	self addMorph: (SBOwnTextMorph new
		contents: aString;
		bold).
	self addAllMorphsBack: aCollection
]

{ #category : #'as yet unclassified' }
SBOhmList >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmList >> expressions [

	^ self submorphs viewAllButFirst
]

{ #category : #'as yet unclassified' }
SBOhmList >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmList >> isAlternative [

	^ self connect = 'OR'
]

{ #category : #'as yet unclassified' }
SBOhmList >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmList >> isSequence [

	^ self connect = 'AND'
]

{ #category : #'as yet unclassified' }
SBOhmList >> isTerminalish [

	^ self connect = 'OR' and: [self childSandblocks allSatisfy: #isTerminal]
]

{ #category : #'as yet unclassified' }
SBOhmList >> layoutCommands [

	^ SBToggledCode comment: '' active: 2 do: {
		[
			SBAlgebraCommand container
				data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap]);
				morph: self].
		[
			SBAlgebraCommand container
				data: {
					self submorphs first layoutCommands.
					SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap}, (self submorphs viewAllButFirst
						collect: #layoutCommands
						separatedBy: [SBAlgebraCommand softLineOrGap withGap: true])};
				morph: self]}
]

{ #category : #'as yet unclassified' }
SBOhmList >> maybeUnwrapList [

	^ self expressions size = 1 ifTrue: [self expressions first] ifFalse: [self]
]

{ #category : #'as yet unclassified' }
SBOhmList >> newEmptyChildNear: aBlock before: aBoolean [

	^ super newNullBlock ifNotNil: [:l | l label: 'seq']
]

{ #category : #'as yet unclassified' }
SBOhmList >> printOn: aStream [

	aStream nextPutAll: (self isSequence ifTrue: ['ohm sequence ('] ifFalse: ['ohm alternatives (']).
	self childSandblocks
		do: [:c | aStream print: c]
		separatedBy: [aStream nextPutAll: ', '].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBOhmList >> writeOnMultipleLinesOn: aStream [

	self expressions do: [:s | s writeSourceOn: aStream] separatedBy: [
		aStream
			crtab;
			nextPutAll: (self connect = 'OR' ifTrue: ['| '] ifFalse: [''])]
]

{ #category : #'as yet unclassified' }
SBOhmList >> writeRascalSourceOn: aStream [

	| needsParens |
	needsParens := self parentSandblock isAlternative not and: [self parentSandblock isRule not].
	
	needsParens ifTrue: [aStream nextPut: $(].
	self expressions
		do: [:s | s writeRascalSourceOn: aStream]
		separatedBy: [aStream nextPutAll: (self connect = 'OR' ifTrue: [' | '] ifFalse: [' '])].
	needsParens ifTrue: [aStream nextPut: $)]
]

{ #category : #'as yet unclassified' }
SBOhmList >> writeSourceOn: aStream [

	| needsParens |
	needsParens := self parentSandblock isAlternative not and: [self parentSandblock isRule not].
	
	needsParens ifTrue: [aStream nextPut: $(].
	self expressions
		do: [:s | s writeSourceOn: aStream]
		separatedBy: [aStream nextPutAll: (self connect = 'OR' ifTrue: [' | '] ifFalse: [' '])].
	needsParens ifTrue: [aStream nextPut: $)]
]
