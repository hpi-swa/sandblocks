as yet unclassified
writeSourceOn: aStream

	active
		ifTrue: [aStream nextPutAll: '(self halt)']
		ifFalse: [aStream nextPutAll: 'SBHalt deactivated']