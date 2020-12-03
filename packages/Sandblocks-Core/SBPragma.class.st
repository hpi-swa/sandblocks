Class {
	#name : #SBPragma,
	#superclass : #SBASTNode,
	#instVars : [
		'signature'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPragma >> actualReceiver [

	^ self containingArtefact
]

{ #category : #'as yet unclassified' }
SBPragma >> arguments [

	^ signature arguments
]

{ #category : #'as yet unclassified' }
SBPragma >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBPragma >> canSwap [

	^ true
]

{ #category : #'as yet unclassified' }
SBPragma >> childSandblocksDo: aBlock [

	signature childSandblocksDo: aBlock
]

{ #category : #'as yet unclassified' }
SBPragma >> contents: aString [

	signature selector: aString
]

{ #category : #'as yet unclassified' }
SBPragma >> currentTextMorph [

	^ signature currentTextMorph
]

{ #category : #'as yet unclassified' }
SBPragma >> initialize [

	super initialize.
	self
		addMorphBack: (signature := SBSignature new
			selector: 'pragma';
			yourself)
]

{ #category : #'as yet unclassified' }
SBPragma >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ signature insertCommandRequest: anAfterBoolean near: aBlock
]

{ #category : #'as yet unclassified' }
SBPragma >> isPragma [

	^ true
]

{ #category : #'as yet unclassified' }
SBPragma >> keyStroke: anEvent [

	signature keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBPragma >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self firstSubmorph layoutCommands}
]

{ #category : #'as yet unclassified' }
SBPragma >> messageParts [

	^ signature messageParts
]

{ #category : #'as yet unclassified' }
SBPragma >> moveCursorTo: aNumber [

	signature moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBPragma >> prefix [

	^ '<> '
]

{ #category : #'as yet unclassified' }
SBPragma >> selector [

	^ signature selector
]

{ #category : #'as yet unclassified' }
SBPragma >> selector: aSymbol arguments: aCollection [

	signature selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBPragma >> startInputAt: aNumber replacingContents: aBoolean [

	^ signature startInputAt: aNumber replacingContents: aBoolean
]

{ #category : #'as yet unclassified' }
SBPragma >> stopEditing: aCommand [

	signature stopEditing: aCommand
]

{ #category : #'as yet unclassified' }
SBPragma >> symbols [

	^ self colorPolicy symbolsForPragma: self
]

{ #category : #'as yet unclassified' }
SBPragma >> useSuggestion: aString [

	signature selectorAndEdit: aString
]

{ #category : #'as yet unclassified' }
SBPragma >> valid [

	^ (self parentSandblock isBlockBody and: [self parentSandblock isMethodBody]) and: [
		(self selector notEmpty and: true) and: [ | lastIndex |
			lastIndex := self parentSandblock statements indexOf: self.
			((self parentSandblock statements viewFrom: 1 to: lastIndex) allSatisfy: #isPragma) and: [self arguments allSatisfy: #isLiteralBlock]]]
]

{ #category : #'as yet unclassified' }
SBPragma >> writeSourceOn: aStream [

	aStream nextPut: $<.
	signature writeSourceOn: aStream.
	aStream nextPut: $>
]
