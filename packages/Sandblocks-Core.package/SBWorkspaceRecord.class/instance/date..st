accessing
date: aDateAndTime

	date := aDateAndTime.
	lastUsed := lastUsed ifNotNil: [aDateAndTime max: lastUsed] ifNil: [aDateAndTime]