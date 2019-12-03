as yet unclassified
selector: aSymbol arguments: aCollection class: aClass

	signature selector: aSymbol arguments: aCollection.
	methodClass := aClass.
	
	classPrefix contents: aClass name, ' >> '