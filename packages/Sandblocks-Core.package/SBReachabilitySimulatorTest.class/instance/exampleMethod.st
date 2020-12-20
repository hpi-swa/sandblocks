as yet unclassified
exampleMethod

	| a |
	#(21) do: [:num | 5 squared].
	5 > 2 ifTrue: [Transcript showln: 'Hello'] ifFalse: [Transcript showln: 'Bye'].
	a := 5 squared