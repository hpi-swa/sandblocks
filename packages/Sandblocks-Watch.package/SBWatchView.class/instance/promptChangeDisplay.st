as yet unclassified
promptChangeDisplay

	| choices index |
	choices := self validDisplaysFor: lastValue.
	
	index := UIManager default chooseFrom: choices.
	index < 1 ifTrue: [^ self].
	
	self useDisplay: (choices at: index)