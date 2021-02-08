Class {
	#name : #SBSymbolLiteralRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBSymbolLiteralRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBSymbolLiteralRepresentation class >> matches: anObject [

	^ anObject isSymbol
]

{ #category : #'as yet unclassified' }
SBSymbolLiteralRepresentation class >> newFor: aSymbol [

	^ SBStSymbol new contents: aSymbol asString
]
