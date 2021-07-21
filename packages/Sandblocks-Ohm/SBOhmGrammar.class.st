Class {
	#name : #SBOhmGrammar,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmGrammar class >> example [

	| grammar |
	SBExample self: [SBOhmGrammar] args: [{}] label: 'example'.
	grammar := OhmGrammar new: 'G <: BuiltInRules {
email = name "@" domain

domain = (letter | digit)+ "." letter+

name = (letter | digit)+}'.
	^ grammar match: 'tom@example.com' startingFrom: 'email'
]

{ #category : #'as yet unclassified' }
SBOhmGrammar class >> from: aString [

	| reader result |
	reader := OhmGrammarOfOhm OhmInstance semanticAction: SBOhmSemantic new.
	result := reader grammar match: aString startingFrom: 'Grammar'.
	^ reader value: result
]

{ #category : #'as yet unclassified' }
SBOhmGrammar class >> fromGrammar: aGrammar [

	^ self from: aGrammar grammarDefinitionString
]

{ #category : #smalltalk }
SBOhmGrammar >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> canPersist [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> fixedNumberOfChildren [

	^ false
]

{ #category : #smalltalk }
SBOhmGrammar >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #smalltalk }
SBOhmGrammar >> guessClassExpensive [

	^ self guessedClass
]

{ #category : #smalltalk }
SBOhmGrammar >> guessedClass [

	^ OhmGrammar
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		attachDecorator: SBResizableDecorator new;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> isBlockBody [

	^ true
]

{ #category : #smalltalk }
SBOhmGrammar >> isExpression [

	^ true
]

{ #category : #smalltalk }
SBOhmGrammar >> isSmalltalk [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> layoutCommands [

	^ SBAlgebraCommand container
		data: (self submorphs
			collect: #layoutCommands
			separatedBy: [SBAlgebraCommand hardLine withGap: true]);
		morph: self
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBOhmRule new name: '' alternatives: SBOhmGrammarHandler new newNullBlock
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> objectInterfaceNear: aBlock at: aSymbol [

	^ {#isSandblock. #isOhm. [:o | o isExpression not]}
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> openAsBlocksFrom: anOhmGrammar [

	SBGrammarTransformer openFor: self original: anOhmGrammar
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> rascalSource [

	^ String streamContents: [:stream | self writeRascalSourceOn: stream]
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> ruleNamed: aString [

	^ self childSandblocks detect: [:rule | rule name = aString]
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> ruleNamed: aString ifNone: aBlock [

	^ self childSandblocks detect: [:rule | rule name = aString] ifNone: aBlock
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> rules [

	^ self submorphs, (OhmBuiltInRules rules associations, OhmBaseGrammar rules associations)
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #smalltalk }
SBOhmGrammar >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> statements [

	^ self submorphs
]

{ #category : #smalltalk }
SBOhmGrammar >> updatePCFrom: anObject [
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> writeOhmSourceOn: aStream [

	aStream nextPutAll: 'G <: BuiltInRules {'; cr.
	self statements do: [:s | s writeSourceOn: aStream] separatedBy: [
		aStream
			cr;
			cr].
	aStream nextPut: $}
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> writeRascalSourceOn: aStream [

	aStream
		nextPutAll: 'module lang::g::Syntax';
		cr.
	self statements do: [:s | s writeRascalSourceOn: aStream] separatedBy: [
		aStream
			cr;
			cr]
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> writeSourceOn: aStream [

	self grammarHandler writeSourceOn: aStream for: self
]

{ #category : #smalltalk }
SBOhmGrammar >> writeStBlockSourceOn: aStream [

	aStream nextPutAll: '(SBOhmGrammar from: '.
	aStream store: (String streamContents: [:s | self writeOhmSourceOn: s]).
	aStream nextPut: $)
]

{ #category : #smalltalk }
SBOhmGrammar >> writeStSourceOn: aStream [

	aStream nextPutAll: '(OhmGrammar new: '.
	aStream store: (String streamContents: [:s |
		self writeOhmSourceOn: s]).
	aStream nextPut: $)
]
