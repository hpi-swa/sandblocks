as yet unclassified
symbols

	^ self isMethodBody ifTrue: [#(nil nil)] ifFalse: [self colorPolicy symbolsForBlock: self]