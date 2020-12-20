as yet unclassified
newFor: aMessageSend

	| args |
	args := aMessageSend arguments.
	^ self new
		expression: args first;
		identifier: args second parsedContents;
		yourself