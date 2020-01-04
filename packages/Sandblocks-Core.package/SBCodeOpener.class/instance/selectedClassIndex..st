as yet unclassified
selectedClassIndex: aNumber

	selectedClassIndex := aNumber.
	self changed: #selectedClassIndex.
	self changed: #methods.
	self selectedMethodIndex: 0