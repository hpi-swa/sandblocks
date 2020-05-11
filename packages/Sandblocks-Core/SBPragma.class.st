Class {
	#name : #SBPragma,
	#superclass : #SBASTNode,
	#instVars : [
		'signature'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPragma >> activeMorph [

	^ signature activeMorph ifNil: [self]
]

{ #category : #'as yet unclassified' }
SBPragma >> arguments [

	^ signature arguments
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
		listDirection: #leftToRight;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (signature := SBSignature new
			layoutPolicy: SBKeywordMessageLayout new;
			selector: 'pragma';
			yourself);
		layoutPolicy: SBHorizontalLayout new
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
