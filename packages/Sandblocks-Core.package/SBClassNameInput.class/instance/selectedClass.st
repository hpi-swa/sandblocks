as yet unclassified
selectedClass

	^ (self contents endsWith: ' class')
		ifTrue: [(Smalltalk at: (self contents allButLast: ' class' size) asSymbol) class]
		ifFalse: [Smalltalk at: self contents asSymbol]