as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'ActiveExpression' and: [aBlock selector = 'on:']]