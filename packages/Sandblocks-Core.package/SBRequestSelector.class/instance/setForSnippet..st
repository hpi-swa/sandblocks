as yet unclassified
setForSnippet: aCollectionOfBlocks

	| arguments |
	arguments := aCollectionOfBlocks gather: #resolveLocalBindings.
	arguments := ((KeyedSet keyBlock: #name) addAll: arguments; yourself) asArray.
	
	editor method: (SBMethod new
		selector: (arguments collect: [:arg | ':']) join
		arguments: (arguments collect: [:arg | SBName contents: arg contents])
		class: aCollectionOfBlocks first containingArtefact methodClass).
	
	editor startInput: editor method at: 1 replacingContents: true