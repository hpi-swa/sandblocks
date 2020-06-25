Class {
	#name : #SBReachabilityColorPolicy,
	#superclass : #SBColorPolicy,
	#instVars : [
		'methods'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> colorForBlock: aBlock [

	(aBlock containingArtefact ifNotNil: #isMethod ifNil: [false]) ifTrue: [
		^ ((self wasReached: aBlock) or: [
			(aBlock isLiteralBlock or: [aBlock isName]) and: [self wasReached: aBlock parentSandblock]])
				ifTrue: [Color red adjustBrightness: 0.2]
				ifFalse: [Color white]].
	^ super colorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> initialize [

	super initialize.
	methods := IdentityDictionary new
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> report: aMethod pc: aNumber [

	(methods at: aMethod ifAbsentPut: [IdentitySet new]) add: aNumber
]

{ #category : #'as yet unclassified' }
SBReachabilityColorPolicy >> wasReached: aBlock [

	methods at: aBlock containingArtefact compiledMethod ifPresent: [:pcs | (pcs includes: aBlock pc) ifTrue: [^ true]].
	^ false
]
