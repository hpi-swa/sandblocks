as yet unclassified
label: aString

	| headingStream |
	headingLevel := 0.
	headingStream := aString readStream.
	[headingStream next = $#] whileTrue: [headingLevel := headingLevel + 1].
	
	self contents: (aString allButFirst: headingLevel).
	self headingLevel: headingLevel