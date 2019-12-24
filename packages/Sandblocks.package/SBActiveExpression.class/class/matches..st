as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding
		and: [(#('ActiveExpression' 'SynchronousActiveExpression' 'ManualActiveExpression') includes: aBlock receiver contents)
		and: [aBlock selector = 'on:']]