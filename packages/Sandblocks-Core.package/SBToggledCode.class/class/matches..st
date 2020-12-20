as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock receiver isBinding and: [aBlock receiver contents = 'SBToggledCode'] and: [aBlock selector = 'comment:active:do:']