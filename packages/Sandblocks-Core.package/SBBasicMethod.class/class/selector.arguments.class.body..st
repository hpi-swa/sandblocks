as yet unclassified
selector: aSymbol arguments: aCollection class: aClass body: aBlock

	^ self new
		selector: aSymbol arguments: aCollection class: aClass;
		body: aBlock asSandblock