as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [
		^ aBlock
			valueOfProperty: #sandblockBlockColor
			ifAbsentPut: [
				aBlock isMethodBody
					ifTrue: [aBlock containingArtefact methodClass sandblockColor]
					ifFalse: ["Color random"self mutateColor: (self colorForBlock: (aBlock parentSandblock containingBlock))]]].
	^ aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]