as yet unclassified
selector: aSymbol arguments: aCollection class: aClass

	methodClass := aClass.
	
	self currentSelector ifNil: [self currentSelector: aSymbol asSymbol].
	self currentClass ifNil: [self currentClass: aClass]