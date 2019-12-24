as yet unclassified
methods

	^ self selectedClassIndex > 0 ifTrue: [(Smalltalk at: (self classes at: self selectedClassIndex)) methodDict keys] ifFalse: [#()]