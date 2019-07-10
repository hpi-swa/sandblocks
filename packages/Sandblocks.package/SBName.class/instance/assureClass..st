as yet unclassified
assureClass: aClass

	self class = aClass ifFalse: [self changeClassTo: aClass]