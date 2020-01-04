as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding and: [aBlock receiver contents = self name] and: [aBlock selector = 'text:']