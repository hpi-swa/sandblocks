as yet unclassified
reportValue: anObject name: aString

	display reportValue: anObject.
	label contents: aString.
	hadValue := true.
	
	values add: (SBProbedValue new value: anObject context: thisContext sender sender sender sender sender sender sender)