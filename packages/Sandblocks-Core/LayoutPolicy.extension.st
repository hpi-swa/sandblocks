Extension { #name : #LayoutPolicy }

{ #category : #'*Sandblocks-Core-layout' }
LayoutPolicy >> ensureLayouted: aMorph [

	aMorph fullBounds
]

{ #category : #'*Sandblocks-Core-layout' }
LayoutPolicy >> preferredSizeFor: aMorph width: aNumber [

	self flag: #fixme. "magic number"
	^ PHSizeRequest fixed: (self minExtentOf: aMorph in: (0 @ 0 extent: aNumber @ 10000))
]
