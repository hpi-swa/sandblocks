Class {
	#name : #SBOhmGrammar,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmGrammar class >> from: aString [

	| reader result |
	reader := OhmGrammarOfOhm OhmInstance semanticAction: SBOhmSemantic new.
	result := reader grammar match: aString startingFrom: 'Grammar'.
	^ reader value: result
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
SBOhmGrammar >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBOhmRule new name: '' alternatives: SBOhmGrammarHandler new newNullBlock);
		shouldMergeWithNext: true;
		yourself
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
SBOhmGrammar >> objectInterfaceAt: aNumber adding: aBoolean [

	^ {#isSandblock. #isOhm. [:o | o isExpression not]}
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> rules [

	^ self submorphs, (OhmBuiltInRules rules associations, OhmBaseGrammar rules associations)
]

{ #category : #'as yet unclassified' }
SBOhmGrammar >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
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
SBOhmGrammar >> writeSourceOn: aStream [

	self grammarHandler writeSourceOn: aStream for: self
]

{ #category : #smalltalk }
SBOhmGrammar >> writeStSourceOn: aStream [

	aStream nextPutAll: '(OhmGrammar new: '.
	aStream store: (String streamContents: [:s |
		self writeOhmSourceOn: s]).
	aStream nextPut: $)
]
