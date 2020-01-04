as yet unclassified
run: aRequest

	| window |
	window := aRequest openInWindow.
	aRequest resizeToFit.
	window center: ActiveHand position.
	
	[window world notNil] whileTrue: [window outermostWorldMorph doOneCycle].
	
	^ aRequest cancelled ifTrue: [nil] ifFalse: [{aRequest selector. aRequest arguments}]