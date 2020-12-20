as yet unclassified
selectedCategoryIndex: aNumber

	aNumber < 1
		ifTrue: [selectedCategoryIndex := self categories size]
		ifFalse: [
			aNumber > self categories size
				ifTrue: [selectedCategoryIndex := 1]
				ifFalse: [selectedCategoryIndex := aNumber]].
	
	selectedMethodIndex := 0.
	selectedClassIndex := 0.
	self changed: #selectedCategoryIndex.
	self changed: #classes.
	self changed: #methods.
	self selectedClassIndex: 0 moved: false