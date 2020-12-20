as yet unclassified
markStepCompleted: selector index: index

	(self progress at: selector ifAbsentPut: [Set new]) add: index