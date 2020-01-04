as yet unclassified
matches: aBlock

	^ (aBlock selector = 'asRegex' and: [aBlock receiver isStringBubble]) or:
	[aBlock receiver isName and: [aBlock receiver contents = self name] and: [aBlock selector = 'regex:examples:']]