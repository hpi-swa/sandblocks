as yet unclassified
deleteBeforeCursor
	<inputAction>
	
	(self actualContents isEmpty and: [self isFirstPart]) ifTrue: [^ self messageSend tryDelete].
	self sandblockEditor deleteBeforeCursor