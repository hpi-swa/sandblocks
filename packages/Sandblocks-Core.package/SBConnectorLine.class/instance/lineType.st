as yet unclassified
lineType

	^ (self isSelfConnection or: [self evade ~= #none]) ifTrue: [#curve] ifFalse: [lineType]