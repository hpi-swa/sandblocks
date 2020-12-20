*Sandblocks-Core-layout
preferredSizeForWidth: aNumber

	| padding |
	padding := self layoutInset asPoint * 2.
	
	^ ((self layoutPolicy
			ifNotNilDo: [:layout | layout preferredSizeFor: self width: aNumber - padding x]
			ifNil: [
				self flag: #fixme. " vs minimumuExtent vs minExtent? "
				PHSizeRequest fixed: self extent]) adjustFor: self)
		+ padding