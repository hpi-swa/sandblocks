as yet unclassified
privateMoveBy: delta 

	super privateMoveBy: delta.
	
	paragraph ifNotNil: [:p | p moveBy: delta]