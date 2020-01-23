as yet unclassified
send: selector super: supered numArgs: numArgs

	| res |
	res := super send: selector super: supered numArgs: numArgs.
	selector = #basicNew ifTrue: [tempObjects add: res top].
	^ res