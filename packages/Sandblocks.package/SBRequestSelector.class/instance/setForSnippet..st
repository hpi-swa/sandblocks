as yet unclassified
setForSnippet: aBlock

	| arguments |
	arguments := aBlock resolveLocalBindings.
	
	editor method: (SBMethod new
		signature: (arguments collect: [:arg | ':']) join
		values: (arguments collect: [:arg | SBDeclaration new name: arg contents])
		class: aBlock containingMethod methodClass).
		
	editor startInput: editor method at: 1 replacingContents: true