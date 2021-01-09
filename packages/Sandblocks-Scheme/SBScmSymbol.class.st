Class {
	#name : #SBScmSymbol,
	#superclass : #SBScmIdentifier,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmSymbol >> acceptInputEvent: anEvent [

	(anEvent keyCharacter = $( and: [self contents isEmpty])
		ifTrue: [
			self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: (SBScmExpression new quoted: true))]
		ifFalse: [super acceptInputEvent: anEvent]
]

{ #category : #'as yet unclassified' }
SBScmSymbol >> symbols [

	^ #('''' nil)
]

{ #category : #'as yet unclassified' }
SBScmSymbol >> valid [

	^ self validContents
]

{ #category : #'as yet unclassified' }
SBScmSymbol >> writeSourceOn: aStream [

	aStream nextPut: $'.
	aStream nextPutAll: self contents
]
