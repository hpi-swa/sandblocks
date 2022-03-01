*Sandblocks-JavascriptReact
isSubmorphOfRenderMethod

	^ self type = 'method_definition' and: [self access children first contents = 'render']