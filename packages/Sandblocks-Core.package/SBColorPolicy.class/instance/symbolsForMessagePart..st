as yet unclassified
symbolsForMessagePart: aBlock

	^ aBlock hasColon ifTrue: [#(nil ':')] ifFalse: [#(nil nil)]