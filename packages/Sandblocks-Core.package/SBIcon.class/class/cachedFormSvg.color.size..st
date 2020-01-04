caching
cachedFormSvg: anSvg color: aColor size: aNumber

	| cache descriptor |
	"cache := FormCache ifNil: [FormCache := LRUCache
		size: 128
		factory: [:iconDescriptor | iconDescriptor renderForm]]."
	
	cache := FormCache ifNil: [FormCache := Dictionary new].
	descriptor := (SBIconDescriptor svg: anSvg color: aColor size: aNumber).
	
	^ cache at: descriptor ifAbsentPut: [descriptor renderForm]