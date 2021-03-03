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
						ifTrue: [aBlock preferredColor ifNil: [Color r: 0.216 g: 0.249 b: 0.436]]
						ifFalse: [self mutateColor: (self colorForBlock: aBlock containingBlock)]]]
			ifFalse: [
				aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.09] ifNil: [Color white]]]
]

{ #category : #'as yet unclassified' }
SBDefaultColorPolicy >> mutateColor: aColor [

	^ SBToggledCode
		comment: ''
		active: 1
		do: {
			[
				Color
					h: aColor hue + 15
					s: aColor saturation
					v: (SBToggledCode
						comment: ''
						active: 2
						do: {
							[aColor brightness > 0.6 ifTrue: [aColor brightness - 0.3] ifFalse: [0.3 + aColor brightness]].
							[aColor brightness]
						})].
			[aColor]
		}
]
