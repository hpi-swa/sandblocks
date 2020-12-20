as yet unclassified
updateSelectionLabels

	| row range |
	row := self submorphs second.
	range := self firstSubmorph selectionBounds.
	row submorphs first contents: range first asString.
	row submorphs second contents: range second asString.
	row submorphs third contents: (self firstSubmorph hasSelection ifTrue: [range second - range first] ifFalse: [self firstSubmorph contents size]) asString