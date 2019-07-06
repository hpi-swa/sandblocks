as yet unclassified
openForSnippet: aBlock

	| window request |
	request := self new setForSnippet: aBlock.
	window := request openInWindow.
	window center: ActiveHand position.
	
	[window world notNil] whileTrue: [window outermostWorldMorph doOneCycle].
	
	^ request selector