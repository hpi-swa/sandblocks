as yet unclassified
deselectAllBut: aNumber

	self submorphs allButFirst withIndexDo: [:row :rowIndex |
		rowIndex ~= aNumber ifTrue: [
			row firstSubmorph value: false.
			row lastSubmorph setProperty: #sandblockBlockColor toValue: Color white; changed]]