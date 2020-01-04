as yet unclassified
matches: aMessage

	(aMessage receiver isBinding and: [#('Color' 'ECSColor') includes: aMessage receiver contents]) ifFalse: [^ false].
	
	^ aMessage selector asSymbol isUnary
		ifTrue: [(Smalltalk at: aMessage receiver contents asSymbol) respondsTo: aMessage selector asSymbol]
		ifFalse: [(aMessage selector = 'r:g:b:' or: [aMessage selector = 'r:g:b:a:']) and: [aMessage arguments allSatisfy: #isLiteralBlock]]