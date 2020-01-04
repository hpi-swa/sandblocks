as yet unclassified
matches: aBlock

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBToggledCode'] and: [aBlock selector = 'comment:active:do:']