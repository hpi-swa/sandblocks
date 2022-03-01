*Sandblocks-JavascriptReact
suggestionsForInsert: aCommand

	(aCommand element compatibleWithType: 'jsx_element') ifTrue: [
		^ SBJsReactComponentRegistry defaultRegistry componentRegistryComponents collect: [:association |
			(SBInsertSuggestionItem
				selector: '<', association key, '/>'
				label: association key)
				morph: association value buildCopy
				previewOnly: false]].
	^ #()