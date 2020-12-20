as yet unclassified
createStepMethod: aBlock in: anEditor

	| selector |
	selector := thisContext sender method homeMethod selector allButLast, 'Method'.
	self class class compile: (selector, ' '), aBlock sourceString allButFirst allButLast.
	^ anEditor open: self class class >> selector asSymbol