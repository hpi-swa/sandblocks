event handling
exampleFinished: anExample 

	"display exampleFinished: anExample."
	
	statusLabel contents: (hadValue
		ifTrue: ['']
		ifFalse:  ['- Not reached -'])