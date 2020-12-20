initialize-release
colorPolicy: aPolicy

	colorPolicy := aPolicy.
	self allMorphsDo: #layoutChanged.
	self clearCache.
	self changed