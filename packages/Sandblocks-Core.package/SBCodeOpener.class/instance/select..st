as yet unclassified
select: aNumber

	currentPanelIndex caseOf: {
		[1] -> [self selectedCategoryIndex: selectedCategoryIndex + aNumber].
		[2] -> [self selectedClassIndex: selectedClassIndex + aNumber moved: true].
		[3] -> [self selectedMethodIndex: selectedMethodIndex + aNumber moved: true]
	}