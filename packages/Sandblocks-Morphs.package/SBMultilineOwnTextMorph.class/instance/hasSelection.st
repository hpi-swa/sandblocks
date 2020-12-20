as yet unclassified
hasSelection

	^ self cursor ~= 0 and: [self selectionBound ~= self cursor and: [self selectionBound > 0]]