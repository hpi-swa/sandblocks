as yet unclassified
selectedClassOrMethod

	^ (self selectedMethodIndex > 0 and: [self methods notEmpty])
		ifTrue: [self selectedMethod]
		ifFalse: [self selectedClassIndex > 0 ifTrue: [Smalltalk at: self selectedClass] ifFalse: [nil]]