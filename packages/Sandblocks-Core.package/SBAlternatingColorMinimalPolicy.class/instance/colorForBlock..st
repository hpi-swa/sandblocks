as yet unclassified
colorForBlock: aBlock

	| currentColor colors |
	aBlock isBlockBody ifTrue: [^ Color red alphaMixed: 0.7 with: Color black].
	currentColor := (aBlock parentSandblock ifNil: [^ self colors first]) drawnColor.
	colors := self colors.
	^ colors atWrap: (colors indexOf: currentColor) + 1