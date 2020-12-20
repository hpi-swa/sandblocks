as yet unclassified
addError: anError process: aProcess

	| error |
	error := SBError new error: anError process: aProcess.
	self addMorphFront: error.
	^ error