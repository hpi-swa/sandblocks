as yet unclassified
printOn: aStream

	aStream nextPutAll: 'SBShortcut('.
	ctrl ifTrue: [aStream nextPutAll: 'ctrl+'].
	command ifTrue: [aStream nextPutAll: 'cmd+'].
	aStream nextPutAll: character printString.
	aStream nextPut: $)