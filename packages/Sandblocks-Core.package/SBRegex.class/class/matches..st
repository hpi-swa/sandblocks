as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = 'asRegex' and: [aBlock receiver isStringBlock]) or:
	[aBlock receiver isName and: [aBlock receiver contents = self name] and: [aBlock selector = 'regex:examples:']]