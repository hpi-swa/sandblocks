as yet unclassified
reportTypeInfo: anObject at: aContext findNode: aBlock

	"editor reportTypeInfo: anObject at: aContext findNode: aBlock"
	methodMap at: aContext method sandblocksFastHash ifPresent: [:method | method cacheType: anObject class for: (aBlock value: method)]