*Sandblocks-Core
truncateMiddleTo: aNumber

	self size <= aNumber ifTrue: [^ self].
	^ ((self first: (aNumber * 0.3) floor), '...'), (self last: (aNumber * 0.7) floor)