as yet unclassified
t07Smalltalk

	SBLabel text: [
		'For smalltalk-specific constructs, use its letter to wrap an expression.

For example, press [ on the ifTrue: expression after selecting with shift+k.
Press ^ on the final expression of the method (use G to jump there).'].
	7 squared > 40 ifTrue: (Transcript showln: 'hello').
	42