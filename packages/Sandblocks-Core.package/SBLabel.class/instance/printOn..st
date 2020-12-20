as yet unclassified
printOn: aStream

	aStream nextPutAll: 'label ', (self contents truncateWithElipsisTo: 20)