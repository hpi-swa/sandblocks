as yet unclassified
affectedArtefacts

	" if we non-edit commands within our list we also may get nil artifacts "
	^ ((self commands gather: #affectedArtefacts) select: #notNil) asSet