as yet unclassified
deselectAllBut: aNumber

	self optionRows withIndexDo: [:row :rowIndex |
		rowIndex ~= aNumber ifTrue: [
			row firstSubmorph value: false.
			row lastSubmorph localColorPolicy: SBPlainColorPolicy]]