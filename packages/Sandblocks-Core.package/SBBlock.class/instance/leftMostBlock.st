as yet unclassified
leftMostBlock

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c first leftMostBlock]