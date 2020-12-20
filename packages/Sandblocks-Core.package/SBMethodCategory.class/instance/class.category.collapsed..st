as yet unclassified
class: aClass category: aString collapsed: aBoolean

	self firstSubmorph contents: aString.
	class := aClass.
	savedCategoryName := aString.
	
	aBoolean ifFalse: [self addMethods]