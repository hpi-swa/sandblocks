as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding
		and: [aBlock receiver contents = 'Form']
		and: [aBlock selector = 'fromFileNamed:']
		and: [aBlock arguments first isStringBlock]