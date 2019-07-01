as yet unclassified
rightMostBlock

	^ self childSandblocks ifEmpty: [self] ifNotEmpty: [:c | c last rightMostBlock]