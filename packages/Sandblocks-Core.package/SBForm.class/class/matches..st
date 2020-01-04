as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding
		and: [aBlock receiver contents = 'Form']
		and: [aBlock selector = 'fromFileNamed:']
		and: [aBlock arguments first isStringBubble]