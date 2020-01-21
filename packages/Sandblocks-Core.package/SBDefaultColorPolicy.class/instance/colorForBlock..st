as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [
		^ aBlock
			valueOfProperty: #sandblockBlockColor
			ifAbsentPut: [
				aBlock containingBlock
					ifNil: [aBlock containingArtefact methodClass sandblockColor]
					ifNotNil: [:block | self mutateColor: (self colorForBlock: block)]]].
	^ aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]