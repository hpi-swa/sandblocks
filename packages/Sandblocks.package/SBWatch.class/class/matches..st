as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBWatch'] and: [aBlock selector = 'report:for:']