accessing
currentMethodMap

	^ (self methods select: #exists) collect: [:method | method compiledMethod sandblocksFastHash -> method] as: Dictionary