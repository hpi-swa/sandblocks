as yet unclassified
printOn: aStream

	aStream nextPutAll: 'string '.
	aStream nextPutAll: (self contents truncateWithElipsisTo: 20)