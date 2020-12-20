as yet unclassified
matches: aMethod

	^ (super matches: aMethod) and: [(aMethod methodClass inheritsFrom: RPApplication) and: [aMethod pragmas anySatisfy: [:p | self validMethods includes: p keyword]]]