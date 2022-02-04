Class {
	#name : #SBStPragma,
	#superclass : #SBStASTNode,
	#instVars : [
		'signature'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStPragma >> actualReceiver [

	^ self containingArtefact
]

{ #category : #'as yet unclassified' }
SBStPragma >> arguments [

	^ signature arguments
]

{ #category : #'as yet unclassified' }
SBStPragma >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBStPragma >> contents: aString [

	signature selector: aString
]

{ #category : #'as yet unclassified' }
SBStPragma >> initialize [

	super initialize.
	self
		addMorphBack: (signature := SBStSignature new
			selector: 'pragma';
			yourself)
]

{ #category : #'as yet unclassified' }
SBStPragma >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ signature insertCommandRequest: aMorph near: aBlock before: aBoolean
]

{ #category : #'as yet unclassified' }
SBStPragma >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBStPragma >> isPragma [

	^ true
]

{ #category : #'as yet unclassified' }
SBStPragma >> keyStroke: anEvent [

	signature keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBStPragma >> keyword [

	^ self selector
]

{ #category : #'as yet unclassified' }
SBStPragma >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStPragma >> messageParts [

	^ signature messageParts
]

{ #category : #'as yet unclassified' }
SBStPragma >> prefix [

	^ '<> '
]

{ #category : #'as yet unclassified' }
SBStPragma >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBStPragma >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBStPragma >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBStPragma >> symbols [

	^ self colorPolicy symbolsForPragma: self
]

{ #category : #'as yet unclassified' }
SBStPragma >> tryDelete [

	self deleteBlock
]

{ #category : #'as yet unclassified' }
SBStPragma >> useSuggestion: anItem [

	signature selectorAndEdit: anItem contents
]

{ #category : #'as yet unclassified' }
SBStPragma >> valid [

	^ (self parentSandblock isBlockBody and: [self parentSandblock isMethodBody]) and: [
		(self selector notEmpty and: true) and: [ | lastIndex |
			lastIndex := self parentSandblock statements indexOf: self.
			((self parentSandblock statements viewFrom: 1 to: lastIndex) allSatisfy: #isPragma) and: [self arguments allSatisfy: #isLiteralBlock]]]
]

{ #category : #'as yet unclassified' }
SBStPragma >> writeSourceOn: aStream [

	aStream nextPut: $<.
	signature writeSourceOn: aStream.
	aStream nextPut: $>
]
