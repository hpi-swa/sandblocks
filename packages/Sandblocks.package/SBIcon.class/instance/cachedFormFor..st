colors
cachedFormFor: aPoint

	| size |
	size := aPoint x min: aPoint y.
	
	(cachedForm isNil or: [cachedForm extent ~= size asPoint])
		ifTrue: [cachedForm := self class cachedFormSvg: self svg color: self color size: size].
	
	^ cachedForm