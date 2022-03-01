*Sandblocks-JavascriptReact
collectJSXElementReplacements

	| jsxElementReplacements |
	jsxElementReplacements := KeyedSet keyBlock: #componentName.
	self submorphsDo: [:morph | jsxElementReplacements addAll: morph collectJSXElementReplacements].
	^ jsxElementReplacements