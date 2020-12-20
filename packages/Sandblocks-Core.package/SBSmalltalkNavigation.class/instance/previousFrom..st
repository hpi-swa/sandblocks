as yet unclassified
previousFrom: aBlock

	| previous |
	previous := SBDepthFirstPreOrderNavigation new previousFrom: aBlock.
	^ self previousWithoutMessageSend: previous