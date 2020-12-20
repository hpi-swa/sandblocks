as yet unclassified
parsedContents

	^ self contents ifEmpty: [0] ifNotEmpty: [:num | num asNumber]