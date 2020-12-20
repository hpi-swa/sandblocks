as yet unclassified
newFor: aCollection


	^ aCollection isNumber
		ifTrue: [SBDisplayBarChart new reportValue: aCollection]
		ifFalse: [ | chart |
			chart := SBDisplayBarChart new.
			aCollection do: [:val | chart reportValue: val].
			chart]