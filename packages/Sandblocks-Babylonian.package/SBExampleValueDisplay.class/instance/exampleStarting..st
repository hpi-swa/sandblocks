event handling
exampleStarting: anExample

	display exampleStarting: anExample.
	display noValue.
	self extent: 0 @ 0.
	
	values := OrderedCollection new.
	
	statusLabel contents: '...'.
	hadValue := false