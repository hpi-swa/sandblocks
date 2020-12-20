as yet unclassified
colorForBlock: aBlock

	^ SBToggledCode
		comment: ''
		active: 2
		do: {[aBlock hasChildSandblocks ifTrue: [Color white] ifFalse: [Color black]]. [Color white]}