initialize-release
initialize

	super initialize.
	
	self extent: self class marbleSize.
	self isSync: false