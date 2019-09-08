as yet unclassified
forMethod: aMethod

	| ast constructor |
	ast := aMethod methodClass newParser parse: aMethod getSourceFromFile class: aMethod methodClass.
	
	constructor := SBGraphConstructor new.
	ast accept: constructor.
	^ constructor graph autoPlace