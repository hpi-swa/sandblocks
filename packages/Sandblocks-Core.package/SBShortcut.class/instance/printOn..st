as yet unclassified
printOn: aStream

	aStream nextPutAll: 'SBShortcut('.
	ctrl ifTrue: [aStream nextPutAll: 'ctrl+'].
	command ifTrue: [aStream nextPutAll: 'cmd+'].
	shift ifTrue: [aStream nextPutAll: 'shift+'].
	aStream nextPutAll: character printString.
	aStream nextPut: $)