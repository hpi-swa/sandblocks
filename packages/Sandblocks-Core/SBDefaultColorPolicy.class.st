Class {
	#name : #SBDefaultColorPolicy,
	#superclass : #SBColorPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDefaultColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock prefersNoBorder ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBDefaultColorPolicy >> colorForBlock: aBlock [

	^ aBlock sandblockBlockColorIfAbsent: [
		aBlock isBlockBody
			ifTrue: [
				aBlock sandblockBlockColorIfAbsentPut: [
					(aBlock containingBlock isNil or: [aBlock isMethodBody])
						ifTrue: [aBlock containingArtefact relatedClass sandblockColor]
						ifFalse: [self mutateColor: (self colorForBlock: aBlock containingBlock)]]]
			ifFalse: [aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]]]
]

{ #category : #'as yet unclassified' }
SBDefaultColorPolicy >> mutateColor: aColor [

	^ Color h: aColor hue + 30 s: aColor saturation v: (aColor brightness > 0.6 ifTrue: [aColor brightness - 0.3] ifFalse: [0.3 + aColor brightness])
]
