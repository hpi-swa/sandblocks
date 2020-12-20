as yet unclassified
postDuplicate

	self allBlocksDo: [:morph | morph postDuplicateSelf].
	self detachDecorators: SBMultiSelectionDecorator.
	self clearCache