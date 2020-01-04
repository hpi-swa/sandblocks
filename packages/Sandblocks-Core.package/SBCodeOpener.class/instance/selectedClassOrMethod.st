as yet unclassified
selectedClassOrMethod

	^ self selectedMethodIndex > 0
		ifTrue: [self selectedMethod]
		ifFalse: [self selectedClassIndex > 0 ifTrue: [Smalltalk at: self selectedClass] ifFalse: [nil]]