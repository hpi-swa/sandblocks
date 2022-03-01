collecting
collectJSXElementReplacements

	| aSet |
	aSet := super collectJSXElementReplacements.
	aSet
		add: self;
		addAll: self usedComponents.
	^ aSet