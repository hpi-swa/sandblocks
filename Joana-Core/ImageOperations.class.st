Class {
	#name : #ImageOperations,
	#superclass : #Object,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
ImageOperations class >> as8Bit: aForm [

	^ aForm as8BitColorForm
]

{ #category : #'as yet unclassified' }
ImageOperations class >> dimmed: aForm [

	^ aForm dimmed
]

{ #category : #'as yet unclassified' }
ImageOperations class >> emboss: aForm factor: aFactor bias: aBias [

	^ aForm
		processUsingKernel: (Matrix rows: 3 columns: 3 contents: #(-2 -1 0 -1 1 1 0 1 2))
		factor: aFactor
		bias: aBias
]
