as yet unclassified
methods

	^ self selectedClassIndex > 0 ifTrue: [
		showingClassSide
			ifTrue: [(Smalltalk at: (self classes at: self selectedClassIndex)) class methodDict keys]
			ifFalse: [(Smalltalk at: (self classes at: self selectedClassIndex)) methodDict keys]] ifFalse: [#()]