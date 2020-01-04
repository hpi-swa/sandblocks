as yet unclassified
selectedCategoryIndex: aNumber

	selectedCategoryIndex := aNumber.
	selectedMethodIndex := 0.
	selectedClassIndex := 0.
	self changed: #selectedCategoryIndex.
	self changed: #classes.
	self changed: #methods.
	self selectedClassIndex: 0