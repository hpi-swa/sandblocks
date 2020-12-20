as yet unclassified
matches: aMessage

	SBExample
		self: [SBColor]
		args: [{(SBMessageSend new receiver: (SBName contents: 'Color') selector: #orange)}]
		label: 'matching'.
	SBExample
		self: [SBColor]
		args: [{(SBMessageSend new receiver: (SBName contents: 'Color') selector: #fromUser)}]
		label: 'non matching'.
	
	(super matches: aMessage) ifFalse: [^ false].
	
	(aMessage receiver isBinding and: [#('Color' 'ECSColor') includes: aMessage receiver contents]) ifFalse: [^ false].
	^ aMessage selector asSymbol isUnary
		ifTrue: [
			(Color respondsTo: aMessage selector asSymbol)
				and: [#('named colors' 'named colors - crayons') includes: (Color class organization categoryOfElement: aMessage selector asSymbol)]]
		ifFalse: [(aMessage selector = 'r:g:b:' or: [aMessage selector = 'r:g:b:a:']) and: [aMessage arguments allSatisfy: #isLiteralBlock]]