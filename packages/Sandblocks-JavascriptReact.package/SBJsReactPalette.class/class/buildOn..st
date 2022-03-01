as yet unclassified
buildOn: aBuilder

	aBuilder addHeader: 'React'.
	SBJsReactComponentRegistry defaultRegistry componentRegistryCategoriesDo: [:categoryName :entries |
		aBuilder addSectionHeader: categoryName.
		entries keysAndValuesDo: [:componentName :component | aBuilder addBlock: componentName as: component]]