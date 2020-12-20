Class {
	#name : #SBAlternatingColorMinimalPolicy,
	#superclass : #SBColorMinimalPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> borderColorForBlock: aBlock [

	^ Color white alpha: 0.7
]

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isBlockBody ifTrue: [1] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> colorForBlock: aBlock [

	| currentColor colors |
	aBlock isBlockBody ifTrue: [^ Color red alphaMixed: 0.7 with: Color black].
	currentColor := (aBlock parentSandblock ifNil: [^ self colors first]) drawnColor.
	colors := self colors.
	^ colors atWrap: (colors indexOf: currentColor) + 1
]

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> colors [

	^ SBToggledCode
		comment: ''
		active: 3
		do: {
			[{Color red. Color green. Color blue}].
			[{Color black. Color gray. Color white}].
			[
				{
					Color tungsten.
					(Color r: 0.33 g: 0.33 b: 0.33).
					(Color r: 0.66 g: 0.66 b: 0.66).
					(Color r: 0.77 g: 0.77 b: 0.77)
				}].
			[
				{Color white. (Color r: 0.88 g: 0.88 b: 0.88). (Color r: 0.77 g: 0.77 b: 0.77). (Color r: 0.7 g: 0.7 b: 0.7)}]
		}
]

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> layoutInsetFor: aBlock [

	^ aBlock isBlockBody ifTrue: [2] ifFalse: (super layoutInsetFor: aBlock)
]

{ #category : #'as yet unclassified' }
SBAlternatingColorMinimalPolicy >> symbolsForBlock: aBlock [

	^ #('[ ' ' ]')
]
