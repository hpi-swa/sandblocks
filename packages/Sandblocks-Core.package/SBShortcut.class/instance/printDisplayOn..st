as yet unclassified
printDisplayOn: aStream

	aStream.
	command ifTrue: [aStream nextPutAll: 'Cmd+'].
	shift ifTrue: [aStream nextPutAll: 'Shift+'].
	ctrl ifTrue: [aStream nextPutAll: 'Ctrl+'].
	aStream nextPut: character