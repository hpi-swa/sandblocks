as yet unclassified
colorForBlock: aBlock

	aBlock isBlockBody ifTrue: [
		^ aBlock
			valueOfProperty: #sandblockBlockColor
			ifAbsentPut: [
				(aBlock containingBlock isNil or: [aBlock isMethodBody])
					ifTrue: [aBlock containingArtefact relatedClass sandblockColor]
					ifFalse: [self mutateColor: (self colorForBlock: aBlock containingBlock)]]].
	^ aBlock parentSandblock ifNotNil: [:o | o color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]