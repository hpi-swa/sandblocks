as yet unclassified
printOn: aStream

	aStream nextPutAll: 'form from '.
	aStream nextPutAll: (filename size > 20 ifTrue: ['...', (filename last: 20)] ifFalse: [filename])