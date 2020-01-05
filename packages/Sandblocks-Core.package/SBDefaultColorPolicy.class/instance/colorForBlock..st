as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [
		^ aBlock
			valueOfProperty: #sandblockBlockColor
			ifAbsentPut: [
				aBlock isMethodBody
					ifTrue: [aBlock containingMethod methodClass sandblockColor]
					ifFalse: [Color random]]].
	^ aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]