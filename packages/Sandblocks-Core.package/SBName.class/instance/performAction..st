as yet unclassified
performAction: aSymbol

	(self behavior respondsTo: aSymbol) ifTrue: [self behavior perform: aSymbol] ifFalse: [super performAction: aSymbol]