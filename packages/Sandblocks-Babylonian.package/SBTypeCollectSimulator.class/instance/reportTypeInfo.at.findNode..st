as yet unclassified
reportTypeInfo: anObject at: aContext findNode: aBlock

	aContext method ifNotNil: [:m |
		methodMap at: m sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (aBlock value: method)]]