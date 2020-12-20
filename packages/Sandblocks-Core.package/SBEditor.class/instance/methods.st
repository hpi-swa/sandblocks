accessing
methods

	^ self allBlocksSelect: [:block | block object isCompiledMethod]