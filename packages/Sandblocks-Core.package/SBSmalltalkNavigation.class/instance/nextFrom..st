as yet unclassified
nextFrom: aBlock

	| next |
	next := SBDepthFirstPreOrderNavigation new nextFrom: aBlock.
	^ self nextWithoutMessageSend: next