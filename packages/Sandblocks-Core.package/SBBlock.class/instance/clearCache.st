as yet unclassified
clearCache

	" this block may have just been duplicated or moved somewhere else, ensure to clear all caches and present yourself neatly "
	self allMorphsDo: [:morph | morph layoutChanged].
	self allBlocksDo: [:morph | morph ~= self ifTrue: [morph clearCache]].
	self removeProperty: #sandblockBlockColor