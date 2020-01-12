actions
close

	self containingWindow ifNotNil: #delete.
	self delete.
	self valueOfProperty: #previousWindow ifPresentDo: #delete