Class {
	#name : #SBPingPongColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPingPongColorPolicy >> borderColorForBlock: aBlock [
	
	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBPingPongColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isArtefact ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBPingPongColorPolicy >> colorForBlock: aBlock [
	
	aBlock isBlockBody ifTrue: [^ ((0.55 to: 1.0 by: 0.1) collect: [:g | Color r: 0.2 g: g b: 0.7 alpha: 0.9]) atPingPong: aBlock blockBodyNestingDepth].
	^ ((0.7 to: 1.0 by: 0.2) collect: [:g | Color gray: g]) atPingPong: aBlock localNestingDepth
]

{ #category : #'as yet unclassified' }
SBPingPongColorPolicy >> layoutInsetFor: aBlock [

	((aBlock isKindOf: SBStLiteral) or: [aBlock isBlockBody]) ifTrue: [^ 2 @ 2].
	
	aBlock isMessageSend ifTrue: [
		aBlock childHierarchyComplexity > 9 ifTrue: [^ 3 @ 3]].
	
	^ (aBlock isMessageSend or: [aBlock isAssignment or: [aBlock isReturn]]) ifTrue: [2 @ 0] ifFalse: [2 @ 2]
]
