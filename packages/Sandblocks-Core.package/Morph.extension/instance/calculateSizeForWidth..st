*Sandblocks-Core-layout
calculateSizeForWidth: aNumber

	| padding |
	self halt.
	padding := self paddingAsPoint * PHStyleContext scalingFactor.
	
	^ ((self layoutPolicy
			ifNotNilDo: [:layout | layout preferredSizeFor: self width: aNumber - padding x]
			ifNil: [
				self flag: #fixme. " vs minimumuExtent vs minExtent? "
				PHSizeRequest fixed: self extent]) adjustFor: self)
		+ padding