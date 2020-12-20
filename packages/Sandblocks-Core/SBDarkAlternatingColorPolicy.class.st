Class {
	#name : #SBDarkAlternatingColorPolicy,
	#superclass : #SBAlternatingColorPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDarkAlternatingColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isBlockBody ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBDarkAlternatingColorPolicy >> colorForEditor [

	^ Color r: 0.3 g: 0.3 b: 0.3
]

{ #category : #'as yet unclassified' }
SBDarkAlternatingColorPolicy >> colors [

	^ {Color black. Color r: 0.2 g: 0.2 b: 0.2. Color white}
]

{ #category : #'as yet unclassified' }
SBDarkAlternatingColorPolicy >> randomColor [

	^ Color random adjustBrightness: 0.4
]
