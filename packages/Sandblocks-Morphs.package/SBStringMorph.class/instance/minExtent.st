layout
minExtent

	^ (self fontToUse widthOfString: self contents) @ self fontToUse height + (self layoutInset * 2)