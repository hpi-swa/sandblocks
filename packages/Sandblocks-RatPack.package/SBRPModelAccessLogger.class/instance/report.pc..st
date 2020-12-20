as yet unclassified
report: aMethod pc: aNumber

	callList add: (Dictionary new
		at: #method put: aMethod;
		at: #pc put: aNumber;
		yourself).