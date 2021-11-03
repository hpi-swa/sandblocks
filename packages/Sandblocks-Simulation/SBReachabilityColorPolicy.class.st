Class {
	#name : #SBReachabilityColorPolicy,
	#superclass : #SBColorPolicy,
	#instVars : [
		'methods'
	],
	#category : #'Sandblocks-Simulation'
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

	^ aMethod "aMethod selector hash bitXor: aMethod methodClass hash"
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> initialize [

	super initialize.
	methods := Dictionary new
]

{ #category : #private }
SBReachabilityColorPolicy >> methods [

	^ methods
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
SBReachabilityColorPolicy >> reached: aNumber in: aCompiledMethod [

	| method pc |
	aNumber isNumber
		ifTrue: [
			pc := aNumber.
			method := aCompiledMethod]
		ifFalse: [
			pc := aNumber value.
			method := aNumber key].
	
	methods at: (self hash: method) ifPresent: [:pcs | (pcs includes: pc) ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> report: aMethod pc: aNumber [

	(methods at: (self hash: aMethod) ifAbsentPut: [IdentitySet new]) add: aNumber
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> wasReached: aBlock [

	^ self reached: aBlock pc in: aBlock containingArtefact compiledMethod
]
