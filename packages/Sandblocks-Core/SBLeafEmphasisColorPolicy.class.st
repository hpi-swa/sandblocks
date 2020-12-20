Class {
	#name : #SBLeafEmphasisColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLeafEmphasisColorPolicy >> colorForBlock: aBlock [

	^ SBToggledCode
		comment: ''
		active: 2
		do: {[aBlock hasChildSandblocks ifTrue: [Color white] ifFalse: [Color black]]. [Color white]}
]

{ #category : #'as yet unclassified' }
SBLeafEmphasisColorPolicy >> foregroundColorForBlock: aBlock [

	^ aBlock hasChildSandblocks ifTrue: [Color black] ifFalse: [Color gray]
]
