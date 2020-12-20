*Sandblocks-Core
with: otherCollection and: thirdCollection do: threeArgBlock

	self isOfSameSizeCheck: otherCollection.
	self isOfSameSizeCheck: thirdCollection.
	
	1 to: self size do: [:index |
		threeArgBlock value: (self at: index) value: (otherCollection at: index) value: (thirdCollection at: index)]