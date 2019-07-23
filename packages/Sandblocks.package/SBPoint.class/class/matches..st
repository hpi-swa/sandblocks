as yet unclassified
matches: aBlock

	^ (aBlock selector = '@' or: [aBlock selector = ',']) and: [aBlock receiver isNumberBlock] and: [aBlock arguments first isNumberBlock]