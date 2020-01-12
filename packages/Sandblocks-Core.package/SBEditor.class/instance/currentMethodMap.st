accessing
currentMethodMap

	^ self methods collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary