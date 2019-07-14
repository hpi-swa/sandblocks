as yet unclassified
newFromReceiver: aNode selector: aSymbol arguments: aCollection

	^ self new
		identifier: aCollection second key;
		expression: aCollection first asSandblock