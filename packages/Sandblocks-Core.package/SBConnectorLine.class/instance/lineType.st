as yet unclassified
lineType

	^ self isSelfConnection ifTrue: [#curve] ifFalse: [lineType]