as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding and: [aBlock receiver contents = self name] and: [aBlock selector = 'report:for:']