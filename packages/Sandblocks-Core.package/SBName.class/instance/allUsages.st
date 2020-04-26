as yet unclassified
allUsages

	^ self behavior resolveBinding ifNotNil: [:binding | binding allUsages] ifNil: [#()]