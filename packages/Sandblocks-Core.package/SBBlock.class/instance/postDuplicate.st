as yet unclassified
postDuplicate

	" this block has been duplicated, adjuts any identifiers if need be "
	self allMorphsDo: [:morph | morph layoutChanged].
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph postDuplicate]]