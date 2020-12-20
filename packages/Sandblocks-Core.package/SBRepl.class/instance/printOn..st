artefact protocol
printOn: aStream

	aStream nextPutAll: 'workspace '.
	aStream nextPutAll: (self name truncateWithElipsisTo: 20)