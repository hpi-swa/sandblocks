as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [
		^ aBlock
			valueOfProperty: #sandblockBlockColor
			ifAbsentPut: [
				aBlock isMethodBody
					ifTrue: [Color fromString: '#', ((aBlock containingMethod methodClass hash printStringBase: 16) last: 6)]
					ifFalse: [Color random]]].
	^ aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]