as yet unclassified
matches: aBlock

	^ aBlock receiver isName and: [aBlock receiver contents = self name and: [aBlock selector = #after:]]