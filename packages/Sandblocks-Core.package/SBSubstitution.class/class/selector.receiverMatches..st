as yet unclassified
selector: aString receiverMatches: aMessage

	^ aMessage receiver isBinding and: [self name = aMessage receiver contents and: [aMessage selector = aString]]