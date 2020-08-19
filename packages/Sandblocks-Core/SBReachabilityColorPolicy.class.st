Class {
	#name : #SBReachabilityColorPolicy,
	#superclass : #SBColorPolicy,
	#instVars : [
		'methods'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> borderColorForBlock: aBlock [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMessagePart ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> colorForBlock: aBlock [

	(aBlock containingArtefact ifNotNil: #isMethod ifNil: [false]) ifTrue: [
		^ ((self wasReached: aBlock) or: [self parentWasReached: aBlock])
				ifTrue: [Color red adjustBrightness: 0.2]
				ifFalse: [Color white]].
	^ super colorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> hash: aMethod [

	^ aMethod selector hash bitXor: aMethod methodClass hash
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> initialize [

	super initialize.
	methods := IdentityDictionary new
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> parentWasReached: aBlock [

	| block |
	block := aBlock.
	[block notNil and: [block isLiteralBlock or: [block isName or: [block isBlockBody or: [block isCascade and: [self wasReached: block messages first]]]]]] whileTrue: [
		block := block parentSandblock].
	^ block notNil and: [self wasReached: block]
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> report: aMethod pc: aNumber [

	(methods at: (self hash: aMethod) ifAbsentPut: [IdentitySet new]) add: aNumber
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> wasReached: aBlock [

	methods at: (self hash: aBlock containingArtefact compiledMethod) ifPresent: [:pcs | (pcs includes: aBlock pc) ifTrue: [^ true]].
	^ false
]
