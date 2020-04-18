as yet unclassified
postDuplicate

	" this block has been duplicated, adjuts any identifiers if need be "
	self clearCache.
	
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph postDuplicate]].