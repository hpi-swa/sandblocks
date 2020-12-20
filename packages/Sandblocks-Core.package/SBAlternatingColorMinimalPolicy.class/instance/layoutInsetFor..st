as yet unclassified
layoutInsetFor: aBlock

	^ aBlock isBlockBody ifTrue: [2] ifFalse: (super layoutInsetFor: aBlock)