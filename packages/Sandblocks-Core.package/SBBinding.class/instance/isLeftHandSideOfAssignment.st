as yet unclassified
isLeftHandSideOfAssignment

	^ self owner isAssignment and: [self owner firstSubmorph = self]