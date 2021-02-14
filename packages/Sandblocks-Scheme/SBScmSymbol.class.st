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
SBScmSymbol >> asIdentifier: converter [
	<convert>
	
	converter do: [SBScmIdentifier new contents: self contents]
]

{ #category : #'as yet unclassified' }
SBScmSymbol >> asString: converter [
	<convert>

	converter do: [SBScmSymbol new contents: self contents]
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

{ #category : #'as yet unclassified' }
SBScmSymbol >> writeSourceOn: aStream indent: aNumber [

	aStream nextPut: $'.
	super writeSourceOn: aStream indent: aNumber
]
