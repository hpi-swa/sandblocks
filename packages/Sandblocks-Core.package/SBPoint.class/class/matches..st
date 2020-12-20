as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = '@' or: [aBlock selector = ',']) and: [aBlock receiver isNumberBlock] and: [aBlock arguments first isNumberBlock]