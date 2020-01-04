as yet unclassified
zoomViewport: aNumber from: aPoint

	self offset: self offset + ((aPoint - self position) * aNumber * self scale * 0.001).
	self scale: (self scale + (aNumber * self scale * 0.001))